//
//  CustomTabBarController.swift
//  PersistChat
//
//  Created by Nick Perkins on 5/29/17.
//  Copyright © 2017 Nicholas Perkins. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup custom view controllers
        let layout = UICollectionViewFlowLayout()
        let persistChatController = PersistChatController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: persistChatController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [recentMessagesNavController, createDummyNavController(title: "Calls", imageName: "call"), createDummyNavController(title: "Groups", imageName: "group"), createDummyNavController(title: "People", imageName: "people"), createDummyNavController(title: "Settings", imageName: "settings")]
    }
    
    private func createDummyNavController(title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
