//
//  SessionContentViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/4/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

class SessionContentViewController: UIViewController {

    var dataObject: String? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var stupidLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stupidLabel.text = self.dataObject
    }
    
    
    
    
}