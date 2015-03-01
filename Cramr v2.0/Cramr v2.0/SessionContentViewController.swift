//
//  SessionContentViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/4/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

class SessionContentViewController: UIViewController {
    
    var session: [String: String]!
    
    @IBOutlet weak var descript: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentUsersLabel: UILabel!
    
    func joinSessionCallback() {
        self.performSegueWithIdentifier("pushToLockedFromJoin", sender: self)
    }
    

    @IBAction func joinButton(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as AppDelegate).joinSessionAD(session["sessionID"]!, userID: localData.getUserID(), cb: joinSessionCallback)
    }

    func setUsersLabelCallback(userNamesAndIds: [(String, String)]) {
        for elem in userNamesAndIds {
            var userName = elem.0
            var userID = elem.1
            
            if currentUsersLabel.text == "" {
                currentUsersLabel.text = userName
            } else {
                currentUsersLabel.text = currentUsersLabel.text! + "\n" + userName
            }
            currentUsersLabel.numberOfLines = 0
            currentUsersLabel.sizeToFit()
        }
    }
    
    func setLabels() {
        descript.text = "We're working on: " + (session["description"]! as String)
        locationLabel.text = "We're working at: " + (session["location"]! as String)
        locationLabel.sizeToFit()
        currentUsersLabel.text = ""
        descript.numberOfLines = 0
        descript.sizeToFit()
        (UIApplication.sharedApplication().delegate as AppDelegate).getSessionUsersAD(session["sessionID"]!, cb: setUsersLabelCallback)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayColor()
        self.setLabels()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushToLockedFromJoin" {
            (segue.destinationViewController as SessionLockedViewController).session = self.session
        }
    }
    
    
}