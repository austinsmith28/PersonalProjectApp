//
//  UserSettingsController.swift
//  AppOne
//
//  Created by Austin Smith on 4/7/19.
//

import UIKit
import Firebase

class UserSettingsController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    
   
    @IBOutlet weak var distanceSlider: UISlider!
    
    var maxDistance = 50.0
    
    @IBAction func distanceSlider(_ sender: UISlider){
        //self.distanceLabel.text = String(format:"%.0f", self.maxDistance)
        self.distanceLabel.text = String(Int(sender.value))
        let ref = Database.database().reference().child("users")
        
        let maxToPass = distanceLabel.text?.toDouble()
        ref.child(Auth.auth().currentUser!.uid).updateChildValues((["MaxDistance": maxToPass!]))
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMaxDistance()
       
        let distanceString :String = String(format:"%.0f", self.maxDistance)
        print("the string is", distanceString)
        self.distanceLabel.text = distanceString
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func signOut(_ sender: Any) {
        if Auth.auth().currentUser != nil {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showLogin()

            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "googleMap")
            self.show(vc, sender: self)
        }
    }
    
    func getMaxDistance() {
        print("in get maxDistance func")
        let ref1 = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref1.observe(.value, with: { (snapshot) in
            if snapshot.value as? [String : Any] != nil {
                
                
                guard let userProfile = snapshot.value as? [String : AnyObject] else {
                    return
                }
                
                
                // Get maxDistance
                self.maxDistance = (userProfile["MaxDistance"] as! Double)
                
                let distanceString :String = String(format:"%.0f", self.maxDistance)
                print("the string is", distanceString)
                self.distanceLabel.text = distanceString
                
                   print("Max distance inside", self.maxDistance)
                
                self.distanceSlider.value = Float(self.maxDistance)
                
                
            }
        }, withCancel: nil)
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
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
