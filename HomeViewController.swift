//
//  HomeViewController.swift
//  AR Car
//
//  Created by Arjan Sagoo on 27/02/2019.
//  Copyright © 2019 Arjan Sagoo. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
//    @IBAction func signUpButton(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "signUpSegue", sender: self)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toMainScreen", sender: self)
        }
    }
    

}
