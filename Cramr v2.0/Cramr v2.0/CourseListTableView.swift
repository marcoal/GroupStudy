//
//  SchoolTableView.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 1/29/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit
import Foundation

class CourseListTableView: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var courseTable: UITableView!
    
    @IBOutlet weak var classSearch: UISearchBar!
    var courses = []
    

    
    func getParseData() {
        var query = PFQuery(className: "Course")
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock {
            (coursesFromQuery: [AnyObject]!, error: NSError!) -> Void in
                self.courses = coursesFromQuery
                self.courseTable.reloadData()
        }
    }
    
    func searchBar(_classSearch: UISearchBar, textDidChange searchText: String) {
        var query = PFQuery(className: "Course")
        query.limit = 20
        query.whereKey("title", containsString: searchText)
        
        query.findObjectsInBackgroundWithBlock {
            (coursesFromQuery: [AnyObject]!, error: NSError!) -> Void in
            self.courses = coursesFromQuery
            self.courseTable.reloadData()
        }
    }
    
    func setupSearch() {
//        classSearch.placeholder = "Search for classes"
//        var leftNavBarButton = UIBarButtonItem(customView: classSearch)
//        self.navigationItem.rightBarButtonItem = leftNavBarButton
        classSearch.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearch()
        self.courseTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.getParseData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.courseTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = self.courses[indexPath.row]["title"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var courseName = self.courses[indexPath.row]["title"] as? String
        var newClass = PFObject(className: "CoursesIn")
        newClass["name"] = courseName
        newClass.saveInBackground()
//        var userID = 42
//        var
    }
}
