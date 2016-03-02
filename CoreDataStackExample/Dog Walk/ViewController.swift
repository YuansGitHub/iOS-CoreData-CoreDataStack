//
//  ViewController.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/17/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
  
    var managedContext: NSManagedObjectContext!
    var currentDog: Dog!
    
  lazy var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .MediumStyle
    return formatter
  }()
  
  @IBOutlet var tableView: UITableView!
  var walks:Array<NSDate> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    tableView.registerClass(UITableViewCell.self,
      forCellReuseIdentifier: "Cell")
    
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
    
  }
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      
      return currentDog.walks!.count
  }
  
  func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
      return "List of Walks"
  }
  
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath
    indexPath: NSIndexPath) -> UITableViewCell {
      
      let cell =
      tableView.dequeueReusableCellWithIdentifier("Cell",
        forIndexPath: indexPath) as UITableViewCell
      
      let walk =  currentDog.walks![indexPath.row] as! Walk
      cell.textLabel!.text = dateFormatter.stringFromDate(walk.date!)
      
      return cell
  }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool { return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle
        editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
        //1
        let walkToRemove = currentDog.walks![indexPath.row] as! Walk
        //2
        managedContext.deleteObject(walkToRemove)
        //3
        do {
        try managedContext.save()
      } catch let error as NSError { print("Could not save: \(error)")
        }
        //4
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
  
  @IBAction func add(sender: AnyObject) {
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
      } catch let error as NSError { print("Could not save:\(error)")
        }
        //Reload table view
        tableView.reloadData()
  }
}

