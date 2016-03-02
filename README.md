# iOS-CoreData-CoreDataStack
iOS-CoreDataStack

This is a summary of learning Core Data. The goal is to help myself and other beginners to understand how the Core Data works and how to use it. All materials are collected from internet and Apple documentations.

# What is CoreData?
Core Data is an object graph management and persistence framework in the OS X and iOS SDKs. It can use SQLite as the data store behind the scenes. Core Data managed object context is not thread-safe.


# Core Data Stack
Building a stack will help us to know how Core Data works.

## There are four Core Data classes:
1. NSManagedObjectModel
 It is a class that contains the definitions for each of the Entities. Usually, we will use the visual editor to set up what entities are in the database, what their attributes are, and how they relate to each other. Other parts of the Core Data stack use the model to create objects, store properties and save data. 

2. NSPersistentStore
NSPersistentStore reads and writes data to whichever storage method you’ve decided to use. Core Data provides four types of NSPersistentStore out of the box: three atomic and one non-atomic. 
Four NSPersistentStore Types:
NSSQLiteStoreType(non-atomic, Default), NSXMLStoreType, NSBinaryStoreType, NSInMemoryStoreType.
We can create our own type of persistent store by subclassing NSIncrementalStore. 
https://developer.apple.com/library/ios/documentation/DataManagement/Conceptual/IncrementalStorePG/Introduction/Introduction.html 

3. NSPersistentStoreCoordinator
It is used for database connection. Here is where I set up the actual names and locations of what databases will be used to store the objects. NSPersistentStoreCoordinator is the bridge between the managed object model and the persistent store. 

4. NSManagedObjectContext
It’s like ’scratch pad’. We will be working with it the most. Whenever I need to get objects, insert objects, or delete objects, I will call methods on the managed object context.

A context is an in-memory scratchpad for working with your managed objects. 

• You do all of the work with your Core Data objects within a managed object context. 

• Any changes you make won’t affect the underlying data on disk until you call save() on the context. 

• An application can use more than one context—most non-trivial Core Data applications fall into this category. Since a context is an in-memory scratch pad for what’s on disk, you can actually load the same Core Data object onto two different contexts simultaneously. 

•  A context is not thread safe. The same goes for a managed object—you can only interact with contexts and managed objects on the same thread in which they were created. We will talk about Multiple Managed Object Contexts later.


## Example of Core Data
I created the simple CoreDataStock in both Objective-C and Swift. This example is wrote in Swift, but I used the Objective-C CoreDataStock class by adding bridging-header. It does not use the NSFetchedResultsController which may be better to work with tableView. I will talk about NSFetchedResultsController later.

Save data

        // 1. Get entity that you want to save data to
        let walkEntity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: managedContext)
        // 2. Create managed object
        let walk = Walk(entity: walkEntity!, insertIntoManagedObjectContext: managedContext)
        // 3. Edit managed object
        walk.date = NSDate()
        // 4. Insert the new managed object into the data set
        let walks = currentDog.walks!.mutableCopy() as! NSMutableOrderedSet
        walks.addObject(walk)
        
        // 5. Update self data source
        currentDog.walks = walks.copy() as? NSOrderedSet
        
        do {
          // 6. Save the managed object context
          try managedContext.save()
        } catch let error as NSError { 
          print("Could not save:\(error)")
        }
        
        //Reload table view
        tableView.reloadData()

Fetch data

        // 1. Get entity that you want to fetch data from
        let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: managedContext)
        // 2. Create fetch request
        let dogFetch = NSFetchRequest(entityName: "Dog")
        // Create predicate for searching
        let dogName = "Fido"
        dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
        do {
           // 3. Execute fetch request
           let results = try managedContext.executeFetchRequest(dogFetch) as! [Dog]
           if results.count > 0 {
              //Fido found, use Fido 
              currentDog = results.first
            } else {
              //Fido not found, create Fido 
              currentDog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
              currentDog.name = dogName
              try managedContext.save()
            }
        } catch let error as NSError {
          print("Error: \(error) " + "description \(error.localizedDescription)")
        }






