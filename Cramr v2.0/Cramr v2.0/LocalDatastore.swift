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
    var enrolledCourses: [(String, String)]!
    
    // The courses list will be a tuple of (CourseName, CourseID)
    func setEnrolledCourses(courses: [(String, String)]) {
        self.enrolledCourses = courses
    }
    
    
    
    init() {
        self.user = nil
        self.enrolledCourses = nil
    }
    
    func printInfo() {
        var u = self.user["userID"] as String
        var s = self.user["sessionID"] as String
        //        NSLog("User ID: " + u)
        //        NSLog("Sesh ID: " + s)
    }
    
    func setupParse() {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("sXNki6noKC9lOuG9b7HK0pAoruewMqICh8mgDUtw", clientKey: "Gh80MLplqjiOUFdmOP2TonDTcdmgevXbGaEhpGZR")
    }
    
    func deleteSession(){
        self.setSession("")
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
        return self.getUser()["userID"] as String
    }
    
    func getUserName() -> String{
        return self.getUser()["username"] as String
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
                self.user["userID"] = ""
                self.user["sessionID"] = ""
                self.user["username"] = ""
            }
        }
        self.printInfo()
        return self.user
    }
}
