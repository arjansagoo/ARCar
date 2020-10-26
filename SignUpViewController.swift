//
//  SignUpViewController.swift
//  AR Car
//
//  Created by Arjan Sagoo on 27/02/2019.
//  Copyright © 2019 Arjan Sagoo. All rights reserved.
//

import UIKit
import Foundation
import Firebase
// import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func continueButton(_ sender: UIButton) {
        signUpHandler()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Hide keyboard when user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
    }
    
    
    @objc func signUpHandler() {
        guard let username = usernameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        
        // Check Text Field Entries
        
        if(username.isEmpty || email.isEmpty || password.isEmpty) {
            
            // Pop up alert message appears on screen
            let entryAlert = UIAlertController(title: "Alert", message: "All text fields must be entered", preferredStyle: .alert)
            
          // Allow the user to remove the message
            entryAlert.addAction(UIAlertAction(title: "Close", style: .default))
            
            self.present(entryAlert, animated: true, completion: nil)
        }
        
        let ref = Database.database().reference()

        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                ref.child("userID").setValue(["username" : username, "email" : email, "password" : password]);
                print("Account created")
                
                self.dismiss(animated: false, completion: nil)
 //               self.performSegue(withIdentifier: "theHomeScreen", sender: self)
                
                 print("Sign up test successful!")
            } else {
                print("Error creating user: \(error!.localizedDescription)")
            }
        }
    }


}
