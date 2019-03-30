//
//  ViewController.swift
//  AppOne
//
//  Created by David Lepore on 3/4/19.
//  Copyright © 2019 David&Austin. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import Foundation
import ImageIO
import GoogleMaps
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    
    var ref : DatabaseReference!
    var uid : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
            
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        SCSDKLoginClient.login(from: self) { (success : Bool, error : Error?) in
            if(success){
            self.fetchSnapUserInfo()
          
                
            }
            else {
                print(error.debugDescription)
            }
        }

    }
    
    
 
    
    private func fetchSnapUserInfo(){
        
        
        let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
        
        let variables = ["page": "bitmoji"]
        
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
            guard let resources = resources,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else { return }
            
            let displayName = me["displayName"] as? String
            var bitmojiAvatarUrl: String?
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                bitmojiAvatarUrl = bitmoji["avatar"] as? String
            }
            
    
            
            
            Auth.auth().signInAnonymously() { (authResult, error) in
               let ref = Database.database().reference()
               let user = authResult?.user
                let isAnonymous = user?.isAnonymous
               let uid = user?.uid
                
                
                
                
                
                ref.child("users").child(uid!).setValue(["name":displayName, "isAnonymous":isAnonymous, "bitmojiURL": bitmojiAvatarUrl])
            }
        
           
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
        })
        
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "afterLogin")
            self.show(vc, sender: self)
        }
       

    }

    
    /*
    func hasAccount () -> Bool {
        if uid != nil || uid != "" {
            return account
        }
        return account
    }
  */

}

























