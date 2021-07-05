//
//  AppReviewManager.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 25/06/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit
import StoreKit

class AppReviewManager {
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Properties
    static let standard = AppReviewManager()
    
    private let app = UIApplication.shared
    private let crashManager = CrashManager.shared
    let screenTimeManager = ScreenTimeManager.shared
    
    private let scoreLimit = 4
    private let minLastReviewRequestInterval = 15
    private let maxNumberOfReviewRequestsForBuild = 3
    private let minAmountOfTimesAppWasOpenInARow = 10
    private let minDaysInARowForUserEngagement = 3
    
    private var score: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.scoreAppReviewManager.rawValue)
        }
        
        set(newScore) {
            UserDefaults.standard.set(newScore, forKey: UserDefaultsKeys.scoreAppReviewManager.rawValue)
        }
    }
    
    private var numberOfReviewRequestsForBuild: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.numberOfReviewRequestsForBuild.rawValue)
        }
        
        set(newNumberOfReviewRequests) {
            UserDefaults.standard.set(newNumberOfReviewRequests, forKey: UserDefaultsKeys.numberOfReviewRequestsForBuild.rawValue)
        }
    }
    
    private var amountOfTimesAppWasOpenInARow: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.amountOfTimesAppWasOpenInARow.rawValue)
        }
        
        set(newAmountOfTimesAppWasOpen) {
            UserDefaults.standard.set(newAmountOfTimesAppWasOpen, forKey: UserDefaultsKeys.amountOfTimesAppWasOpenInARow.rawValue)
        }
    }
    
    private var daysInARowAppWasOpen: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.daysInARowAppWasOpen.rawValue)
        }
        
        set(newAmountOfTimesAppWasOpen) {
            UserDefaults.standard.set(newAmountOfTimesAppWasOpen, forKey: UserDefaultsKeys.daysInARowAppWasOpen.rawValue)
        }
    }
    
    private var lastTimeAppWasOpen: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.lastTimeAppWasOpen.rawValue) as! Date?
        }
        
        set(newTimeReviewWasPresente) {
            UserDefaults.standard.set(newTimeReviewWasPresente, forKey: UserDefaultsKeys.lastTimeAppWasOpen.rawValue)
        }
    }
    
    private var lastTimeReviewWasPresented: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.lastReviewDate.rawValue) as! Date?
        }
        
        set(newTimeReviewWasPresente) {
            UserDefaults.standard.set(newTimeReviewWasPresente, forKey: UserDefaultsKeys.lastReviewDate.rawValue)
        }
    }
    
    private var lastVersionPromptedForReview: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey.rawValue)
        }
        
        set(newPromptedVersion) {
            UserDefaults.standard.set(newPromptedVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey.rawValue)
        }
    }
    
    private var currentAppBuildVersion: String {
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary") }
        return currentVersion
    }
    
    private var shouldRequestReview: Bool {
//        userIsEngaged() && reviewRequestQuantityLimitNotReachedForBuild() && isTimeRequestReviewAgain() && screenTimeManager.isUserEngagedOnSomeScreen() && crashManager.lastCrashIsOld() && scoreOfHappynessLimitReached()
        if screenTimeManager.isUserEngagedOnSomeScreen() {
            return true
        }
        return false
    }
    
    // MARK: - Manager AppReview Methods
    private func reviewRequestQuantityLimitNotReachedForBuild() -> Bool {
        if (currentAppBuildVersion == lastVersionPromptedForReview) {
            return numberOfReviewRequestsForBuild < maxNumberOfReviewRequestsForBuild
        }
        numberOfReviewRequestsForBuild = 0
        return true
    }
    
    private func isTimeRequestReviewAgain() -> Bool {
        guard let lastTimeReviewWasPresented = lastTimeReviewWasPresented else { return true }
        let lastRequestReviewInterval = Calendar.current.numberOfDaysBetween(lastTimeReviewWasPresented, and: Date())
        print("lastRequestReviewInterval: \(lastRequestReviewInterval)")
        return lastRequestReviewInterval >= minLastReviewRequestInterval
    }
    
    private func userIsEngaged() -> Bool {
        return daysInARowAppWasOpen >= minDaysInARowForUserEngagement && amountOfTimesAppWasOpenInARow >= minAmountOfTimesAppWasOpenInARow
    }
    
    private func scoreOfHappynessLimitReached() -> Bool {
        return score >= scoreLimit
    }
    
    private func resetUserEngagementTrack() {
        daysInARowAppWasOpen = 0
        amountOfTimesAppWasOpenInARow = 0
    }
    
    public func increaseScore() {
        score += 1
    }
    
    public func decreaseScore() {
        score -= 1
    }
    
    public func increaseAmountOfTimesAppWasOpen() {
        amountOfTimesAppWasOpenInARow += 1
        let numberOfDaysBetweenLastTimeAppWasOpenAndNow = lastTimeAppWasOpen != nil ?  Calendar.current.numberOfDaysBetween(lastTimeAppWasOpen!, and: Date()) : 0
        if numberOfDaysBetweenLastTimeAppWasOpenAndNow > 1 {
            resetUserEngagementTrack()
        } else if numberOfDaysBetweenLastTimeAppWasOpenAndNow == 1 {
            daysInARowAppWasOpen += 1
        }
        self.lastTimeAppWasOpen = Date()
    }
    
    private func updateAppReviewProps() {
        lastTimeReviewWasPresented = Date()
        self.lastVersionPromptedForReview = self.currentAppBuildVersion
        numberOfReviewRequestsForBuild += 1
    }
    
    
    // MARK: - Present Review Methods
    private func presentReviewRequest() {
        let twoSecondsFromNow = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
            SKStoreReviewController.requestReview()
        }
    }
    
    private func reviewOnAppStore() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/idXXXXXXXXXX?action=write-review")
            else { fatalError("Expected a valid URL") }
        app.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    public func askForReview(asPopup: Bool) {
        guard shouldRequestReview else { return }
        if asPopup {
            presentReviewRequest()
        } else {
            reviewOnAppStore()
        }
        updateAppReviewProps()
    }
}
