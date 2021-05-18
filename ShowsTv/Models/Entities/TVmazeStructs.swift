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

public struct SearchPeopleResponseObject: Codable {
    let person: Person
}

public struct CastcreditsResponse: Codable {
    let links: CastcreditsResponseLink
    
    private enum CodingKeys: String, CodingKey {
           case links = "_links"
    }
    
}

public struct CastcreditsResponseLink: Codable {
    let show: ShowCastcreditsResponse
}

public struct ShowCastcreditsResponse: Codable {
    let href: String
    
    var showId: String {
        return href.components(separatedBy: "/shows/")[1]
    }
}
