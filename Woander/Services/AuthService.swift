//
//  AuthService.swift
//  Woander
//
//  Created by robin ustarroz on 13/11/2017.
//  Copyright © 2017 robin ustarroz. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(email: String, password: String, userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            let userData = ["provider": user.providerID, "email": user.email]
            Dataservice.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(email: String, password: String, loginCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginCreationComplete(false, error)
                return
            }
            loginCreationComplete(true, nil)
        }
    }
}

