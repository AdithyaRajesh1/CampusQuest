import SwiftUI

struct ContentView: View {
    @State var loggedIn = false

    var body: some View {
        if loggedIn {
            TabView {
                HomeScreen()
                    .tabItem {
                        Text("Home")
                    }
                HistoryScreen()
                    .tabItem {
                        Text("History")
                    }
                AddChallenge()
                    .tabItem {
                        Text("Submit")
                    }
            }
        } else {
            LoginScreen(loggedIn: $loggedIn)
        }
    }
}

#Preview {
    ContentView()
}
