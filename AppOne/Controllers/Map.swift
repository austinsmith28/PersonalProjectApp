//
//  Map.swift
//  AppOne
//
//  Created by David Lepore on 3/18/19.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import GoogleMobileAds


class Map: UIViewController, GMSMapViewDelegate, GADRewardBasedVideoAdDelegate {

    var maxDistance = 50.0
    var userLocation = CLLocation(latitude: 0.0 , longitude: 0.0 )
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    @IBAction func refreshButton(_ sender: Any) {
        loadMarkersFromDB()
    }
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-4207054108955119/3872588523")
       
        
        
        self.loadMarkersFromDB()
        
        mapView.delegate = self
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        darkMode();
       
        self.view.addSubview(mapView)
    }
    
    
    
    
    
    
    
    
    func getMaxDistance() {
    
        let ref1 = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref1.observe(.value, with: { (snapshot) in
            if snapshot.value as? [String : Any] != nil {
                
                
                guard let userProfile = snapshot.value as? [String : AnyObject] else {
                    return
                }
                
               
                // Get maxDistance
                if(userProfile["MaxDistance"] == nil){
                    ref1.setValue(["MaxDistance" : 10])
                }
                self.maxDistance = userProfile["MaxDistance"] as! Double
                
             
                
                
                
            }
        }, withCancel: nil)
    }
    
    func getUserLocation() {
       
        let ref1 = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref1.observe(.value, with: { (snapshot) in
            if snapshot.value as? [String : Any] != nil {
                
                
                guard let userProfile = snapshot.value as? [String : AnyObject] else {
                    return
                }
                
                
                // Get usersLocation from database
                let userLat = userProfile["userLat"]
                let userLong = userProfile["userLong"]
                //update userLocation
                self.userLocation = CLLocation(latitude: userLat as! CLLocationDegrees, longitude: userLong as! CLLocationDegrees)
                
                
            }
        }, withCancel: nil)
    }
    
    
    
    func loadMarkersFromDB() {
        
        removeOldMarkers()
        
        self.getMaxDistance()
        self.getUserLocation()
        
        
        let ref = Database.database().reference().child("posts")
        ref.observe(.childAdded, with: { (snapshot) in
            if snapshot.value as? [String : Any] != nil {
                
                
                guard let postInfo = snapshot.value as? [String : AnyObject] else {
                    return
                }
                
                // Get coordinate values from DB
                let latitude = postInfo["lat"]
                let longitude = postInfo["lng"]
                let markerTitle = postInfo["address"]
                let time = postInfo["date"] as! String
                let details = postInfo["details"] as! String
                let maxGuests = postInfo["max"] as! String
                
                let markerSnippet = time + "\nMax Guests: " + maxGuests + "\n" + details
                
                
                if latitude != nil && longitude != nil {
                
                DispatchQueue.main.async(execute: {
                    let marker = GMSMarker()
                    
                    let markerLoc = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    
                    
                    let markerDistance = self.userLocation.distance(from: markerLoc)
                
                    if markerDistance <= self.maxDistance * 1609.34 {
                    // Assign custom image for each marker
                    //let markerImage = self.resizeImage(image: UIImage.init(named: "Party")!, targetSize: CGSize(width: 30
                    //    , height: 30)).withRenderingMode(.alwaysTemplate)
                   // let markerView = UIImageView(image: markerImage)
                    // Customize color of marker here:
                    //markerView.tintColor = rented ? .lightGray : UIColor(hexString: "19E698")
                    //marker.iconView = markerView
                    marker.position = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
                    
                
                    
                        marker.title = markerTitle as? String
                        
                    marker.snippet = markerSnippet
                    marker.map = self.mapView
                    
                    // *IMPORTANT* Assign all the spots data to the marker's userData property
                    marker.userData = postInfo
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
    
    
    func removeOldMarkers() {
        
        let ref = Database.database().reference().child("posts")
        let now = Date().timeIntervalSince1970
        let cutoff = now - 28800
        
        let old = ref.queryOrdered(byChild: "timestamp").queryEnding(atValue: cutoff).queryLimited(toLast: 1)
        old.observe(.childAdded, with: { (snapshot) in
        
            snapshot.ref.removeValue()
        })
            
        
        
        
        
    }
    
    
    
    //methods from google ads rewardbasedvideoad doc: https://developers.google.com/admob/ios/rewarded-video
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad has completed.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
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




