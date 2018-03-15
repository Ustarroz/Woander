//
//  DataService.swift
//  Woander
//
//  Created by robin ustarroz on 13/11/2017.
//  Copyright © 2017 robin ustarroz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

let DB_BASE = Database.database().reference()

class Dataservice {
    static let instance = Dataservice()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    private var _REF_POST = DB_BASE.child("posts")
    private var _REF_STORAGE = Storage.storage()
    
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
    
    var REF_POST: DatabaseReference {
        return _REF_POST
    }
    
    var REF_STORAGE: Storage {
        return _REF_STORAGE
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
    
    private func snapToPost(snapshot : DataSnapshot ) -> Post? {
        guard let locLat = snapshot.childSnapshot(forPath: "locLat").value as? Double else {return nil}
        guard let locLon = snapshot.childSnapshot(forPath: "locLon").value as? Double else {return nil}
        guard let postType = snapshot.childSnapshot(forPath: "postType").value as? String else {return nil}
        guard let nbLike = snapshot.childSnapshot(forPath: "nbLike").value as? Int else {return nil}
        guard let postDesc = snapshot.childSnapshot(forPath: "postDesc").value as? String else {return nil}
        guard let postFilter = snapshot.childSnapshot(forPath: "postFilter").value as? String else {return nil}
        guard let idUser = snapshot.childSnapshot(forPath: "idUser").value as? String else {return nil}
        guard let postContent = snapshot.childSnapshot(forPath: "postContent").value as? String else {return nil}
        guard let idPost = snapshot.childSnapshot(forPath: "idPost").value as? String else {return nil}
        return Post(locLat: locLat,
                    locLon: locLon,
                    postType: postType,
                    nbLike: nbLike,
                    postDesc: postDesc,
                    postFilter: postFilter,
                    idUser: idUser,
                    postContent: postContent,
                    idPost: idPost)
    }
    
    func getAddedPost(handler : @escaping (_ item : Post) -> ()) {
        REF_POST.observe(DataEventType.childAdded, with: { snapshot in
            let item : Post = self.snapToPost(snapshot: snapshot) ?? Post()
            handler(item)
        })
    }
    
    func getRemovedPost(handler : @escaping (_ item : Post) -> ()) {
        REF_POST.observe(DataEventType.childRemoved, with: { snapshot in
            let item : Post = self.snapToPost(snapshot: snapshot) ?? Post()
            handler(item)
        })
    }
    
    func getAllPosts(handler : @escaping (_ item : [Post]) -> ()) {
        REF_POST.observe(DataEventType.value, with: {snapshotPosts in
            var posts : [Post] = [Post]()
            guard let snapshotPosts = snapshotPosts.children.allObjects as? [DataSnapshot] else {
                handler(posts)
                return
            }
            for snapshot in snapshotPosts {
                let item : Post = self.snapToPost(snapshot: snapshot) ?? Post()
                posts.append(item)
            }
            handler(posts)
        })
    }
    
    func getPost(idPost : String, handler : @escaping (_ item : Post) -> ()) {
        REF_POST.child(idPost).observeSingleEvent(of: .value, with: { snapshot in
            let item : Post = self.snapToPost(snapshot: snapshot) ?? Post()
            handler(item)
        })
    }
    
    func downloadPhoto(post: Post, view: UIImageView) {
        if (post.postType != Post.TYPE.PHOTO) {
            return
        }
        let storageRef = REF_STORAGE.reference(forURL: post.postContent)
        storageRef.getData(maxSize: 10*1024*1024) { (data, error) in
            if (data != nil) {

                view.image = UIImage(data: data!)
            }
        }
    }
    
    func newPost(post : Post){
        let newChild = REF_POST.childByAutoId()
        post.setId(idPost: newChild.key)
        var type : String
        switch (post.postType) {
        case Post.TYPE.PHOTO : type = "PHOTO"
        case Post.TYPE.AR : type = "AR"
        case Post.TYPE.VIDEO : type = "VIDEO"
        default : type = "UNKNOWN"
        }
        let message = ["idPost": post.idPost,
                       "idUser": post.idUser,
                       "locLat": post.locLat,
                       "locLon": post.locLon,
                       "nbLike": post.nbLike,
                       "postContent": post.postContent,
                       "postDesc": post.postDesc,
                       "postFilter": post.postFilter,
                       "postType": type] as [String : Any]
        let childUpdate = ["/posts/\(newChild.key)": message]
        REF_BASE.updateChildValues(childUpdate)
    }
    
    func UploadPost(message: String , forUID uid: String, groupKey: String?, sendComplete: @escaping(_ status: Bool) ->()) {
        if groupKey != nil {
            
        } else {
            REF_FEED.childByAutoId().updateChildValues(["spot": message, "senderId": uid])
            sendComplete(true)
        }
    }
}
