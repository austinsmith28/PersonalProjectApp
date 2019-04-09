//
//  NewPartyDetailsController.swift
//  AppOne
//
//  Created by David Lepore on 3/24/19.
//  Copyright © 2019 David & Austin. All rights reserved.
//

import UIKit

class NewPartyDetailsController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var guestPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 250
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 249{
            return String("250+")
        }
        return String(format:"%i",row+1)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        guestPicker.delegate = self 
   
}
   
    
    @IBAction func backButton(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "dateController")
            self.show(vc, sender: self)
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
}
