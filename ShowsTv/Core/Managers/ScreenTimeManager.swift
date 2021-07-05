//
//  ScreenTimeManager.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 01/07/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class ScreenTimeManager {
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Properties
    static let shared = ScreenTimeManager()
    
    private var startTime: [String: Date] = [String: Date]()
    private let viewControllersToSaveScreenTime = [ShowsTableViewController.self, EpisodeViewController.self]
    private let minScreenTimeForUserEngagement: TimeInterval = 5
    
    // MARK: - Public Methods
    private func getScreenTime(for viewControllerType: UIViewController.Type) -> TimeInterval? {
        if viewControlleIsOnSaveList(viewControllerType) {
            return getScreenTimeFromUserDefault(for: viewControllerType)
        }
        return nil
    }
    
    private func getScreenTimeFromUserDefault(for viewControllerType: UIViewController.Type)  -> TimeInterval {
        let key = UserDefaultsKeys.screenTimeCounter.getCompoundKey(otherKey: String(describing: viewControllerType))
        return UserDefaults.standard.double(forKey: key)
    }
        
    private func startCountScreenTime(for viewController: UIViewController) {
        startTime[String(describing:type(of: viewController))] = Date()
        registerScreenViewEvent(for: viewController)
    }
    
    private func stopCountScreenTime(for viewController: UIViewController) {
        guard let startTime = startTime[String(describing:type(of: viewController))] else { return }
        let interval = Date().getTimeIntervalFrom(startTime)
        saveScreenTime(for: type(of: viewController), screenTime: interval)
    }
    
    private func saveScreenTime(for viewControllerType: UIViewController.Type, screenTime: TimeInterval?) {
        if viewControlleIsOnSaveList(viewControllerType) {
            let currentScreenTime = getScreenTimeFromUserDefault(for: viewControllerType)
            let newScreenTime = screenTime == nil ? nil : currentScreenTime + screenTime!
            UserDefaults.standard.set(newScreenTime, forKey: UserDefaultsKeys.screenTimeCounter.getCompoundKey(otherKey: String(describing: viewControllerType)))
        }
    }
    
    private func registerScreenViewEvent(for viewController: UIViewController) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: String(describing: type(of: viewController)),
                                        AnalyticsParameterScreenClass: String(describing: type(of: viewController))])
    }
    
    private func viewControlleIsOnSaveList(_ viewControllerType: UIViewController.Type) -> Bool {
        return viewControllersToSaveScreenTime.contains { $0 == viewControllerType }
    }
    
    // MARK: - Public Methods
    public func isUserEngagedOnSomeScreen() -> Bool {
        for viewControllerType in viewControllersToSaveScreenTime {
            if let screenTime = getScreenTime(for: viewControllerType) {
                if screenTime >= minScreenTimeForUserEngagement {
                    return true
                }
            }
        }
        return false
    }
    
    public func screenTimeCounter(state: ScreenTimeCounterState, viewController: UIViewController) {
        switch state {
        case .started:
            startCountScreenTime(for: viewController)
        case .stopped:
            stopCountScreenTime(for: viewController)
        }
    }
    
    public func resetScreenTimes() {
        for viewControllerType in viewControllersToSaveScreenTime {
            saveScreenTime(for: viewControllerType, screenTime: nil)
        }
    }
}
