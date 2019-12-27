//
//  CreatePartyController.swift
//  AppOne
//
//  Created by Austin Smith on 3/21/19.
//

import UIKit
import CoreLocation
import Firebase

class NewMarkerController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Fields
    var locationManager  = CLLocationManager()
    var geoCoder = CLGeocoder()
    var loc:CLLocation!
    var thisLat : CLLocationDegrees!
    var thisLong : CLLocationDegrees!
    
    @IBOutlet weak var guestPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var detailsBox: UITextField!
    
    
    //sets the minimum of the max guest picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //sets the max of the max guest picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 250
    }
    //counter for each row and the row 249 includes '+' for value 250
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 249{
            return String("250+")
        }
        return String(format:"%i",row+1)
    }
    
    @IBAction func continueB(_ sender: Any) {
        
        if(address.text != "" && city.text != "" && detailsBox.text != ""){
            let alert = UIAlertController(title: "Notice", message: "This action is irreversible. The marker will remain on the map for 8 hours.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"Cancel\" alert occured.")
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                self.postToMap()
            }))
           self.show(alert, sender: self)
            
        }
        else {
            let alert = UIAlertController(title: "", message: "text fields cannot be blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.show(alert, sender: self)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        address.delegate = self
        city.delegate = self
        guestPicker.delegate = self
        detailsBox.delegate = self
        
    }
    
    func postToMap(){
        let addy = self.address.text! + ", " + self.city.text!
        
        geoCoder.geocodeAddressString(addy) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let long = placemark?.location?.coordinate.longitude
            _ = placemark?.location
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd' 'h:mm a"
            
            let date = dateFormatter.string(from: self.datePicker!.date)
            
            let details = self.detailsBox.text
            
            let maxGuests = self.guestPicker.selectedRow(inComponent: 0) + 1
            
            let maxString = String(maxGuests)
            
            
            
            let ref = Database.database().reference().child("posts").childByAutoId()
            ref.setValue(["lat":lat, "lng":long,"address": addy ,"date": date, "max":maxString,"details":details,"timestamp":Date().timeIntervalSince1970]) { (error, dbref) in
           
                
                
            }
        }
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "googleMap")
            self.show(vc, sender: self)
        }
    }
    
   
    
    
    
    
    //when you press the return button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        hideKeyboard()
        
        return true
    }
    
    func hideKeyboard (){
        self.view.endEditing(true)
    }
    
 
    
    
}

