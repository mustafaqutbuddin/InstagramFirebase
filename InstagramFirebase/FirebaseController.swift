//
//  FirebaseController.swift
//  InstagramFirebase
//
//  Created by Mustafa on 19/07/2020.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController: NSObject {
    
    static func createUser(withEmail email: String, password: String, completion: @escaping(_ response: Any? ) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
        if let error = error {
            print("Error signin up user", error)
            return
        }
        
        print("User successfully signed up", response?.user.uid ?? "")
            completion(response?.user)
        
        }
    }

    static func uploadProfileImage(storageRef: StorageReference, image: UIImage, completion: @escaping(_ url: String) -> Void) {
        let filename = NSUUID().uuidString
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        let imageRef = storageRef.child("profile_images").child(filename)
        imageRef.putData(imageData, metadata: nil) {
            metaData, error in
            if let error = error {
                print("Failed to upload profile image:", error)
                return
            }
            
            
            imageRef.downloadURL {
                url, error in
                if let error = error {
                    print("Failed to download profile image:", error)
                    return
                }
                
                guard let downloadUrl = url?.absoluteURL.absoluteString else {return}
                completion(downloadUrl)
                
            }
        }
    }
    
    static func fetchUser(withCompletion completion: @escaping(_ user: [String: Any]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference().child("users").child(currentUserID)
        
        databaseRef.observe(.value, with: {
            snapshot in
            
            guard let userDict = snapshot.value as? [String: Any] else {return}
            completion(userDict)
            
        }) {
            error in
            print("Failed to fetch user:", error)
        }
    }
    
}
