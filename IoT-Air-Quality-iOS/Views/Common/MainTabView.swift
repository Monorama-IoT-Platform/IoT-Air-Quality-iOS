//
//  MainTabView.swift
//  IoT-Air-Quality-iOS
//
//  Created by HyungJun Lee on 5/28/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            // 연결 여부에 따라 Home 뷰 분기
            Group {
                if appState.isConnected {
                    ConnectedView()
                } else {
                    DisconnectedView()
                }
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }

            Text("History View")
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppState())
    }
}
