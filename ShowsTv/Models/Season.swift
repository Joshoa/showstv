//
//  Season.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 17/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation

public class Season: Codable {
    var id: Int = 0
    var number: Int = 0
    
    var episodes: [Episode] = []
    
    private enum CodingKeys: String, CodingKey {
        case id, number
    }
}
