//
//  MapVC.swift
//  Woander
//
//  Created by robin ustarroz on 13/11/2017.
//  Copyright © 2017 robin ustarroz. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class MapVC: UIViewController{

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 44.855731, longitude: -0.574692, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 44.855731, longitude: -0.574692)
        marker.title = "Coucou Maman!"
        marker.snippet = "On est la"
        marker.map = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMyBtn()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addMyBtn() {
        let btn = UIButton(frame: CGRect(x: 20, y: 20, width: 70, height: 50))
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.setTitle("Logout", for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(btn)
    }

    @objc func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
            let logoutPopup = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTaped) in
                do {
                    try Auth.auth().signOut()
                    let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                    self.present(authVC!, animated: true, completion: nil)
                } catch {
                    print(error)
                }
                
            }
            logoutPopup.addAction(logoutAction)
            present(logoutPopup, animated: true, completion: nil)
        }
        
    }
}
