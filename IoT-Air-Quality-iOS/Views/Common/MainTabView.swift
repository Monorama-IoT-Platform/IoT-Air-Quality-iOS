import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // 실제 구현된 HomeView로 교체 필요
            Text("Home View")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            // 실제 구현된 HistoryView로 교체 필요
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
