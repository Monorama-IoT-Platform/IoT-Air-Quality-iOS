//
//  AuthService.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/23/25.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    
    private let baseURL = APIConstants.baseURL
    private let session = URLSession.shared

    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = TokenManager.shared.getRefreshToken() else {
            print("❌ No refresh token found")
            completion(false)
            return
        }

        guard let url = URL(string: "\(baseURL)/api/v1/auth/register/refresh") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                print("❌ Refresh failed: \(error?.localizedDescription ?? "unknown error")")
                completion(false)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ServerResponse<TokenData>.self, from: data)
                TokenManager.shared.saveAccessToken(decoded.data.accessToken)
                completion(true)
            } catch {
                print("❌ Token decode error: \(error)")
                completion(false)
            }
        }.resume()
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = TokenManager.shared.getRefreshToken() else {
            completion(false)
            return
        }

        guard let url = URL(string: "\(baseURL)/api/v1/air-quality-data/auth/logout") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("✅ 서버 로그아웃 성공")
                TokenManager.shared.clearTokens()
                completion(true)
            } else {
                print("❌ 서버 로그아웃 실패: \(error?.localizedDescription ?? "")")
                completion(false)
            }
        }.resume()
    }

    func exchangeAppleToken(identityToken: String, appState: AppState) async {
        guard let url = URL(string: "\(baseURL)/api/v1/auth/login/apple") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["identityToken": identityToken])

        let session = URLSession(configuration: .default,
                                 delegate: CustomSessionDelegate(),
                                 delegateQueue: nil)

        do {
            let (data, response) = try await session.data(for: request)

            print("🔽 서버 원본 응답:")
            print(String(data: data, encoding: .utf8) ?? "No readable data")

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoded = try JSONDecoder().decode(ServerResponse<TokenData>.self, from: data)
                print("✅ Apple 토큰 교환 성공")

                TokenManager.shared.saveAccessToken(decoded.data.accessToken)
                TokenManager.shared.saveRefreshToken(decoded.data.refreshToken)

                DispatchQueue.main.async {
                    appState.isLoggedIn = true
                }

            } else {
                print("❌ 서버 응답 오류: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
        } catch {
            print("❌ 요청 실패: \(error.localizedDescription)")
        }
    }    
}

// 로컬 테스트 용 코드 : 나중에 삭제 필요
class CustomSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
