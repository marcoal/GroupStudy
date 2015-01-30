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

    @IBOutlet weak var classSearch: UISearchBar!
    
    @IBOutlet
    weak var courseTable: UITableView!
    
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
        query.limit = 10
        query.whereKey("name", containsString: searchText)
        
        query.findObjectsInBackgroundWithBlock {
            (coursesFromQuery: [AnyObject]!, error: NSError!) -> Void in
            self.courses = coursesFromQuery
            self.courseTable.reloadData()
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classSearch.placeholder = "Search for classes"
        var leftNavBarButton = UIBarButtonItem(customView: classSearch)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        classSearch.delegate = self
        
        
        
        
        self.courseTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.getParseData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.courseTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = self.courses[indexPath.row]["name"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected this crap!")
        
    }
}
