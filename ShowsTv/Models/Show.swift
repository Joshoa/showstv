//
//  Show.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 12/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation

public class Show: Codable {
    var id: Int = 0
    var name: String?
    var image: ShowImage?
    var schedule: ShowSchedule?
    var genres: [String]?
    var summary: String?
    
    var genresAsString: String {
        return genres == nil ? "Unavailable" : genres!.joined(separator:", ")
    }
}
