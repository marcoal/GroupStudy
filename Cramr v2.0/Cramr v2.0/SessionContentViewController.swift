//
//  SessionContentViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/4/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

class SessionContentViewController: UIViewController {

    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var descript: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var dataObject: PFObject? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var stupidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stupidLabel.text = (self.dataObject?.objectForKey("course") as String)
        descript.text = (self.dataObject?.objectForKey("description") as String)
        locationLabel.text = (self.dataObject?.objectForKey("location") as String)
    }
    
    
    
    
}