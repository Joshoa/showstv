//
//  CrashManager.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 28/06/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation

class CrashManager {
    // MARK: - Init
    private init() {}
    
    // MARK: - Properties
    static let shared = CrashManager()
    let minLastCrashDaysInterval = 3
    
    private var numberOfCrashes: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.numberOfCrashes.rawValue)
        }
        
        set(newNumber) {
            UserDefaults.standard.set(newNumber, forKey: UserDefaultsKeys.numberOfCrashes.rawValue)
        }
    }
    
    public var lastCrashDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.lastCrashDate.rawValue) as! Date?
        }
        
        set(newDate) {
            UserDefaults.standard.set(newDate, forKey: UserDefaultsKeys.lastCrashDate.rawValue)
        }
    }
    
    // MARK: - Methods
    public func getCrashes() -> Int {
        return numberOfCrashes
    }
    
    public func increaseNumberOfCrashes() {
        numberOfCrashes += 1
        lastCrashDate = Date()
    }
    
    public func getLastCrashDateString() -> String? {
        guard let lastCrashDate = lastCrashDate?.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss") else {
            return nil
        }
        return lastCrashDate
    }
    
    public func lastCrashIsOld() -> Bool {
        guard let lastCrashDate = lastCrashDate else {
            return true
        }
        let interval = Calendar.current.numberOfDaysBetween(lastCrashDate, and: Date())
        return interval >= minLastCrashDaysInterval
    }
}
