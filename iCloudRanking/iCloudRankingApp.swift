//
//  iCloudRankingApp.swift
//  iCloudRanking
//
//  Created by JAVIER CALATRAVA LLAVERIA on 24/4/25.
//

import SwiftUI
import CloudKit

@main
struct iCloudRankingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("📩 Received silent notification")

        if CKNotification(fromRemoteNotificationDictionary: userInfo) != nil {
            NotificationCenter.default.post(name: .cloudKitUpdate, object: nil)
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
}

extension Notification.Name {
    static let cloudKitUpdate = Notification.Name("cloudKitUpdate")
}
