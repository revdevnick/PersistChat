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
            
            createMessageWithText(text: "Good morning...", friend: james, minutesAgo: 3, context: context)
            createMessageWithText(text: "Hello, how are you? I hope you're having a fine day.", friend: james, minutesAgo: 2, context: context)
            createMessageWithText(text: "Just finished GOTGV2! I put three years of blood, sweat and tears into this movie to make it awesome! You're going to love Baby Groot's dialogue.", friend: james, minutesAgo: 1, context: context)
            
            let craig = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            craig.name = "Craig Federighi"
            craig.profileImageName = "craigfederighi"
            
            createMessageWithText(text: "Good morning. Wow! It’s wonderful to be chatting with the best iOS developer in the known world.", friend: craig, minutesAgo: 5, context: context)
            
            let stephen = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            stephen.name = "Stephen Amell"
            stephen.profileImageName = "stephenamell"
            
            createMessageWithText(text: "Nick, I'm being sinceriously now.", friend: stephen, minutesAgo: 60 * 24, context: context)
            
            let clark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            clark.name = "Clark Gregg"
            clark.profileImageName = "clarkgregg"
            
            createMessageWithText(text: "I smell something burning...", friend: clark, minutesAgo: 8 * 60 * 24, context: context)

            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            if let friends = fetchFriends() {
                
                messages = [Message]()
                
                for friend in friends {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do {
                        let fetchedMessages = try(context.fetch(fetchRequest)) as? [Message]
                        messages?.append(contentsOf: fetchedMessages!)
                    } catch let err {
                        print(err)
                    }
                }
                
                messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
            }
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do {
                return try(context.fetch(request)) as? [Friend]
            } catch let err {
                print(err)
            }
            
        }
        return nil
    }
}
