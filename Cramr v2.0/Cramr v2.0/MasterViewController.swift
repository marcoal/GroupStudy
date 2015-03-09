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
    
    
    @IBAction func popToPrevView(segue:UIStoryboardSegue) {
        refreshCourseList()
        self.tableView.reloadData()
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
    }
    
    func refreshCourseList(tableReload: Bool = true) {
        self.refreshingCourseList = true
        (UIApplication.sharedApplication().delegate as AppDelegate).getCoursesFromAD(localData.getUserID(), tableReload: tableReload, cb: refreshCourseListCallback)
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        self.refreshCourseList()
//        designLayout()
//    }
    
    func designLayout() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        //        let logo = UIImage(named: "white_cramr_logo")
        //        let imageView = UIImageView(image:logo)
        //        self.navigationItem.titleView = imageView
        self.title = "Cramr"
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = .whiteColor()
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
        
        self.tableView.registerClass(CustomCourseTableCell.self, forCellReuseIdentifier: "CourseCell")
        
        // Do any additional setup after loading the view, typically from a nib.
        designLayout()
        setupReload()
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
        if sessions.count != 0 {
            self.performSegueWithIdentifier("showDetail", sender: nil)
        } else {
            self.performSegueWithIdentifier("createSession", sender: nil)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        (UIApplication.sharedApplication().delegate as AppDelegate).getSessionsAD(self.coursesIn[indexPath.row] as String, cb: getSessionsCallback)
    }
    
    func deleteCourseCallback(indexPath: NSIndexPath) {
        //        refreshCourseList(tableReload: false)
        var index = find(self.coursesIn, self.coursesIn[indexPath.row] as String)
        self.coursesIn.removeAtIndex(index!)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            (UIApplication.sharedApplication().delegate as AppDelegate).deleteCourseFromUserAD(localData.getUserID(), courseName: (self.coursesIn[indexPath.row] as String), index: indexPath, cb: deleteCourseCallback)
        }
    }
    
    func waitForCompleteUpdate() {
        while (self.refreshingCourseList) {
            sleep(10)
        }
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
    }
}

