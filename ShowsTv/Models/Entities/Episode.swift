//
//  Episode.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 17/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation

public class Episode: Codable {
    var id: Int
    var number: Int
    var season: Int
    var name: String?
    var image: ShowImage?
    var summary: String?
    
     private enum CodingKeys: String, CodingKey {
           case id, number, season, name, image, summary
       }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.number = try values.decodeIfPresent(Int.self, forKey: .number) ?? 0
        self.season = try values.decodeIfPresent(Int.self, forKey: .season) ?? 0
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? nil
        self.image = try values.decodeIfPresent(ShowImage.self, forKey: .image) ?? nil
        self.summary = try values.decodeIfPresent(String.self, forKey: .summary) ?? nil
    }
}
