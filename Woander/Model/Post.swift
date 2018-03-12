//
//  Post.swift
//  Woander
//
//  Created by Puillandre on 06/03/2018.
//  Copyright © 2018 robin ustarroz. All rights reserved.
//

import Foundation

class Post {
    private var _locLat : Double
    private var _locLon : Double
    private var _postType : TYPE
    private var _nbLike : Int
    private var _postDesc : String
    private var _postFilter : String
    private var _idUser : String
    private var _postContent : String
    private var _idPost : String
    
    var locLat : Double {
        return _locLat
    }
    var locLon : Double {
        return _locLon
    }
    var postType : TYPE {
        return _postType
    }
    var nbLike : Int {
        return _nbLike
    }
    var postDesc : String {
        return _postDesc
    }
    var postFilter : String {
        return _postFilter
    }
    var idUser : String {
        return _idUser
    }
    var postContent : String {
        return _postContent
    }
    var idPost : String {
        return _idPost
    }
    
    init(locLat : Double = 0.0,
         locLon : Double = 0.0,
         postType : String = "",
         nbLike : Int = 0,
         postDesc : String = "",
         postFilter : String = "",
         idUser : String = "",
         postContent : String = "",
         idPost : String = "") {
        self._locLat = locLat
        self._locLon = locLon
        switch (postType) {
        case "PHOTO" : self._postType = TYPE.PHOTO
        case "AR" : self._postType = TYPE.AR
        case "VIDEO" : self._postType = TYPE.VIDEO
        default : self._postType = TYPE.UNKNOWN
        }
        self._nbLike = nbLike
        self._postDesc = postDesc
        self._postFilter = postFilter
        self._idUser = idUser
        self._postContent = postContent
        self._idPost = idPost
    }
    
    enum TYPE : Int {
        case PHOTO = 0
        case VIDEO = 1
        case AR = 2
        case UNKNOWN = 3
    }
}
