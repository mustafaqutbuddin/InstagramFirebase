//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Mustafa on 19/07/2020.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .red
        
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        
        FirebaseController.fetchUser {
            user in
            self.navigationItem.title = user["username"] as? String
        }
    }
}
