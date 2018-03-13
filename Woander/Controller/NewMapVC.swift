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

class NewMapVC: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate {
    let locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    let myPost = GMSMarker()
    lazy var infoWindow = MapMarkerWindow(frame: CGRect(x: 0, y: 0, width: 350 , height: 550))
    var allPosts : [GMSMarker] = [GMSMarker]()

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let location = CLLocationCoordinate2D(latitude: (CLLocationDegrees(marker.groundAnchor.x)), longitude: (CLLocationDegrees(marker.groundAnchor.y)))
        
        infoWindow.removeFromSuperview()
        infoWindow = MapMarkerWindow(frame: CGRect(x: 0, y: 0, width: 350 , height: 550))
        infoWindow.center = mapView.projection.point(for: location)
        self.view.addSubview(infoWindow)
        return false
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        }
    
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            infoWindow.removeFromSuperview()
        }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addSubview(addMyBtn())
        //self.view.addSubview(postBtnCreate())
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        manageMarkersFromDB()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        self.view.addSubview(postBtnCreate())
      
        locationManager.stopUpdatingLocation()
        myPost.position = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        myPost.map = mapView
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
    
    func postBtnCreate() -> UIButton {
        let btn = UIButton(frame: CGRect(x: view.frame.width / 2 - 40 , y: view.frame.height - 110, width: 100, height: 100))
        btn.setBackgroundImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
        btn.tag = 0
        btn.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
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
        else if btnsendtag.tag == 0 {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                //imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
    }
    
    private func placeMarker(spot: Post) {
        // Get coordinate values from DB
        if (spot.postType == Post.TYPE.UNKNOWN) {
            return
        }
        let latitude = spot.locLat
        let longitude = spot.locLon
        
        DispatchQueue.main.async(execute: {
            let marker = GMSMarker()
            // Assign custom image for each marker
            var imageString : String
            switch (spot.postType) {
                case (Post.TYPE.PHOTO) : imageString = "post_photo"
                case (Post.TYPE.VIDEO) : imageString = "post_video"
                default : imageString = "post_ar"
            }
            let markerImage = UIImage(named: imageString)
            let markerView = UIImageView(image: markerImage)
            marker.iconView = markerView
            marker.position = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
            marker.map = self.mapView
            // *IMPORTANT* Assign all the spots data to the marker's userData property
            marker.userData = spot
            self.allPosts.append(marker)
        })
    }
    
    private func placeAllMarkers(posts: [Post]){
        if (posts.isEmpty) {
            return
        }
        self.mapView.clear()
        allPosts = [GMSMarker]()
        for spot in posts {
            placeMarker(spot: spot)
        }
    }
    
    func manageMarkersFromDB() {
        Dataservice.instance.getAllPosts(handler: {(posts) in
            self.placeAllMarkers(posts: posts)
        })
        Dataservice.instance.getAddedPost(handler: {(post) in
            self.placeMarker(spot: post)
        })
        Dataservice.instance.getRemovedPost(handler: {(post) in
            var index = 0
            for marker in self.allPosts {
                let spot = marker.userData as? Post ?? Post()
                if spot.idPost == post.idPost {
                    marker.map = nil
                    self.allPosts.remove(at: index)
                    return
                }
                index += 1
            }
        })
    }

}
