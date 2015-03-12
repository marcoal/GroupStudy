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
    
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearch()
        self.courseTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // self.getParseData()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        view.backgroundColor = .whiteColor()
        self.courseTable.alpha = 0.9
        self.courseTable.tableFooterView = UIView()
        
        self.classSearch.layer.borderWidth = 1
        self.classSearch.layer.borderColor = cramrBlue.CGColor

    }
    
    // TABLE VIEW FUNCTIONS
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.courseTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = self.courses[indexPath.row] as? String
        cell.contentView.backgroundColor = .whiteColor()
        cell.textLabel?.textColor = cramrBlue
        return cell
    }
    
    func selectedRowCallBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if appDelegate.isConnectedToNetwork() {
            (UIApplication.sharedApplication().delegate as AppDelegate).addCourseToUserAD((UIApplication.sharedApplication().delegate as AppDelegate).localData.getUserID(), courseName: self.courses[indexPath.row] as String, cb: selectedRowCallBack)
        } else {
            checkForNetwork(self, self.appDelegate, message: "")
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

}
