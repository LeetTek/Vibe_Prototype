//
//  FriendsViewController.swift
//  Vibe
//
//  Created by Allan Frederick on 7/26/18.
//  Copyright © 2018 Allan Frederick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FriendsViewController: UIViewController {

    // Create database reference
    var ref: DatabaseReference?
    
    // Hamburger menu icon
    @IBOutlet weak var menu: UIBarButtonItem!
    
    // Struct for user
    struct homeUser{
        // Variables for user data
        static var nameDisplayed: String = ""
        static var usernameDisplayed: String = ""
        static var vibeStatus: Int = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Define database reference
        ref = Database.database().reference()
        // Load user info
        loadData()
    }
    
    // Load user data from firebase
    func loadData(){
        // Pull data from firebase once
        self.ref?.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user values
            let value = snapshot.value as? NSDictionary
            homeUser.nameDisplayed = value?["name"] as? String ?? ""
            homeUser.usernameDisplayed = value?["username"] as? String ?? ""
            homeUser.vibeStatus = value?["vibeStatus"] as? Int ?? 0
            print("Username: " + homeUser.usernameDisplayed)
            print("Vibe Status: ", homeUser.vibeStatus)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Configure slide out menu functionality
    override func viewWillAppear(_ animated: Bool) {
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        // Detect swipe gesture
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
