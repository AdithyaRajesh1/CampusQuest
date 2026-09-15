import SwiftUI

@main
struct CampusQuestApp: App {
    init() {
        NotifHelper.shared.setupNotifs()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
