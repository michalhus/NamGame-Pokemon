//
//  DataController.swift
//  Name Game
//
//  Created by Michal Hus on 6/7/20.
//  Copyright © 2020 Michal Hus. All rights reserved.
//

import Foundation
import CoreData

class DataController {
 
    let modelName: String
    static let shared = DataController(modelName: "pokemon")

    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        self.modelName = modelName
    }
        
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "pokemon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
