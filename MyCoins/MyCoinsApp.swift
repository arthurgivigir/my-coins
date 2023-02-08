//
//  MyCoinsApp.swift
//  MyCoins
//
//  Created by Arthur Givigir on 2/20/21.
//

import SwiftUI
import MyCoinsServices
import CloudKit

@main
struct MyCoinsApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .preferredColorScheme(.dark)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Register for Remote Notifications
        application.registerForRemoteNotifications()
        return true
    }
    //No callback in simulator -- must use device to get valid push token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("🚧 token \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("🚧 \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let notification: CKNotification =
                CKNotification(fromRemoteNotificationDictionary:
                                userInfo as! [String : NSObject])!

        if (notification.notificationType ==
            CKNotification.NotificationType.query) {

            let queryNotification =
                notification as! CKQueryNotification

            guard let recordID = queryNotification.recordID else {
                return
            }
            
            CoinFetcher.shared.getServicesInformation(with: recordID)
        }
    }
}

// MARK: Tests with launch screen
//public extension UIApplication {
//
//    func clearLaunchScreenCache() {
//        do {
//            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
//        } catch {
//            print("Failed to delete launch screen cache: \(error)")
//        }
//    }
//
//}
