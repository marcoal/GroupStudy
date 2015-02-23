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
//        self.setupParse()
//        getUser()
    }
    
    func printInfo() {
        var u = self.user["userID"] as String
        var s = self.user["sessionID"] as String
        NSLog("User ID: " + u)
        NSLog("Sesh ID: " + s)
    }
    
    func setupParse() {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("sXNki6noKC9lOuG9b7HK0pAoruewMqICh8mgDUtw", clientKey: "Gh80MLplqjiOUFdmOP2TonDTcdmgevXbGaEhpGZR")
    }

    
    func setUserSession(userID: String, sessionID: String) {
        var loggedUser = self.getUser()
        loggedUser["userID"] = userID
        loggedUser["sessionID"] = sessionID
        self.printInfo()
        loggedUser.pinInBackground()
        
    }
    
    func setUserID(userID: String) {
        var loggedUser = self.getUser()
        loggedUser["userID"] = userID
        loggedUser.pinInBackground()
    }
    
    func setUserName(username: String){
        var loggedUser = self.getUser()
        loggedUser["username"] = username
        loggedUser.pinInBackground()
    }
    
    func setSession(sessionID: String) {
        var loggedUser = self.getUser()
        loggedUser["sessionID"] = sessionID
        self.printInfo()
        loggedUser.pinInBackground()
    }
    
    func getUserID() -> String {
        if self.user == nil {
            return ""
        }
        return self.getUser()["userID"] as String
    }
    
    func getUserName() -> String{
        if self.user == nil{
            return ""
        }
        return self.getUserName() as String
    }
    
    func getSessionID() -> String {
        if self.user == nil {
            return ""
        }
        return self.getUser()["sessionID"] as String
    }
    
    private func getUser() -> PFObject {
        if self.user == nil {
            let query = PFQuery(className: "LoggedUsers")
            query.fromLocalDatastore()
            self.user = query.getFirstObject()
            if self.user == nil {
                self.user = PFObject(className: "LoggedUsers")
                self.user["userID"] = ""
                self.user["sessionID"] = ""
                self.user["username"] = ""
            }
        }
        self.printInfo()
        return self.user
    }
}
