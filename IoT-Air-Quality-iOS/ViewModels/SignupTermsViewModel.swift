//
//  SignupTermsViewModel.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/26/25.
//

import Foundation

final class SignupTermsViewModel: ObservableObject {
    @Published var terms: [Term?] = [nil, nil] // 2개 고정
    @Published var agreements: [Bool] = Array(repeating: false, count: 2)
    
    private let baseURL = APIConstants.baseURL

    var allAgreed: Bool {
        agreements.allSatisfy { $0 }
    }

    func loadTerms() {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("❌ Access token 없음")
            return
        }

        SignupTermsService.shared.fetchTerms(accessToken: accessToken) { fetchedTerms in
            DispatchQueue.main.async {
                if let fetchedTerms = fetchedTerms {
                    for term in fetchedTerms {
                        if term.type == "privacy-policy" {
                            self.terms[0] = term
                        } else if term.type == "terms-of-service" {
                            self.terms[1] = term
                        }
                    }
                } else {
                    print("❌ 약관 로딩 실패")
                }
            }
        }
    }

    func resetAgreements() {
        agreements = Array(repeating: false, count: 2)
    }

    func titleFor(index: Int) -> String {
        switch index {
        case 0: return "Privacy Policy"
        case 1: return "Terms of Service"
        default: return ""
        }
    }

    func contentFor(index: Int) -> String {
        terms[index]?.content ?? "(내용을 불러올 수 없습니다)"
    }
    
    func determineNextScreen(appState: AppState) {
        guard let accessToken = TokenManager.shared.getAccessToken(),
              let claims = JWTDecoder.decode(token: accessToken),
              let role = claims.role else { return }

        switch role {
        case "GUEST":
            appState.nextScreen = .signUpRegister
        case "HD_USER":
            registerAirQualityRole(accessToken: accessToken) {
                appState.nextScreen = .disconnectedMain
            } // 추후 .main으로 수정 필요
        case "PM":
            appState.nextScreen = .disconnectedMain
        default:
            break
        }
    }
    
    private func registerAirQualityRole(accessToken: String, completion: @escaping () -> Void) {
        print("🔁 PATCH 요청 시작")

        guard let url = URL(string: "\(baseURL)/api/v1/auth/register/air-quality-data/role") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = "{}".data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            print("✅ 응답 수신")

            guard let data = data, error == nil else {
                print("❌ API 요청 실패: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
                print("📦 decoded: \(decoded)")

                if decoded.success, let tokens = decoded.data {
                    TokenManager.shared.saveAccessToken(tokens.accessToken)
                    TokenManager.shared.saveRefreshToken(tokens.refreshToken)
                    print("🟢 화면 이동 시작")
                    DispatchQueue.main.async {
                        completion()
                    }
                } else {
                    print("❌ 응답 오류 또는 실패")
                }
            } catch {
                print("❌ JSON 파싱 실패: \(error.localizedDescription)")
            }
        }.resume()
    }

}
