//
//  MainTabController.swift
//  InstagramFirebase
//
//  Created by Mustafa on 19/07/2020.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
class MainTabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = .black
        
        let flowLayOut = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileController(collectionViewLayout: flowLayOut)
        let navController = UINavigationController(rootViewController: userProfileVC)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        
        viewControllers = [navController, ViewController()]
    }
}
