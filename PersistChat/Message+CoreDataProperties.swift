//
//  Message+CoreDataProperties.swift
//  PersistChat
//
//  Created by Nick Perkins on 5/29/17.
//  Copyright © 2017 Nicholas Perkins. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var friend: Friend?

}
