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
    
    var coordLocation:CLLocation!
    
    @IBOutlet weak var address: UITextField!
    
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var university: UITextField!
    
    
    @IBOutlet weak var zipCode: UITextField!
    
    @IBAction func continueClicked(_ sender: Any) {
        let createLoc = createLocation()
        addressToCoordinate(address: createLoc)
    }
    
    override func viewDidLoad() {
        
        
   
        
        
        super.viewDidLoad()
        address.delegate = self
        city.delegate = self
        university.delegate = self
        zipCode.delegate = self
        
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    //when you press the return button on keyboard on the create party page
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        hideKeyboard()
        
        return true
    }
    
    func hideKeyboard (){
        self.view.endEditing(true)
    }

    func addressToCoordinate(address: String) -> CLLocation {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
    
                else {
                    print("addressToCord error")
                    let alert = UIAlertController(title: "Alert", message: "Invalid address!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            self.coordLocation = location
        }
        return coordLocation
    }
    
    
    func createLocation() -> String {
    let locAdd = address.text
    let locCity = city.text
    let locZip = zipCode.text
    var locString = ""
        
    if (locAdd != nil && locCity != nil && locZip != nil) {
    locString = locAdd! + ", " + locCity! + ", " + locZip!
        return locString
    }
    else {
        let alert = UIAlertController(title: "Alert", message: "Text fields cannot be empty!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return "createLocation error"
        }
        
    }
    
    
    func getLocCord() -> CLLocation {
        return coordLocation
    }
    
}

