//
//  MenuViewController.swift
//  Vibe
//
//  Created by Allan Frederick on 8/15/18.
//  Copyright © 2018 Allan Frederick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var vibeSwitch: UISwitch!
    
    
    @IBAction func vibeSwitchToggle(_ sender: Any) {
        // Turn on vibe
        if self.vibeSwitch.isOn == true{
            FriendSystem.system.CURRENT_USER_REF.child("vibeStatus").setValue(1)
            print("vibe on")
        }
        // Turn off vibe
        else{
            FriendSystem.system.CURRENT_USER_REF.child("vibeStatus").setValue(0)
            print("vibe off")
        }
    }
    
    // Store array of menu items
    var menuItems:Array = [String]()
    
    // Index counter
    var indxCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Generate an array of menu items
        menuItems = ["Profile", "Friends", "Settings", "Logout"]
        // Load user data from firebase
        name.text = FriendsViewController.homeUser.nameDisplayed
        username.text = FriendsViewController.homeUser.usernameDisplayed
        getProfileImage(photoURL: FriendsViewController.homeUser.photoURL)
        // Round profile image
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    
    }
    
    // Set the number of rows, based on the number of menu items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    // Populate table cell rows with corresponding menu item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.menuItemLabel.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Detect selected row
        indxCount = indexPath.row
        // Logout detection
        if (indxCount == 3){
            userLogout()
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }
        else{
            // Go to corresponding view controller
            self.performSegue(withIdentifier: menuItems[indexPath.row], sender: self)
        }
    }
    
    // Convert profile image url to UIimage
    func getProfileImage(photoURL: String){
        let URL = NSURL(string: photoURL)!
        let imageData = NSData(contentsOf: URL as URL)!
        profileImage.image = UIImage(data: imageData as Data)
    }
    
    
    // Logout user
    func userLogout(){
        FriendSystem.system.logoutAccount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
