//
//  NewMapVC.swift
//  Woander
//
//  Created by robin ustarroz on 15/11/2017.
//  Copyright © 2017 robin ustarroz. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

class NewMapVC: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        self.view.addSubview(addMyBtn())
        locationManager.stopUpdatingLocation()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        marker.title = "bonjour je suis un titre"
        marker.snippet = "je suis la location"
        marker.map = mapView
    }
    
    func addMyBtn() -> UIButton {
        let btn = UIButton(frame: CGRect(x: 20, y: 20, width: 70, height: 50))
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.setTitle("Logout", for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
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


