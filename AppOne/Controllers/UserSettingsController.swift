//
//  UserSettingsController.swift
//  AppOne
//
//  Created by David Lepore on 4/7/19.
//  Copyright © 2019 David&Austin. All rights reserved.
//

import UIKit
import Firebase

class UserSettingsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func signOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "logIn")
            self.show(vc, sender: self)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "googleMap")
            self.show(vc, sender: self)
        }
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
