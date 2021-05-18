//
//  TVmazeStructs.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 12/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation

public struct ShowImage: Codable {
    let medium: String?
    let original: String?
}

public struct ShowSchedule: Codable {
    let time: String
    let days: [String]
    
    var scheduleAsString: String {
        return "At \(time) on \(days.joined(separator:", "))"
    }
}

public struct SearchShowResponseObject: Codable {
    let show: Show
}
