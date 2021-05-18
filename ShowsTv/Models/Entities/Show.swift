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
    
    var isFavorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, name, image, schedule, genres, summary
    }
    
    var genresAsString: String {
        return genres == nil ? "Unavailable" : genres!.joined(separator:", ")
    }
    
    public static func fromShowCD(_ showCD: ShowCD) -> Show {
        let show = Show()
        show.id = Int(showCD.id)
        show.name = showCD.name
        show.image = ShowImage(medium: showCD.imageMedium, original: showCD.imageOriginal)
        show.genres = showCD.genres as? [String]
        show.schedule = ShowSchedule(time: showCD.scheduleTime ?? "", days: showCD.scheduleDays as! [String])
        show.summary = showCD.summary
        show.isFavorite = showCD.isFavorite
        return show
    }
}
