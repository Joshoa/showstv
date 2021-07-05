//
//  AppDelegate.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 12/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    let crashManager = CrashManager.shared
    let appReviewManager = AppReviewManager.standard
    let screenTimeManager = ScreenTimeManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "pinkish")!]
        FirebaseApp.configure()
        crashLyticsCheckForUnsentReports()
        appReviewManager.increaseAmountOfTimesAppWasOpen()
        screenTimeManager.resetScreenTimes()
        
        return true
    }
    
    func crashLyticsCheckForUnsentReports() {
        if Crashlytics.crashlytics().didCrashDuringPreviousExecution() {
            crashManager.increaseNumberOfCrashes()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.sharedInstance.saveContext()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

