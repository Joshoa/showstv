//
//  TVmazeAPIUtils.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 16/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation

class TVmazeAPIUtils {
    public static func getShowsFromSearchShowResponseObjectList(_ responseObjectList: [SearchShowResponseObject]?) -> [Show]? {
        if let responseObjectList = responseObjectList {
            var shows: [Show] = []
            for reponseObj in responseObjectList {
                shows.append(reponseObj.show)
            }
            return shows
        }
        return nil
    }
}
