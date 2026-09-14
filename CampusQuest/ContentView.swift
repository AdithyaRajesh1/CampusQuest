import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Text("Home")
                }
            HistoryScreen()
                .tabItem {
                    Text("History")
                }
        }
    }
}

#Preview {
    ContentView()
}
