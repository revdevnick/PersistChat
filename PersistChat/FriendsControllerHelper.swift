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
            message.text = "Hello, are you the last jedi or am I?"
            message.date = NSDate()
            mark.lastMessage = message
            
            // The app will remove all friends where no conversation has taken place, like when you hit new message but don't type anything.  This friend can be added in PersistChatController in the function addEvan()
//            let evan = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
//            evan.name = "Evan McMullin"
//            evan.profileImageName = "evanmcmullin"
//            
//            let testMessage = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
//            testMessage.friend = evan
//            testMessage.text = "Did you see Trump vacationing in Russia?"
//            testMessage.date = NSDate()
//            evan.lastMessage = testMessage
            
            createJamesMessagesWithContext(context: context)
            
            let craig = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            craig.name = "Craig Federighi"
            craig.profileImageName = "craigfederighi"
            
            _ = PersistChatController.createMessageWithText(text: "Good morning. Wow! It’s wonderful to be chatting with the best iOS developer in the known world.", friend: craig, minutesAgo: 5, context: context)
            
            let stephen = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            stephen.name = "Stephen Amell"
            stephen.profileImageName = "stephenamell"
            
            _ = PersistChatController.createMessageWithText(text: "Nick, I'm being sinceriously now.", friend: stephen, minutesAgo: 60 * 24, context: context)
            
            let clark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            clark.name = "Clark Gregg"
            clark.profileImageName = "clarkgregg"
            
            _ = PersistChatController.createMessageWithText(text: "I smell something burning...", friend: clark, minutesAgo: 8 * 60 * 24, context: context)

            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
        
//        loadData()
    }
    
    private func createJamesMessagesWithContext(context: NSManagedObjectContext) {
        let james = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        james.name = "James Gunn"
        james.profileImageName = "jamesgunn"
        
        _ = PersistChatController.createMessageWithText(text: "Good morning...", friend: james, minutesAgo: 3, context: context)
        _ = PersistChatController.createMessageWithText(text: "Hello, how are you? I hope you're having a fine day.", friend: james, minutesAgo: 2, context: context)
        _ = PersistChatController.createMessageWithText(text: "Just finished GOTGV2! I put three years of blood, sweat and tears into this movie to make it awesome! You're going to love Baby Groot's dialogue.", friend: james, minutesAgo: 1, context: context)
        _ = PersistChatController.createMessageWithText(text: "Have you seen the movie?", friend: james, minutesAgo: 1, context: context)
        _ = PersistChatController.createMessageWithText(text: "Yes! I have seen Guardians Vol 2. It was awesome.", friend: james, minutesAgo: 1, context: context, isSender: true)
        _ = PersistChatController.createMessageWithText(text: "What was your favorite segment of the film?", friend: james, minutesAgo: 1, context: context)
        _ = PersistChatController.createMessageWithText(text: "Peter and Yondu's dialogue at the end. ''I'm Mary Poppins yall!'', was my favorite line. 😂", friend: james, minutesAgo: 1, context: context, isSender: true)
        
    }
    
    static func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
        
        friend.lastMessage = message
        
        return message
    }
    
//    func loadData() {
//        
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            if let friends = fetchFriends() {
//                
//                messages = [Message]()
//                
//                for friend in friends {
//                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
//                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
//                    fetchRequest.fetchLimit = 1
//                    do {
//                        let fetchedMessages = try(context.fetch(fetchRequest)) as? [Message]
//                        messages?.append(contentsOf: fetchedMessages!)
//                    } catch let err {
//                        print(err)
//                    }
//                }
//                
//                messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
//            }
//        }
//    }
//    
//    private func fetchFriends() -> [Friend]? {
//        
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
//            
//            do {
//                return try(context.fetch(request)) as? [Friend]
//            } catch let err {
//                print(err)
//            }
//            
//        }
//        return nil
//    }
}
