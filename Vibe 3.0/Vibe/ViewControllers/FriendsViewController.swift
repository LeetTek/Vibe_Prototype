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

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var friendsTable: UITableView!
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        FriendSystem.system.removeFriendObserver()
        performSegue(withIdentifier: "goToAddFriend", sender: self)
    }
    @IBOutlet weak var menu: UIBarButtonItem!
    
    // Pre-load properties for current user to be displayed on slide out menu
    // before menu is seen by user
    struct homeUser{
        static var nameDisplayed: String = ""
        static var usernameDisplayed: String = ""
        static var vibeStatus: Int = 0
        static var photoURL: String = ""
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.friendList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsTableViewCell
        // Display username
        cell.friendLabel.text! = FriendSystem.system.friendList[indexPath.row].username
        // Convert download photoURL to UIimage
        let URL = NSURL(string: FriendSystem.system.friendList[indexPath.row].photoURL)!
        let imageData = NSData(contentsOf: URL as URL)!
        cell.friendProfilePhoto.image = UIImage(data: imageData as Data)
        // Round prfile images
        cell.friendProfilePhoto.layer.cornerRadius = cell.friendProfilePhoto.frame.size.width/2
        cell.friendProfilePhoto.clipsToBounds = true
        cell.friendProfilePhoto.layer.masksToBounds = true
        // Vibe indication
        if FriendSystem.system.friendList[indexPath.row].vibeStatus == 0 {
            cell.vibeIndicator.image = UIImage(named: "Blank_Circle-2")
        }
        else{
            cell.vibeIndicator.image = UIImage(named: "Green_Circle-1")
        }
        cell.vibeIndicator.layer.cornerRadius = cell.vibeIndicator.frame.size.width/2
        cell.vibeIndicator.clipsToBounds = true
        cell.vibeIndicator.layer.borderWidth = 1
        cell.vibeIndicator.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    // Set up refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        // Specifies which action will handle the refresh upon ValueChanged
        refreshControl.addTarget(self, action: #selector(refreshHandler(sender:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    // Reloads data and updates table view
    @objc func refreshHandler(sender: AnyObject){
        FriendSystem.system.removeFriendObserver()
        // Delay pull data for 1 second for asthetic purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            FriendSystem.system.addFriendObserver{self.friendsTable.reloadData()}
            print("Table values updated")
            self.refreshControl.endRefreshing()
        })
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Get user info and pre-load into current user properties to display on slide out menu
        FriendSystem.system.getCurrentUser { (User) in
            homeUser.nameDisplayed = User.name
            print("name: ", homeUser.nameDisplayed)
            homeUser.usernameDisplayed = User.username
            homeUser.photoURL = User.photoURL
            print("photoURL: ", homeUser.photoURL)
            
    }
        // Load friends list with updated content
        FriendSystem.system.addFriendObserver {self.friendsTable.reloadData()}
        // Add refresh control to tableView
        self.friendsTable.addSubview(self.refreshControl)
    }
    
    // Convert profile image url to UIimage
    func getProfileImage(photoURL: String){
        let URL = NSURL(string: photoURL)!
        let imageData = NSData(contentsOf: URL as URL)!
        //MenuViewController.profileImage.image = UIImage(data: imageData as Data)
    }
    
    // Configure slide out menu functionality
    override func viewWillAppear(_ animated: Bool) {
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        // Detect swipe gesture
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
    }
    
    // Removes observer when leaving view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        FriendSystem.system.removeFriendObserver()
        if segue.identifier == "goToAddFriend"{
            FriendSystem.system.removeFriendObserver()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

