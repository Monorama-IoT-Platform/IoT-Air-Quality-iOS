//
//  SignupRegisterViewModel.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/27/25.
//

import Foundation

final class SignupRegisterViewModel: ObservableObject {
    private let baseURL = APIConstants.baseURL
    
    func patchRegistration(request: SignupRegisterRequest, completion: @escaping (Bool) -> Void) {
        guard let accessToken = TokenManager.shared.getAccessToken(),
              let url = URL(string: "\(baseURL)/api/v1/auth/register/air-quality-data") else {
            completion(false)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = try? JSONEncoder().encode(request)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ 네트워크 오류: \(error?.localizedDescription ?? "알 수 없음")")
                completion(false)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
                if decoded.success, let tokens = decoded.data {
                    TokenManager.shared.saveAccessToken(tokens.accessToken)
                    TokenManager.shared.saveRefreshToken(tokens.refreshToken)
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    print("❌ 응답 실패 또는 토큰 없음")
                    completion(false)
                }
            } catch {
                print("❌ JSON 파싱 실패: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }
}
