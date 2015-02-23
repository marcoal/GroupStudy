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
        query.limit = 15
        
        query.findObjectsInBackgroundWithBlock {
            (coursesFromQuery: [AnyObject]!, error: NSError!) -> Void in
                self.courses = coursesFromQuery
                self.courseTable.reloadData()
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
    
    func searchBar(_classSearch: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.courses = []
//            self.courseTable.alpha = 0.0
            self.courseTable.reloadData()
        } else {
            var query = PFQuery(className: "Course")
//            self.courseTable.alpha = 1.0
            query.limit = 15
            
            var regex = self.getRegexSearchTerm(searchText)
            query.whereKey("title", matchesRegex: regex, modifiers: "i")
            
            query.findObjectsInBackgroundWithBlock {
                (coursesFromQuery: [AnyObject]!, error: NSError!) -> Void in
                self.courses = coursesFromQuery
                self.courseTable.reloadData()
            }
        }
    }
    
    func setupSearch() {
        classSearch.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearch()
        self.courseTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // self.getParseData()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        view.backgroundColor = .darkGrayColor()
        self.courseTable.alpha = 0.7
        self.courseTable.tableFooterView = UIView()
    }
    
    // TABLE VIEW FUNCTIONS
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.courseTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = self.courses[indexPath.row]["title"] as? String
        cell.contentView.backgroundColor = .grayColor()
        cell.textLabel?.textColor = .whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var courseName = self.courses[indexPath.row]["title"] as String
      
        var curr_user = localData.getUserID()
        var query = PFQuery(className: "EnrolledCourses")
        if curr_user != "" {

            query.whereKey("userID", equalTo: curr_user)
            var object_user = query.getFirstObject()
            
            if object_user != nil {
                var course_array = object_user["enrolled_courses"] as [String]
                if !contains(course_array, courseName) {
                    course_array += [courseName]
                    object_user["enrolled_courses"] = course_array
                    object_user.saveInBackground()
                }
            } else {
                var new_object_user = PFObject(className: "EnrolledCourses")
                new_object_user["userID"] = curr_user
                new_object_user["enrolled_courses"] = [courseName]
                new_object_user.saveInBackground()
            }
            
        } else {
            // Make the user sign in again?
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
