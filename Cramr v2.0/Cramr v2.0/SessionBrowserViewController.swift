//
//  SessionBrowserViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/4/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit

class SessionBrowserViewController : UIViewController {
    
    var courseName: String? {
        didSet {
            // Update the view.
            //            self.configureView()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sessionSwiper" {
            (segue.destinationViewController as SessionViewController).detailItem = self.courseName
        }
    }

}