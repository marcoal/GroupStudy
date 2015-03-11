//
//  DatabaseAccess.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/24/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import CoreData

class DatabaseAccess {
    
    func signupUser(user: FBGraphUser, callback: () -> ()) {
        var query = PFUser.query();
        query.whereKey("userID", containsString: user.objectID)
        query.findObjectsInBackgroundWithBlock {
            (users: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if users.count == 0 {
                    NSLog("Grabbing picture!")
                    var parse_user = PFUser()
                    parse_user.username = user.name
                    parse_user.password = ""
                    parse_user.email = user.objectForKey("email") as String
                    parse_user["userID"] = user.objectID
                    
                    var imageData : UIImage!
                    let url: NSURL? = NSURL(string: "https://graph.facebook.com/\(user.objectID)/picture")
                    if let data = NSData(contentsOfURL: url!) {
                        imageData = UIImage(data: data)
                    }
                    let image = UIImagePNGRepresentation(imageData)
                    let imageFile = PFFile(name:"profilepic.png", data:image)
                    var userPhoto = PFObject(className:"UserPhoto")
                    userPhoto["imageName"] = "Profile pic of \(user.objectID)"
                    userPhoto["imageFile"] = imageFile
                    parse_user["image"] = userPhoto
                    
                    parse_user.signUpInBackground()
                }
            } else {
                NSLog("Error in signupUser: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    // Only performs callback funciton if userID in sessionID
    func isUserInSession(userID: String, sessionID: String, cb: (String) -> ()) {
        var query = PFQuery(className: "Sessions")
        query.getObjectInBackgroundWithId(sessionID) {
            (object: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                var session = object as PFObject
                var users = session.objectForKey("active_users") as [String]
                var userQuery : PFQuery = PFUser.query()
                userQuery.whereKey("userID", containedIn: users)
                userQuery.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        var found = false
                        var users = objects as [PFObject]
                        var usersTupleArray = [(String, String)]()
                        for user in users {
                            var other_user_id = user["userID"] as String
                            if userID == other_user_id{
                                found = true
                            }
                        }
                        if found == false{
                            cb(userID)
                        }
                    }
                }
                
            } else {
                // Log details of the failure
                NSLog("Error in isUserInSesssion: %@ %@", error, error.userInfo!)
            }
        }
    }

    func sessionExists(userid: String, sessionID: String, courseName: String, message: String, cb: (String, String, String, String, Bool) -> ()){
        var query = PFQuery(className: "Sessions")
        query.getObjectInBackgroundWithId(sessionID) {
            (object: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                cb(userid, sessionID, courseName, message, true)
            }
            else {
                if error.code == kPFErrorObjectNotFound {
                     cb(userid, sessionID, courseName, message, false)
                }
                println("Ignore the Parse error in the log above, we handle no results matched the query")
            }
        }
    }

    func getSessionUsers(sessionID: String, callback: ([(String, String)]) -> ()) {
        var query = PFQuery(className: "Sessions")
        query.getObjectInBackgroundWithId(sessionID) {
            (object: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                var session = object as PFObject
                var users = session.objectForKey("active_users") as [String]
                var userQuery : PFQuery = PFUser.query()
                
                userQuery.whereKey("userID", containedIn: users)
                
                userQuery.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        var users = objects as [PFObject]
                        var usersTupleArray = [(String, String)]()
                        for user in users {
                            var userName = user["username"] as String
                            var userID = user["userID"] as String
                            var tup = (userName, userID)
                            usersTupleArray.append(tup)
                        }
                        callback(usersTupleArray)
                    }
                }
                
            } else {
                // Log details of the failure
                println("what the fuck")
                NSLog("Error in getSessionUsers: %@ %@", error, error.userInfo!)
            }
        }
        
    }
    
    func leaveSession(userID: String, sessionID: String, callback: () -> ()) {
        var query = PFQuery(className: "Sessions")
        query.getObjectInBackgroundWithId(sessionID) {
            (object: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                var session = object as PFObject
                var users = session.objectForKey("active_users") as [String]
                users.removeAtIndex(find(users, userID)!)
                if users.count > 0 {
                    session["active_users"] = users
                    session.saveInBackground()
                } else {
                    session.deleteInBackground()
                }
                localData.deleteSession()
                callback()
            } else {
                // Log details of the failure
                NSLog("Error in leaveSession: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func getSessionInfo(fromID: String, callback:([[String: String]]) -> ()){
        var sessionQuery = PFQuery(className: "Sessions")
        sessionQuery.whereKey("objectId", equalTo: fromID)
        sessionQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                var sessions = [[String: String]]()
                var parseSessions = objects as [PFObject]
                for object in parseSessions {
                    sessions.append(convertToSessionDict(object.objectId, object["description"] as String, object["location"] as String, object["course"] as String, object["latitude"] as String, object["longitude"] as String))
                }
                callback(sessions)
            } else {
                // Log details of the failure
                NSLog("Error in getSessionInfo: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func getSessions(courseName: String, callback: ([[String: String]]) -> ()) {
        var sessionQuery = PFQuery(className: "Sessions")
        sessionQuery.whereKey("course", equalTo: courseName)
        
        sessionQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                var sessions = [[String: String]]()
                var parseSessions = objects as [PFObject]
                for object in parseSessions {
                    sessions.append(convertToSessionDict(object.objectId, object["description"] as String, object["location"] as String, object["course"] as String, object["latitude"] as String, object["longitude"] as String))
                }
                callback(sessions)
            } else {
                // Log details of the failure
                NSLog("Error in getSessions: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    
    
    func addSession(userID: String, courseName: String, description: String, location: String, geoTag: CLLocationCoordinate2D, callback: ([String: String]) -> ()) {
        if userID != "" {
            var new_session = PFObject(className: "Sessions")
            new_session["active_users"] = [userID]
            new_session["description"] = description
            new_session["location"] = location
            new_session["course"] = courseName
            new_session["start_time"] = NSDate()
            
            new_session["latitude"] = "\(geoTag.latitude)"
            new_session["longitude"] = "\(geoTag.longitude)"
            new_session.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if success {
                    localData.setSession(new_session.objectId)
                    var sessionDict: [String: String] = convertToSessionDict(new_session.objectId, description, location, courseName, new_session["latitude"] as String, new_session["longitude"] as String)
                    callback(sessionDict)
                    
                }
            }
        }
    }
    
    func joinSession(sessionID: String, userID: String, callback: () -> ()) {
        var query = PFQuery(className: "Sessions")
        query.getObjectInBackgroundWithId(sessionID) {
            (object: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                var currSession = object as PFObject
                var activeUsers = currSession["active_users"] as [String]
                if find(activeUsers, userID) == nil {
                    activeUsers.append(userID)
                    currSession["active_users"] = activeUsers
                    currSession.save()
                } else {
                    // NSLog("User already in the session he/she is joining.")
                }
                localData.setSession(sessionID)
                callback()
            } else {
                // Log details of the failure
                NSLog("Error in joinSession: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    
    
    func updateCell(courseName: String, cell: UITableViewCell, callback: (Int, Int, UITableViewCell) -> ()) {
        var query = PFQuery(className: "Sessions")
        query.whereKey("course", equalTo: courseName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                var sessions = objects as [PFObject]
                var numSessions = sessions.count
                var numPeople = 0
                for s in sessions {
                    numPeople += s["active_users"].count
                }
                callback(numPeople, numSessions, cell)
            }
        }
    }
    
    
    func addCourseToUser(userID: String, courseName: String, callback: () -> ()) {
        var query = PFQuery(className: "EnrolledCourses")
        if userID != "" {
            query.whereKey("userID", equalTo: userID)
            query.getFirstObjectInBackgroundWithBlock {
                (object: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    if object != nil {
                        var object_user = object as PFObject
                        var course_array = object_user["enrolled_courses"] as [String]
                        if !contains(course_array, courseName) {
                            course_array += [courseName]
                            object_user["enrolled_courses"] = course_array
                            object_user.saveInBackground()
                        }
                    } else {
                        var new_object_user = PFObject(className: "EnrolledCourses")
                        new_object_user["userID"] = userID
                        new_object_user["enrolled_courses"] = [courseName]
                        new_object_user.saveInBackground()
                    }
                    callback()
                } else {
                    // Log details of the failure
                    NSLog("Error in addCourseToUser: %@ %@", error, error.userInfo!)
                }
            }
            
            
        }
    }
    
    func deleteCourseFromUser(userID: String, courseName: String, index: NSIndexPath, callback: (NSIndexPath) -> ()) {
        var query = PFQuery(className: "EnrolledCourses")
        if userID != "" {
            query.whereKey("userID", equalTo: userID)
            query.getFirstObjectInBackgroundWithBlock {
                (object: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    if object != nil {
                        var object_user = object as PFObject
                        object_user["enrolled_courses"].removeObject(courseName)
                        object_user.saveInBackground()
                    }
                    callback(index)
                } else {
                    // Log details of the failure
                    NSLog("Error in deleteCourseFromUser: %@ %@", error, error.userInfo!)
                }
            }
        }
    }
    
    
    func getCourses(userID: String, tableReload: Bool, callback: ([String], Bool) -> ()) {
        var query_courses = PFQuery(className: "EnrolledCourses")
        query_courses.whereKey("userID", equalTo: userID)
        query_courses.getFirstObjectInBackgroundWithBlock {
            (object: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                var course = object as PFObject
                var enrolled_courses = course["enrolled_courses"] as [String]
                callback(enrolled_courses, tableReload)
            } else {
                // Log details of the failure
                NSLog("Error in getCourses: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func getRegexSearchTerm(text: String) -> String {
        var searchText = text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if searchText == "" {
            return text
        }
        
        var regex = ""
        var spacer = "(?: )?"
        for ch in searchText {
            regex = regex + String(ch) + spacer
        }
        return regex
    }
    
    func getCourseList(searchText: String, callback: ([String]) -> ()) {
        if searchText == "" {
            callback([])
        } else {
            var query = PFQuery(className: "Course")
            query.limit = 15
            
            var regex = self.getRegexSearchTerm(searchText)
            query.whereKey("title", matchesRegex: regex, modifiers: "i")
            
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    var courses = objects as [PFObject]
                    var course_titles: [String] = []
                    for c in courses {
                        course_titles.append(c["title"] as String)
                    }
                    callback(course_titles)
                } else {
                    // Log details of the failure
                    NSLog("Error in getCourseList: %@ %@", error, error.userInfo!)
                }
                
            }
        }
    }
    
    
}
