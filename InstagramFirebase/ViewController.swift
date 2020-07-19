//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Mustafa on 13/06/2020.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    
    let plusPhotoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePhotoButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.layer.backgroundColor = UIColor.black.cgColor
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTfChange), for: .editingChanged)
        return tf
    }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTfChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTfChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTfChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if(isFormValid) {
            signupButton.isEnabled = true
            signupButton.backgroundColor = .rgb(red: 17, green: 154, blue: 237)
        } else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = .rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleSignup() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = userNameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        

        FirebaseController.createUser(withEmail: email, password: password) {
            user in
            
            guard let userProfileImage = self.plusPhotoButton.imageView?.image else {return}
            
            FirebaseController.uploadProfileImage(storageRef: Storage.storage().reference(), image: userProfileImage) {
                downloadedUrl in
                print("User image successfully uploaded:", downloadedUrl)
                
                
                guard let user = user as? User else {return}
                
                let userDict = ["username": username,
                                "profileImageUrl": downloadedUrl]
                
                let values = [user.uid : userDict]
                
                self.ref.child("users").updateChildValues(values) { err, ref in
                    if let err = err {
                        print("Failed to save user info into db:", err)
                        return
                    }
                    
                    print("Successfully added userinfo to db!")
                }
            }
            
        }
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupPlusButton()
            setupStackView()
            
            //database reference
            ref = Database.database().reference()
        }
        
        fileprivate func setupPlusButton() {
            view.addSubview(plusPhotoButton)
            
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBotton: 0, paddingRight: 0, width: 140, height: 140)
            
        }
        
        fileprivate func setupStackView() {
            let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signupButton])
            
            stackView.distribution = .fillEqually
            stackView.axis = .vertical
            stackView.spacing = 10
            
            view.addSubview(stackView)
            
            stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBotton: 0, paddingRight: 40, width: 0, height: 200)
        }
        
        
        
}

