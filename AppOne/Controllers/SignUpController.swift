//
//  AfterLogin.swift
//  AppOne
//
//  Created by David Lepore on 3/4/19.
//  Copyright © 2019 David&Austin. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UITextFieldDelegate  {
    

    @IBOutlet var email: UITextField!
    
    @IBOutlet var displayName: UITextField!
    
    @IBOutlet var password: UITextField!
    
    
    @IBAction func createAccount(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (auth, err) in
            if err != nil {
                let alert = UIAlertController(title: "error", message: err?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                
                self.show(alert, sender: self)
                print(err!)
            }
            else{
                
            Database.database().reference().child("users").child(user!.uid).setValue(["email":self.email.text!, "displayName":self.displayName.text!])
            
            
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "logIn")
                    self.show(vc, sender: self)
                }

            
            }
            
        }
        
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "logIn")
            self.show(vc, sender: self)
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        displayName.delegate = self
        password.delegate = self
    
        
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
