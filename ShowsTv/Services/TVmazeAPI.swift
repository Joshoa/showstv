//
//  TVmazeAPI.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 12/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation
import Alamofire

public class TVmazeAPI {
    
    static private let basePath = "http://api.tvmaze.com"
    
    public class func loadShows(name: String?, page: Int = 0, onComplete: @escaping ([Show]?) -> Void) {
        var url: String
        
        if let name = name, !name.isEmpty {
            url = basePath + "/search/shows?q=\(name)"
        } else {
            url = basePath + "/shows?page=\(page)"
        }
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do {
                let shows = try JSONDecoder().decode([Show].self, from: data)
                onComplete(shows)
            } catch {
                do {
                    let response = try JSONDecoder().decode([SearchShowResponseObject].self, from: data)
                    onComplete(TVmazeAPIUtils.getShowsFromSearchShowResponseObjectList(response))

                } catch {
                    print(error.localizedDescription)
                    onComplete(nil)
                }
            }
        }
    }
    
    public class func loadSeasons(showId: Int = 0, onComplete: @escaping ([Season]?) -> Void) {
        let url = basePath + "/shows/\(showId)/seasons"
        
        let dispatchGroup = DispatchGroup()
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do {
                let seasons = try JSONDecoder().decode([Season].self, from: data)
                for season in seasons {
                    dispatchGroup.enter()
                    loadEpisodesOnSeason(seasonId: season.id) { (episodes) in
                        if let episodes = episodes {
                            season.episodes.append(contentsOf: episodes)
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    onComplete(seasons)
                }
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
    
    public class func loadEpisodesOnSeason(seasonId: Int = 0, onComplete: @escaping ([Episode]?) -> Void) {
        let url = basePath + "/seasons/\(seasonId)/episodes"
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do {
                print(String(data: data, encoding: .utf8) ?? "Mjop")
                let episodes = try JSONDecoder().decode([Episode].self, from: data)
                onComplete(episodes)
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
}
