//
//  SessionLockedViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/9/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit

class SessionLockedViewController: UIViewController {
    
    @IBOutlet weak var className: UILabel!
    
    var session: PFObject? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        className.text = (self.session?.objectForKey("course") as String)
    }
    
}
