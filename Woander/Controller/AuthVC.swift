//
//  AuthVC.swift
//  Woander
//
//  Created by robin ustarroz on 13/11/2017.
//  Copyright © 2017 robin ustarroz. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    @IBAction func signUpBtnWasPressed(_ sender: Any) {
        if emailTextField.text != nil && paswordTextField.text != nil {
            
        }
    }
    
}
