//
//  AfterLogin.swift
//  AppOne
//
//  Created by David Lepore on 3/4/19.
//  Copyright © 2019 David&Austin. All rights reserved.
//

import UIKit
import Firebase
class AfterLogin: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        Auth.auth().addStateDidChangeListener { (Auth, user) in
            if user != nil {
                
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "googleMap")
                    self.show(vc, sender: self)
                }
                
            }
            else {
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "needsAccount")
                    self.show(vc, sender: self)
                }
                
            }
        }
           
        
            
        
       
        
        
        
        
        
       
 /*
        if ref.child("users").child(uid) == nil  {
            
               print(Auth.auth().currentUser?.isAnonymous)
                
               print ("no account associated with user, needs to sign up")
                DispatchQueue.main.async {
                    
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "needsAccount")
                    self.show(vc, sender: self)
                }
                
               
                
            }
            else {
                 print(Auth.auth().currentUser?.isAnonymous)
                 print ("user has an account")
                DispatchQueue.main.async {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "googleMap")
                    self.show(vc, sender: self)
                }
                
            }
 */
            //if(displayName != nil){
                //ref.child("users").child(uid!).setValue(["name":displayName!, "bitmojiAvatarUrl": bitmojiAvatarUrl as Any, "isAnonymous": isAnonymous ?? false])
            //}
            
            
            
            
            
            
        
         //self.performSegue(withIdentifier: "afterLogin", sender: self)
        // Do any additional setup after loading the view.
    }
    
    
    
    
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    //}
 

}
