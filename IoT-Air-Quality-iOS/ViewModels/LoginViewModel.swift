//
//  LoginViewModel.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/26/25.
//


import Foundation

final class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    let loginManager = AppleLoginManager()

    func handleAppleLogin(appState: AppState) {
        isLoading = true
        errorMessage = nil

        loginManager.startSignInWithAppleFlow { identityToken, name, email in
            // 로그인 취소 또는 실패 시
            guard !identityToken.isEmpty else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "로그인이 취소되었거나 실패하였습니다."
                }
                return
            }

            appState.signupPrefillInfo = UserSignupInfo(name: name, email: email)

            Task {
                await AuthService.shared.exchangeAppleToken(identityToken: identityToken, appState: appState)

                DispatchQueue.main.async {
                    self.isLoading = false

                    guard appState.isLoggedIn,
                          let accessToken = TokenManager.shared.getAccessToken(),
                          let claims = JWTDecoder.decode(token: accessToken),
                          let role = claims.role,
                          let uid = claims.uid else {
                        self.errorMessage = "로그인 실패 혹은 권한 확인 실패"
                        return
                    }

                    // 테스트용 : 삭제 필요
                    print(uid)
                    print(role)
                    switch role {
                    case "GUEST", "HD_USER", "PM":
                        appState.nextScreen = .signUpTerms
                    case "AQD_USER", "BOTH_USER":
                        appState.nextScreen = .disconnectedMain // 추후 수정 필요
//                    case "AQD_USER":
//                        appState.nextScreen = .home
//                    case "HD_USER":
//                        appState.nextScreen = .home
//                    case "BOTH_USER":
//                        appState.nextScreen = .home
                    default:
                        self.errorMessage = "알 수 없는 사용자 유형"
                    }
                }
            }
        }
    }


}
