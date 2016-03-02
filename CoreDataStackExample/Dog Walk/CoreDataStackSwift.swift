//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by GaoYuan on 16/3/1.
//  Copyright © 2016年 Razeware. All rights reserved.
//

import CoreData

class CoreDataStackSwift {
    
    let modelName = "Dog Walk"
    
    /* Get application documents directory */
    private(set) lazy var applcationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    /* Get MOM 'Dog Walk.momd' */
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle() .URLForResource(self.modelName,
        withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    /* Connect database and model */
    private(set) lazy var psc: NSPersistentStoreCoordinator = {
        
        // Create coordinator with MOM
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        
        // MOM directory
        let url = self.applcationDocumentsDirectory.URLByAppendingPathComponent(self.modelName)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
            // Set database type, NSSQLiteStoreType is non-atomic
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            print("Error adding persistent store.")
        }
        
        return coordinator
    }()
    
    /* Create MOC */
    lazy var context: NSManagedObjectContext = {
       var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
    
}