//
//  ViewController+CoreData.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 18/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }
}

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
