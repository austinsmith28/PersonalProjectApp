//
//  Map.swift
//  AppOne
//
//  Created by David Lepore on 3/18/19.
//  Copyright © 2019 David & Austin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase


class Map: UIViewController, GMSMapViewDelegate{

     let partyDetails = NewPartyDetailsController()
    var maxDistance = 50.0
    var userLocation:CLLocation!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    
    //SEGUE TO NEW PARTY FOR ADDRESS
    @IBAction func newParty(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "newParty")
            self.show(vc, sender: self)
        }
    }
    //SEGUE TO USER SETTINGS
    @IBAction func userSettings(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "userSettings")
            self.show(vc, sender: self)
        }
    }
    
    
   /*
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D){
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        //mapView.clear() // clearing Pin before adding new
        let marker = GMSMarker(position: coordinate)
        
        let user = Auth.auth().currentUser
        
        //var ref = Database.database().reference().child("users").child(user!.uid).child("currentLocation")
        
        let ref = Database.database().reference().child("posts").childByAutoId()
        
        ref.setValue(["lat":coordinate.latitude, "lng":coordinate.longitude]) { (error, dbref) in
            
        }
        
        
        
        
    
        marker.map = mapView
    }
    
    */
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
       
        self.getUserLocation()
       
        self.getMaxDistance()
        
        self.loadMarkersFromDB()
        
        mapView.delegate = self
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        darkMode();
       
        self.view.addSubview(mapView)
    }
    
    
    
    
    
    
    
    
    func getMaxDistance() {
        print("in get maxDistance func")
        let ref1 = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref1.observe(.value, with: { (snapshot) in
            if snapshot.value as? [String : Any] != nil {
                
                
                guard let userProfile = snapshot.value as? [String : AnyObject] else {
                    return
                }
                
                
                // Get maxDistance
                self.maxDistance = userProfile["MaxDistance"] as! Double
                
             
                
                
                
            }
        }, withCancel: nil)
    }
    
    func getUserLocation() {
        print("in get location func")
        let ref1 = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref1.observe(.value, with: { (snapshot) in
            if snapshot.value as? [String : Any] != nil {
                
                
                guard let userProfile = snapshot.value as? [String : AnyObject] else {
                    return
                }
                
                
                // Get usersLocation from database
                
                let userLat = userProfile["userLat"]
                let userLong = userProfile["userLong"]
                
                self.userLocation = CLLocation(latitude: userLat as! CLLocationDegrees, longitude: userLong as! CLLocationDegrees)
                
                print("user location", self.userLocation)
                
            }
        }, withCancel: nil)
    }
    
    
    
    func loadMarkersFromDB() {
        print ("in the loadmarker func")
        
        
        
        
        let ref = Database.database().reference().child("posts")
        ref.observe(.childAdded, with: { (snapshot) in
            if snapshot.value as? [String : Any] != nil {
                
                
                guard let currentLocation = snapshot.value as? [String : AnyObject] else {
                    return
                }
                
                // Get coordinate values from DB
                let latitude = currentLocation["lat"]
                let longitude = currentLocation["lng"]
                
                
                
                print("in this bish")
                print("LAT VAL ", latitude!, "LONG VAL ", longitude! )
                
                if latitude != nil && longitude != nil {
                
                DispatchQueue.main.async(execute: {
                    let marker = GMSMarker()
                    
                    let markerLoc = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    
                    self.getUserLocation()
                    
                    let markerDistance = self.userLocation.distance(from: markerLoc)
                    
                    
                    print("MARKER DISTANCE ", markerDistance)
                    
                    
                    if markerDistance <= self.maxDistance * 1609.34 {
                    // Assign custom image for each marker
                    //let markerImage = self.resizeImage(image: UIImage.init(named: "Party")!, targetSize: CGSize(width: 30
                    //    , height: 30)).withRenderingMode(.alwaysTemplate)
                   // let markerView = UIImageView(image: markerImage)
                    // Customize color of marker here:
                    //markerView.tintColor = rented ? .lightGray : UIColor(hexString: "19E698")
                    //marker.iconView = markerView
                    marker.position = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    
                
                    
                    //marker.title = "testing... how much shit can i type into here before it wraps or looks dumb"
                    //marker.snippet = "snippet test what about this one here i want a lot of text so i can see how it looks fuck shit damn those are good nice words to use pal"
                    marker.map = self.mapView
                    
                    // *IMPORTANT* Assign all the spots data to the marker's userData property
                    marker.userData = currentLocation
                    }
                    
        
                })
                }
            }
        }, withCancel: nil)
    }
    
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
    
    
    
    
}
    
    
    
    
    
    
    
    



extension Map: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        ref.updateChildValues(["userLat": location.coordinate.latitude, "userLong":location.coordinate.longitude])
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        // 8
        locationManager.stopUpdatingLocation()
    }
    
    
    //puts the map in darkmode
    func darkMode() -> Void {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
    }
}




