//
//  FriendsControllerHelper.swift
//  PersistChat
//
//  Created by Nick Perkins on 5/29/17.
//  Copyright © 2017 Nicholas Perkins. All rights reserved.
//

import UIKit
import CoreData

//initial model objects before persisting to Core Data
//class Friend: NSObject {
//    
//    var name: String?
//    var profileImageName: String?
//    
//}
//
//class Message: NSObject {
//    
//    var text: String?
//    var date: Date?
//    
//    var friend: Friend?
//}

extension PersistChatController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            
            do {
                
                let entityNames = ["Friend", "Message"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                }
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    }
    
    func setupData() {
        
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            mark.name = "Mark Hamill"
            mark.profileImageName = "markhamill"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = mark
            message.text = "Hello, my name is Mark. Nice to meet you..."
            message.date = NSDate()
            
            let james = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            james.name = "James Gunn"
            james.profileImageName = "jamesgunn"
            
            let messageJames = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            messageJames.friend = james
            messageJames.text = "Hello, my name is James. Made some movies and..."
            messageJames.date = NSDate()
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            
            do {
                messages = try(context.fetch(fetchRequest)) as? [Message]
            } catch let err {
                print(err)
            }
        }
    }
}
