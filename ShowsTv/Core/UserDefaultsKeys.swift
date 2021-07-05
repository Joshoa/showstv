//
//  UserDefaultsKeys.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 25/06/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case scoreAppReviewManager = "scoreAppReviewManager"
    case lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"
    case numberOfCrashes = "numberOfCrashes"
    case lastCrashDate = "lastCrashDate"
    case lastReviewDate = "lastReviewDate"
    case numberOfReviewRequestsForBuild = "numberOfReviewRequestsForBuild"
    case amountOfTimesAppWasOpenInARow = "amountOfTimesAppWasOpenInARow"
    case daysInARowAppWasOpen = "daysInARowAppWasOpen"
    case lastTimeAppWasOpen = "lastTimeAppWasOpen"
    case screenTimeCounter = "screenTimeCounter"
    
    public func getCompoundKey(otherKey: String) -> String {
        return self.rawValue + "-" + otherKey
    }
}
