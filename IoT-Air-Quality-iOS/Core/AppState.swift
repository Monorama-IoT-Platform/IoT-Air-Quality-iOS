//
//  AppState.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/23/25.
//

import Foundation

enum AppScreen {
    case login
    case signUpTerms
    case signUpRegister
    case disconnectedMain
//    case main
}

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var nextScreen: AppScreen = .login
    @Published var signupPrefillInfo: UserSignupInfo? = nil
    
    // 🔵 Bluetooth 연결 상태 추가
    @Published var isConnected: Bool = false
    @Published var connectedDeviceName: String = ""
    @Published var connectedDeviceMac: String = ""
}
