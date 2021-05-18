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
    static private let basePathHttps = "https://api.tvmaze.com"
    
    public class func loadShows(name: String?, page: Int = 0, onComplete: @escaping ([Show]?) -> Void) {
        var url: String
        
        if let name = name, !name.isEmpty {
            url = basePath + "/search/shows?q=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
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
                let episodes = try JSONDecoder().decode([Episode].self, from: data)
                onComplete(episodes)
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
    
    public class func loadPeople(name: String?, onComplete: @escaping ([Person]?) -> Void) {
        
        if name != nil, !name!.isEmpty {
            let url = basePath + "/search/people?q=\(name!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            
            AF.request(url).responseJSON { (response) in
                guard let data = response.data else {
                    onComplete(nil)
                    return
                }
                do {
                    let people = try JSONDecoder().decode([SearchPeopleResponseObject].self, from: data)
                    onComplete(TVmazeAPIUtils.getPeopleFromSearchResponseObjectList(people))
                } catch {
                    print(error.localizedDescription)
                    onComplete(nil)
                }
            }
        } else {
            onComplete(nil)
        }
    }
    
    public class func loadShowsFromCastcredits(_ personId: Int, onComplete: @escaping ([Show]?) -> Void) {
        let url = basePath + "/people/\(personId)/castcredits"
        
        let dispatchGroup = DispatchGroup()
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do {
                print(String(data: data, encoding: .utf8) ?? "Mjop")
                var shows:[Show] = []
                let castcredits = try JSONDecoder().decode([CastcreditsResponse].self, from: data)
                for castcredit in castcredits {
                    dispatchGroup.enter()
                    let showId = castcredit.links.show.showId
                    loadShowById(showId: showId) { (show) in
                        if let show = show {
                            shows.append(show)
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    onComplete(shows)
                }
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
    
    public class func loadShowById(showId: String, onComplete: @escaping (Show?) -> Void) {
        let url = basePathHttps + "/shows/\(showId)"
        
        AF.request(url).responseJSON { (response) in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            do {
                let show = try JSONDecoder().decode(Show.self, from: data)
                onComplete(show)
            } catch {
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
}
