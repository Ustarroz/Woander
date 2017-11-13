//
//  DataService.swift
//  Woander
//
//  Created by robin ustarroz on 13/11/2017.
//  Copyright © 2017 robin ustarroz. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class Dataservice {
    static let instance = Dataservice()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED:DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) ->() ) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapShot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
}
