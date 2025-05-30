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

        loginManager.startSignInWithAppleFlow { identityToken in
            Task {
                await AuthService.shared.exchangeAppleToken(identityToken: identityToken, appState: appState)

                DispatchQueue.main.async {
                    self.isLoading = false

                    guard appState.isLoggedIn,
                          let accessToken = TokenManager.shared.getAccessToken(),
                          let claims = JWTDecoder.decode(token: accessToken),
                          let role = claims.role else {
                        self.errorMessage = "로그인 실패 혹은 권한 확인 실패"
                        return
                    }

                    switch role {
                    case "GUEST":
                        appState.nextScreen = .signUpTerms
                    case "USER":
                        appState.nextScreen = .home
                    default:
                        self.errorMessage = "알 수 없는 사용자 유형"
                    }
                }
            }
        }
    }


}
