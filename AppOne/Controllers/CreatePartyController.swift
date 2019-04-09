//
//  CreatePartyController.swift
//  AppOne
//
//  Created by David Lepore on 3/21/19.
//  Copyright © 2019 David & Austin. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class CreatePartyController: UIViewController, UITextFieldDelegate {
    
    var locationManager  = CLLocationManager()
    var geoCoder = CLGeocoder()
    var loc:CLLocation!
    
    @IBAction func continueB(_ sender: Any) {
        
       self.getCoord()
        
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "dateController")
            self.show(vc, sender: self)
        }
    }
    
    @IBAction func mapButton(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "googleMap")
            self.show(vc, sender: self)
        }
    }
    
    
    @IBOutlet weak var address: UITextField!
    
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var university: UITextField!
    
    @IBOutlet weak var stateLoc: UIPickerView!
    
    
    
    

    /*
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(states[row])
    }
    
    */
    
    override func viewDidLoad() {
        
        
      
        
        
        super.viewDidLoad()
        address.delegate = self
        city.delegate = self
        university.delegate = self
        
        
        
        
       
        
        

        // Do any additional setup after loading the view.
    }
    
    func getCoord(){
  var addy = address.text! + ", " + city.text!
        
        geoCoder.geocodeAddressString(addy) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            let location = placemark?.location
            self.setLoc(location: location!)
            
        }
    }
    
   
    
    func setLoc(location: CLLocation) {
       loc = location
    }
    
    func getLoc() -> CLLocation{
        return loc
    }
    
    
    
    //when you press the return button on keyboard on the create party page
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        hideKeyboard()
        
        return true
    }
    
    func hideKeyboard (){
        self.view.endEditing(true)
    }

   
    
    
}

