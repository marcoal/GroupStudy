//
//  LocalDatastore.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/19/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

class LocalDatastore {
    
    var user: PFObject!
    
    init() {
        self.user = nil
    }
    
    func setUserSession(userID: String, sessionID: String) {
        
        var loggedUser = self.getUser()
        loggedUser["userID"] = userID
        loggedUser["sessionID"] = sessionID
        loggedUser.pinInBackground()
        
    }
    
    func setUser(userID: String) {
        var loggedUser = self.getUser()
        loggedUser["userID"] = userID
        loggedUser.pinInBackground()
    }
    
    func setSession(sessionID: String) {
        var loggedUser = self.getUser()
        loggedUser["sessionID"] = sessionID
        loggedUser.pinInBackground()
    }
    
    func getUserID() -> String {
        return self.getUser()["userID"] as String
    }
    
    func getSessionID() -> String {
        return self.getUser()["sessionID"] as String
    }
    
    private func getUser() -> PFObject {
        if self.user == nil {
            let query = PFQuery(className: "LoggedUsers")
            query.fromLocalDatastore()
            self.user = query.getFirstObject()
            if self.user == nil {
                self.user = PFObject(className: "LoggedUsers")
            }
        }
        return self.user
    }
}
