//
//  AppDelegate.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 1/26/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit
import CoreData
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var DBAccess: DatabaseAccess?
    
    var session = [String: String]()
    
    var localData = LocalDatastore()
    
    func setupParse() {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("sXNki6noKC9lOuG9b7HK0pAoruewMqICh8mgDUtw", clientKey: "Gh80MLplqjiOUFdmOP2TonDTcdmgevXbGaEhpGZR")
    }
    
    func setupDBAccess() {
        self.DBAccess = DatabaseAccess()
    }
    
    func getCoursesFromAD(userID: String, tableReload: Bool, cb: ([String], Bool) -> ()) {
        self.DBAccess!.getCourses(userID, tableReload: tableReload, callback: cb)
    }
    
    func getCourseListFromAD(searchText: String, cb: ([String]) -> ()) {
        self.DBAccess!.getCourseList(searchText, callback: cb)
    }
    
    func addCourseToUserAD(userID: String, courseName: String, cb: () -> ()) {
        self.DBAccess!.addCourseToUser(userID, courseName: courseName, callback: cb)
    }
    
    func deleteCourseFromUserAD(userID: String, courseName: String, index: NSIndexPath, cb: (NSIndexPath) -> ()) {
        self.DBAccess!.deleteCourseFromUser(userID, courseName: courseName, index: index, callback: cb)
    }
    
    func updateCellAD(courseName: String, cell: UITableViewCell, cb:(Int, Int, UITableViewCell) -> ()) {
        self.DBAccess!.updateCell(courseName, cell: cell, callback: cb)
    }
    
    func isUserInSessionAD(userID: String, seshID: String, cb: (String) -> ()) {
        self.DBAccess!.isUserInSession(userID, sessionID: seshID, cb)
    }
    
    func joinSessionAD(sessionID: String, userID: String, cb: () -> ()) {
        self.DBAccess!.joinSession(sessionID, userID: userID, callback: cb)
    }
    
    func addSessionAD(userID: String, courseName: String, description: String, location:String, geoTag: CLLocationCoordinate2D, cb: ([String: String]) -> ()) {
        self.DBAccess!.addSession(userID, courseName: courseName, description: description, location: location, geoTag: geoTag, callback: cb)
    }
    
    func getSessionInfoAD(fromID: String, cb:([[String: String]]) -> ()){
        self.DBAccess!.getSessionInfo(fromID, callback: cb)
    }
    
    func getSessionsAD(courseName: String, cb: ([[String: String]]) -> ()) {
        self.DBAccess!.getSessions(courseName, callback: cb)
    }
    
    func leaveSessionAD(userID: String, sessionID: String, cb: () -> ()) {
        self.DBAccess!.leaveSession(userID, sessionID: sessionID, callback: cb)
    }
    
    func getSessionUsersAD(sessionID: String, cb: ([(String, String)]) -> ()) {
        self.DBAccess!.getSessionUsers(sessionID, callback: cb)
    }
    
    func getSessionUsersPicturesAD(userIDs: [String], cb: ([String: UIImage]) -> ()) {
        self.DBAccess!.getSessionUsersPictures(userIDs, callback:cb)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setupParse()       // Set Parse Application keys and enable local datastore
        self.setupDBAccess()    // Setup local datastore
        
        // Set up Facebook
        PFFacebookUtils.initializeFacebook()
        
        
        // Set up Google Maps Services Key
        GMSServices.provideAPIKey("AIzaSyCg7Pfd0VZi559Ofjn5tKGeB8UK8q24-Wc")
        
        
        // Register for Push Notitications
        self.registerPushNotifications(application)
        
        // Navigation Controler Logic
        /* IMPOSSIBLE TO DEBUG
        let options = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as NSDictionary
        if launchOptions != nil {
        let notificationPayload = options
        var message = notificationPayload["message"] as String
        var seshid = notificationPayload["seshid"] as String
        var courseName = notificationPayload["courseName"] as String
        var userid = localData.getUserID()
        self.promptToJoin(userid, seshid: seshid, courseName: courseName, message: message)
        
        } else if localData.getSessionID() != ""{
        */
        if localData.getSessionID() != ""{
            self.go_to_locked()
            return true
        } // Else if the user has already signed in before
        else if localData.getUserID() != ""{
            self.go_to_masterview()
            return true
        } // If none of above apply, log in through facebook
        else{
            UIBarButtonItem.appearance().tintColor = cramrBlue
            let navController = self.window!.rootViewController as UINavigationController
            self.window?.makeKeyAndVisible()
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginStoryBoardID") as LoginViewController
            navController.pushViewController(vc, animated: false)
        }
        return true
    }
    
    func go_to_locked_from_push(seshid: String){
        self.getSessionInfoAD(seshid, cb: self.getSessionInfoCallback)
    }
    
    func getSessionInfoCallback(session: [[String: String]]) {
        self.session = session[0]
        self.window?.makeKeyAndVisible()
        let navController = self.window!.rootViewController as UINavigationController
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc = storyboard.instantiateViewControllerWithIdentifier("sessionLockedStoryBoardID") as SessionLockedViewController
        vc.session = self.session
        navController.pushViewController(vc, animated: false)
    }
    
    func go_to_locked(){
        self.getSessionInfoAD(localData.getSessionID(), cb: self.getSessionInfoCallback)
    }
    
    func go_to_masterview(){
        self.window?.makeKeyAndVisible()
        let navController = self.window!.rootViewController as UINavigationController
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc = storyboard.instantiateViewControllerWithIdentifier("masterViewStoryBoardID") as MasterViewController
        navController.pushViewController(vc, animated: false)
    }
    
    func go_to_create_from_push(courseName: String){
        self.window?.makeKeyAndVisible()
        let navController = self.window!.rootViewController as UINavigationController
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc = storyboard.instantiateViewControllerWithIdentifier("createViewStoryBoardID") as SessionCreationViewController
        vc.courseName = courseName
        navController.pushViewController(vc, animated: false)
    }
    
    func registerPushNotifications(application: UIApplication){
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("We Fucked Up on registering remote notifications (error)")
    }
    
    func handleClickedJoin_AfterEmptySession(userid: String, seshid: String, courseName: String, message: String, seshStillExists: Bool){
        if seshStillExists {
            self.joinSessionAD(seshid, userID: userid, cb: {})
            self.go_to_locked_from_push(seshid)
        }
        else{
            self.alertSessionNoLonger(courseName)
        }
        
    }
    
    func alertSessionNoLonger(courseName: String){
        let alert = UIAlertController(title: "Sorry", message: "Session no longer exists, create one and invite your friends", preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Create", style: .Default) { action -> Void in
            self.go_to_create_from_push(courseName)
        }
        alert.addAction(createAction)
        let closeAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
        }
        alert.addAction(closeAction)
        let navController = self.window!.rootViewController as UINavigationController
        navController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handlePushInviteCallback(userid: String, seshid: String, courseName: String, message: String, seshStillExists: Bool) {
        // If session still exists prompt to join or dismiss
        if seshStillExists {
            let alert = UIAlertController(title: "Hello", message: message, preferredStyle: .Alert)
            let joinAction = UIAlertAction(title: "Join", style: .Default) { action -> Void in
                self.addCourseToUserAD(userid, courseName: courseName, cb: {})
                if self.localData.getSessionID() != "" {   // User already in a session, remove him/her before joining new
                    self.leaveSessionAD(self.localData.getUserID(), sessionID: self.localData.getSessionID(), cb: {() -> Void in})
                }
                self.sessionExists_afterPromptAD(userid, seshid: seshid, courseName: courseName, message: "")
            }
            alert.addAction(joinAction)
            let closeAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
            }
            alert.addAction(closeAction)
            let navController = self.window!.rootViewController as UINavigationController
            navController.presentViewController(alert, animated: true, completion: nil)
        } else{
            self.alertSessionNoLonger(courseName)
        }
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        var message = userInfo["message"] as String
        var seshid = userInfo["seshid"] as String
        var courseName = userInfo["courseName"] as String
        var userid = localData.getUserID()
        //self.promptToJoin(userid, seshid: seshid, courseName: courseName, message: message)
        self.sessionExists_beforePromptAD(userid, seshid: seshid, courseName: courseName, message: message)
        
    }
    
    func sessionExists_beforePromptAD(userid: String, seshid: String, courseName: String, message: String){
        self.DBAccess!.sessionExists(userid, sessionID: seshid, courseName: courseName, message: message, self.handlePushInviteCallback)
    }
    
    func sessionExists_afterPromptAD(userid: String, seshid: String, courseName: String, message: String){
        self.DBAccess!.sessionExists(userid, sessionID: seshid,  courseName: courseName, message: message, cb: self.handleClickedJoin_AfterEmptySession)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.addUniqueObject("a"+localData.getUserID(), forKey: "channels")
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
        return wasHandled
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBAppEvents.activateApp()
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        // self.window?.tintColor = UIColorFromRGB(UInt(9616127))
        
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, isable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        FBSession.activeSession().close()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Casa.Cramr_v2_0" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Cramr_v2_0", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Cramr_v2_0.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    // Heavily influenced from http://stackoverflow.com/questions/25398664/check-for-internet-connection-availability-in-swift
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
    
}

