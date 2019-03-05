//
//  ViewController.swift
//  AppOne
//
//  Created by David Lepore on 3/4/19.
//  Copyright © 2019 David&Austin. All rights reserved.
//

import UIKit
import SCSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginButton(_ sender: Any) {
        SCSDKLoginClient.login(from: self, completion: { success, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if success {
                self.fetchSnapUserInfo()
                self.performSegue(withIdentifier: "afterLogin", sender: self)
                
            }
        })
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
           
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
        })
 
    }

}

