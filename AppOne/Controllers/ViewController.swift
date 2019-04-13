//
//  ViewController.swift
//  AppOne
//
//  Created by David Lepore on 3/4/19.
//  Copyright © 2019 David&Austin. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class ViewController: UIViewController, UITextFieldDelegate {
    
 
    
    @IBOutlet var emailField: UITextField!
    
    
    @IBOutlet var password: UITextField!
    
    var signinerror: UILabel!
    
    
    @IBAction func ContinueButton(_ sender: Any) {
        
        
        Auth.auth().signIn(withEmail: self.emailField.text!, password: self.password.text!) { (auth, error) in
            
            if error != nil {
            
                print(error!)
            }
            else {
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "googleMap")
                    self.show(vc, sender: self)
                }
            }
        }
        
        
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "signUp")
            self.show(vc, sender: self)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "googleMap")
                self.show(vc, sender: self)
            }
        }
        emailField.delegate = self
       
        password.delegate = self
            
        
        // Do any additional setup after loading the view, typically from a nib.
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

























