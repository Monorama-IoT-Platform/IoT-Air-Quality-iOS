//
//  IoT_Air_Quality_iOSApp.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/21/25.
//

import SwiftUI

@main
struct IoT_Air_Quality_iOSApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
//            LoginView().environmentObject(appState)
            
//            if appState.isLoggedIn {
//                MainView()
//                    .environmentObject(appState)
//            } else {
//                LoginView()
//                    .environmentObject(appState)
//            }
        }
    }
}
