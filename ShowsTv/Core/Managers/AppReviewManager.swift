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
    private let app = UIApplication.shared
    
    static let standard = AppReviewManager()
    
    private let scoreLimit = 4
    
    private var score: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.scoreAppReviewManager)
        }
        
        set(newScore) {
            UserDefaults.standard.set(newScore, forKey: UserDefaultsKeys.scoreAppReviewManager)
        }
    }
    
    private var lastVersionPromptedForReview: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
        }
        
        set(newPromptedVersion) {
            UserDefaults.standard.set(newPromptedVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
        }
    }
    
    private var shouldRequestReview: Bool {
        if score >= scoreLimit && (currentAppBuildVersion != lastVersionPromptedForReview) {
            return true
        }
        return false
    }
    
    private var currentAppBuildVersion: String {
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary") }
        return currentVersion
    }
    
    // MARK: - Methods
    private func presentReviewRequest() {
        let twoSecondsFromNow = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
            SKStoreReviewController.requestReview()
            self.lastVersionPromptedForReview = self.currentAppBuildVersion
        }
    }
    
    private func reviewOnAppStore() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/idXXXXXXXXXX?action=write-review")
            else { fatalError("Expected a valid URL") }
        app.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    func askForReview(asPopup: Bool) {
        guard shouldRequestReview else { return }
        if asPopup {
            presentReviewRequest()
        } else {
            reviewOnAppStore()
        }
    }
    
    func increaseScore() {
        score += 1
    }
}
