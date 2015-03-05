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
        self.contentView.backgroundColor = .clearColor()
    }
    
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var numPeopleLabel: UILabel!
    @IBOutlet weak var numSessionsLabel: UILabel!
    
    @IBOutlet weak var plusIcon: UIImageView!
    @IBOutlet weak var peopleIcon: UIImageView!
    @IBOutlet weak var bookIcon: UIImageView!
    
    func updateCell(courseName : String) {
//        self.courseNameLabel?.text = getCourseID(courseName)
//        internalUpdate(courseName)
    }
    
    func updateCellName(courseName: String) {
        self.courseNameLabel?.text = getCourseID(courseName)
    }
    
    func updateCellContents(numPeople: Int, numSessions: Int) {
        self.numSessionsLabel.text = String(numSessions)
        self.numPeopleLabel.text = String(numPeople)
        
        self.numPeopleLabel.hidden = numSessions == 0
        self.numSessionsLabel.hidden = numSessions == 0
        self.bookIcon.hidden = numSessions == 0
        self.peopleIcon.hidden = numSessions == 0
        self.plusIcon.hidden = numSessions != 0
    }
    
}