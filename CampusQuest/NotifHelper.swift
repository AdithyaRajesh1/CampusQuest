import Foundation
import UserNotifications

class NotifHelper: NSObject, UNUserNotificationCenterDelegate {
    static var shared = NotifHelper()

    func setupNotifs() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { ok, err in
            if ok {
                self.makeDaily()
                self.makeSoon()
            }
        }
    }

    func makeSoon() {
        let content = UNMutableNotificationContent()
        content.title = "Campus Quest"
        content.body = "You haven't done anything interesting today. Open Campus Quest for a challenge."
        content.sound = UNNotificationSound.default
        let trig = UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)
        let req = UNNotificationRequest(identifier: "soon", content: content, trigger: trig)
        UNUserNotificationCenter.current().add(req)
    }

    func makeDaily() {
        let content = UNMutableNotificationContent()
        content.title = "Campus Quest"
        content.body = "You haven't done anything interesting today. Open Campus Quest for a challenge."
        content.sound = UNNotificationSound.default
        var comps = DateComponents()
        comps.hour = 18
        comps.minute = 0
        let trig = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let req = UNNotificationRequest(identifier: "daily", content: content, trigger: trig)
        UNUserNotificationCenter.current().add(req)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
