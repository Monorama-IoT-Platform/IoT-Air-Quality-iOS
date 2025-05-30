//
//  AppState.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/23/25.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = TokenManager.shared.getAccessToken() != nil
}
/Users/hyungjunlee/Developer/IoT-Air-Quality-iOS/IoT-Air-Quality-iOS/ViewModels/AppState.swift
