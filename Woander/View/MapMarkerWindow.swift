//
//  UserPost.swift
//  Woander
//
//  Created by robin ustarroz on 16/11/2017.
//  Copyright © 2017 robin ustarroz. All rights reserved.
//

import UIKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
}

class MapMarkerWindow: UIView {
    @IBOutlet weak var postImageUser: UIImageView!
    @IBOutlet weak var toProfileUserBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userTextPostLbl: UILabel!
    @IBOutlet weak var userHashtagPostLbl: UILabel!
    @IBOutlet weak var postCommentBtn: UIButton!
    @IBOutlet weak var commentNumberLbl: UILabel!
    @IBOutlet weak var likeNumberLbl: UILabel!
 
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
