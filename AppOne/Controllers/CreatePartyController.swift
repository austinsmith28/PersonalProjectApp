//
//  CreatePartyController.swift
//  AppOne
//
//  Created by David Lepore on 3/21/19.
//  Copyright © 2019 David & Austin. All rights reserved.
//

import UIKit

class CreatePartyController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var address: UITextField!
    
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var university: UITextField!
    
    
    @IBOutlet weak var zipCode: UITextField!
    

    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        address.delegate = self
        city.delegate = self
        university.delegate = self
        zipCode.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //when you press the return button on the create party page
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        hideKeyboard()
        
        return true
    }
    
    func hideKeyboard (){
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
