//
//  CoreDataStack.swift
//  iPasswordKeeper
//
//  Created by Tobi Kuyoro on 23/11/2019.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let share = CoreDataStack()
    
    private init() {
        
    }
    
    // Create Code Snippet
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Password")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        })
        return container
    }() // Creating only one instance for use
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.share.mainContext) {
        context.performAndWait {
            
            do{
                try mainContext.save()
            } catch {
                NSLog("Error saving context \(error)")
                mainContext.reset()
            }
        }
    }
}
