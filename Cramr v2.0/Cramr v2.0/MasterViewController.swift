//
//  MasterViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 1/26/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var coursesIn: [String] = []
    
    var refreshingCourseList: Bool = false
    
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    @IBAction func popToPrevView(segue:UIStoryboardSegue) {
        if appDelegate.isConnectedToNetwork(){
            refreshCourseList()
            self.tableView.reloadData()
        } else {
            checkForNetwork(self, self.appDelegate, message: "Cannot add courses with no internet connection.")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func refreshCourseListCallback(courses: [String], tableReload: Bool) {
        self.coursesIn = courses
        if tableReload {
            self.tableView.reloadData()
        }
        self.refreshingCourseList = false
        self.view.userInteractionEnabled = true
    }
    
    func refreshCourseList(tableReload: Bool = true) {
        self.refreshingCourseList = true
        appDelegate.getCoursesFromAD(appDelegate.localData.getUserID(), tableReload: tableReload, cb: refreshCourseListCallback)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.userInteractionEnabled = false
        if appDelegate.isConnectedToNetwork(){
            super.viewDidAppear(animated)
            designLayout()
            self.refreshCourseList()
        }
        
    }
    
    func addButtonPressed(){
        if appDelegate.isConnectedToNetwork(){
            if appDelegate.isConnectedToNetwork(){
                self.performSegueWithIdentifier("toAddCourse", sender: nil)
            } else{
                checkForNetwork(self, self.appDelegate, message: "Cannot add courses with no internet connection.")
            }
        }
        checkForNetwork(self, self.appDelegate, message: "Cannot add courses with no internet connection.")
    }
    
    func designLayout() {
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        self.title = "Cramr"
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false

        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = cramrBlue
        self.view.backgroundColor = .clearColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 21.0)!]
        self.tableView.backgroundColor = UIColor.whiteColor()
        //        self.tableView.backgroundView = UIImageView(image: UIImage(named: "test_background"))
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.tableView?.tableFooterView = UIView()
    }
    
    func updateCells() {
        checkForNetwork(self, self.appDelegate)
        self.refreshCourseList()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
       
    }
    
    func setupReload() {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateCells"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        self.refreshControl!.tintColor = cramrBlue

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCourseList()
        appDelegate.registerPushNotifications(UIApplication.sharedApplication())
        self.tableView.registerClass(CustomCourseTableCell.self, forCellReuseIdentifier: "CourseCell")
        
        // Do any additional setup after loading the view, typically from a nib.
        designLayout()
        self.setupReload()
        checkForNetwork(self, self.appDelegate)
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addButtonPressed")
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coursesIn.count;
    }
    
    func cellUpdateCallback(numPeople: Int, numSessions: Int, cell: UITableViewCell) {
        (cell as CustomCourseTableCell).updateCellContents(numPeople, numSessions: numSessions)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CustomCourseTableCell = self.tableView.dequeueReusableCellWithIdentifier("CustomCourseCell") as CustomCourseTableCell
        var fullCourseName = self.coursesIn[indexPath.row] as String
        cell.updateCellName(fullCourseName)
        (UIApplication.sharedApplication().delegate as AppDelegate).updateCellAD(fullCourseName, cell: cell as UITableViewCell, cb: cellUpdateCallback)
        return cell
    }
    
    var sessionsForSelectedRow = [[String: String]]()
    
    func getSessionsCallback(sessions: [[String: String]]) {
        self.sessionsForSelectedRow = sessions
        if self.appDelegate.isConnectedToNetwork() {
            if sessions.count != 0 {
                self.performSegueWithIdentifier("showDetail", sender: nil)
            } else {
                self.performSegueWithIdentifier("createSession", sender: nil)
            }
        } else {
            self.view.userInteractionEnabled = true
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.appDelegate.isConnectedToNetwork() {
            self.view.userInteractionEnabled = false
            (UIApplication.sharedApplication().delegate as AppDelegate).getSessionsAD(self.coursesIn[indexPath.row] as String, cb: getSessionsCallback)
        }
    }
    
    func deleteCourseCallback(indexPath: NSIndexPath) {
        //        refreshCourseList(tableReload: false)
        var index = find(self.coursesIn, self.coursesIn[indexPath.row] as String)
        self.coursesIn.removeAtIndex(index!)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            (UIApplication.sharedApplication().delegate as AppDelegate).deleteCourseFromUserAD((UIApplication.sharedApplication().delegate as AppDelegate).localData.getUserID(), courseName: (self.coursesIn[indexPath.row] as String), index: indexPath, cb: deleteCourseCallback)
        }
    }
    
    // May not be necessary if we don't see the concurrency issue any longer.
    func waitForCompleteUpdate() {
        self.view.userInteractionEnabled = false
        while (self.refreshingCourseList) {
            sleep(10)
        }
        self.view.userInteractionEnabled = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            waitForCompleteUpdate()
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var courseName = self.coursesIn[indexPath.row] as String
                var s = (segue.destinationViewController as SessionBrowserViewController)
                s.courseName = courseName
                s.sessions = self.sessionsForSelectedRow
            }
        } else if segue.identifier == "createSession" {
            waitForCompleteUpdate()
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var courseName = self.coursesIn[indexPath.row] as String
                (segue.destinationViewController as SessionCreationViewController).courseName = courseName
                
            }
        }
        self.view.userInteractionEnabled = true
    }
}

