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
    
    func courseListCallback(courses: [String]) {
        self.courses = courses
        self.courseTable.reloadData()
    }

    
    func searchBar(_classSearch: UISearchBar, textDidChange searchText: String) {
        (UIApplication.sharedApplication().delegate as AppDelegate).getCourseListFromAD(searchText, cb: courseListCallback)
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
        cell.textLabel?.text = self.courses[indexPath.row] as? String
        cell.contentView.backgroundColor = .grayColor()
        cell.textLabel?.textColor = .whiteColor()
        return cell
    }
    
    func selectedRowCallBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        (UIApplication.sharedApplication().delegate as AppDelegate).addCourseToUserAD(localData.getUserID(), courseName: self.courses[indexPath.row] as String, cb: selectedRowCallBack)
    }

}
