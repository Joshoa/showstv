//
//  DAO.swift
//  ShowsTv
//
//  Created by Marcos Joshoa on 18/05/21.
//  Copyright © 2021 Marcos Joshoa. All rights reserved.
//

import Foundation
import CoreData

public class DAO {
    
    static var shared: DAO = DAO()
    private init(){}
    
    public func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func initFetchRequest<T : NSManagedObject>(_ key: String = "id", _ keys: [String] = []) -> NSFetchRequest<T> {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        let sortDescriptor = NSSortDescriptor(key: key, ascending: true)
        fetchRequest.sortDescriptors = keys.isEmpty ? [sortDescriptor] : keys.map({NSSortDescriptor(key: $0, ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))})
        return fetchRequest
    }
    
    public func list<T: NSManagedObject>(with context: NSManagedObjectContext, key: String = "id") -> [T]? {
        let fetchRequest: NSFetchRequest<T> = initFetchRequest(key)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func search<T: NSManagedObject>(context: NSManagedObjectContext, query: String = "", filtering: String = "", key: String = "id") -> [T]? {
        let fetchRequest: NSFetchRequest<T> = initFetchRequest(key)
        if !query.isEmpty && !filtering.isEmpty {
            let predicate = NSPredicate(format: query, filtering)
            fetchRequest.predicate = predicate
        }
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    public func getById(id: Int32, context: NSManagedObjectContext) -> ShowCD? {
        let shows: [ShowCD]? = search(context: context, query: "id == %@", filtering: "\(id)")
        return (shows?.count)! > 0 ? shows?[0] : nil
    }
    
    public func addShowToFavorites(_ show: Show, _ context: NSManagedObjectContext) {
        if getById(id: Int32(show.id), context: context) == nil {
            saveShowCRFrom(context, show)
        }
    }
    
    public func removeShowFromFavorites(_ show: Show, _ context: NSManagedObjectContext) {
        if let showCD = getById(id: Int32(show.id), context: context) {
            context.delete(showCD)
            save(context)
        }
    }
    
    private func saveShowCRFrom(_ context: NSManagedObjectContext, _ show: Show) {
        let showCD = ShowCD(context: context)
        showCD.id = Int32(show.id)
        showCD.name = show.name
        showCD.imageOriginal = show.image?.original
        showCD.imageMedium = show.image?.medium
        showCD.genres = show.genres as NSObject?
        showCD.scheduleTime = show.schedule?.time
        showCD.scheduleDays = show.schedule?.days as NSObject?
        showCD.summary = show.summary
        showCD.isFavorite = true
        save(context)
    }
}
