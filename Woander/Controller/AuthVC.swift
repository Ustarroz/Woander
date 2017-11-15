//
//  AuthVC.swift
//  Woander
//
//  Created by robin ustarroz on 13/11/2017.
//  Copyright © 2017 robin ustarroz. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
            self.emailTextField.delegate = self
            self.paswordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signUpBtnWasPressed(_ sender: Any) {
        if emailTextField.text != nil && paswordTextField.text != nil {
            AuthService.instance.loginUser(email: emailTextField.text!, password: paswordTextField.text!, loginCreationComplete: { (success, loginError) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        print(String(describing: loginError?.localizedDescription))
                    }
                AuthService.instance.registerUser(email: self.emailTextField.text!, password: self.paswordTextField.text!, userCreationComplete: { (success, registrationError) in
                        if success {
                            AuthService.instance.loginUser(email: self.emailTextField.text!, password: self.paswordTextField.text!, loginCreationComplete: { (success, nil) in
                                self.dismiss(animated: true, completion: nil)
                            })
                        } else {
                            print(String(describing: registrationError?.localizedDescription))
                        }
                    })
                })
            }
            
        }
}
