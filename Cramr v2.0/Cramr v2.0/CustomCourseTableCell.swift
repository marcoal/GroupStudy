//
//  CustomCourseTableCellController.swift
//  Cramr v2.0
//
//  Created by Roberto Alvarez on 2/19/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation


class CustomCourseTableCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.backgroundColor = .lightGrayColor()
    }
    
    
    @IBOutlet weak var courseNameLabel: UILabel!
    

    @IBOutlet weak var numPeopleLabel: UILabel!

    @IBOutlet weak var numSessionsLabel: UILabel!
    
    
    @IBOutlet weak var plusIcon: UIImageView!
    @IBOutlet weak var peopleIcon: UIImageView!
    @IBOutlet weak var bookIcon: UIImageView!
    
    func updateCell(courseName : String) {
        
        self.courseNameLabel?.text = getCourseID(courseName)
        internalUpdate(courseName)
    }
    
    private func internalUpdate(courseName : String) {
        var query = PFQuery(className: "Sessions")
        query.whereKey("course", equalTo: courseName)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                var sessions = objects as [PFObject]
                self.numSessionsLabel.text = String(sessions.count)
                var numPeople = 0
                for s in sessions {
                    numPeople += s["active_users"].count
                }
                self.numPeopleLabel.text = String(numPeople)
                
                self.numPeopleLabel.hidden = sessions.count == 0
                self.numSessionsLabel.hidden = sessions.count == 0
                self.bookIcon.hidden = sessions.count == 0
                self.peopleIcon.hidden = sessions.count == 0
                 self.plusIcon.hidden = !(sessions.count == 0)
                
            }
        }
    }
    
    
}