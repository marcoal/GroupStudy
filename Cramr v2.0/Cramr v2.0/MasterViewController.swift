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
    }

    func refreshCourseList(tableReload: Bool = true) {
        (UIApplication.sharedApplication().delegate as AppDelegate).getCoursesFromAD(localData.getUserID(), tableReload: tableReload, cb: refreshCourseListCallback)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshCourseList()
        designLayout()
    }
    
    func designLayout() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let logo = UIImage(named: "Cramr Logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.view.backgroundColor = .lightGrayColor()
        
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
        self.refreshControl!.tintColor = cramrBlue as UIColor
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
        self.performSegueWithIdentifier("showDetail", sender: nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var courseName = self.coursesIn[indexPath.row] as String
                var s = (segue.destinationViewController as SessionBrowserViewController)
                s.courseName = courseName
                s.sessions = self.sessionsForSelectedRow
            }
        }
    }

}

