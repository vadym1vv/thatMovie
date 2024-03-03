//
//  NovificationViewModel.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 22.12.2023.
//

import Foundation
import UserNotifications
import UIKit

class NotificationVM {
   
    func ascPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if (success) {
                print("Access granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }    
    }

    func sendNotification(identifier: String, date: Date, type: String, timeInterval: Double = 10, title: String, body: String, allowSound: Bool) {
        ascPermission()
        var trigger: UNNotificationTrigger?
        if type == "date" {
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "time" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if (allowSound) {
            content.sound = UNNotificationSound.default
        }
   
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
//    func setNotificationForAllWatchedMovies(movieItem: [MovieItem], yearsFromNow: Int, title: String) {
//        movieItem.forEach { movie in
//            var dateToSet = Date.now
//            if let calculatedDate = Calendar.current.date(byAdding: .year, value: yearsFromNow, to: Date()) {
//                if (Date.now < calculatedDate) {
//                    dateToSet = calculatedDate
//                }
//            }
//            sendNotification(identifier: String(movie.id!), date: dateToSet, type: "date", title: title, body: "Consider to rewatch: \(movie.title)")
//        }
//    }
    
    func removePendingNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func removieAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    private var router: Router = Router.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {        
        router.reset()
        router.path.append(Int(response.notification.request.identifier)!)
            completionHandler()
        }
}
