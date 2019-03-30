//
//  NewPartyDetailsController.swift
//  AppOne
//
//  Created by David Lepore on 3/24/19.
//  Copyright © 2019 David&Austin. All rights reserved.
//

import UIKit

class NewPartyDetailsController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewPicker: UIPickerView!
    
    
    let guests = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return guests[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return guests.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        label.text = guests[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
  
}
