//
//  OnboardingContentViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 3/10/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

class OnboardingContentViewController: UIViewController {
    
    var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    @IBOutlet weak var goToLoginButton: UIButton!
    
    var avplayer: AVPlayer = AVPlayer()
    
    @IBAction func goToLogin(sender: AnyObject) {
        appDelegate.go_to_masterview(animated: true)
    }

    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var heading: UILabel!
    
    var pageIndex: Int?
    var titleText : String!
    var subtitleText : String!
    var imageName : String!
    
    override func viewDidAppear(animated: Bool) {
        if self.imageName != "" {
            self.avplayer.play()
        }
    }
    
    func displayProfilePicture(pictDict : [String: UIImage]) {
        for im in pictDict.values {
            var imView = UIImageView(image: im)
            
            var rect = imView.frame
            rect.size.height = 100.0
            rect.size.width = 100.0
            rect.origin.x = (self.view.frame.width - rect.size.width) / CGFloat(2.0)
            rect.origin.y = CGFloat(170 + 10)
            
            imView.frame = rect
            imView.layer.cornerRadius = imView.frame.size.width / 2
            imView.clipsToBounds = true
            
            imView.layer.borderWidth = 1.0
            imView.layer.borderColor = cramrBlue.CGColor
            
            self.view.addSubview(imView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goToLoginButton.addTarget(self, action: "goToLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.backgroundColor = cramrBlue
        self.heading.text = self.titleText
        self.subtitle.text = self.subtitleText
        self.heading.alpha = 1.0
        self.goToLoginButton.hidden = self.pageIndex != 4
        
        if self.imageName != "" {
            self.addVideo()
        }
        
//        UIView.animateWithDuration(2.0, animations: { () -> Void in
//            self.heading.alpha = 1.0
//        })
        //appDelegate.getSessionUsersPicturesAD([appDelegate.localData.getUserID()], cb: displayProfilePicture)
        
        
    }
    
    func addVideo() {
        let filepath = NSBundle.mainBundle().pathForResource(self.imageName, ofType: "mov")
        let fileURL = NSURL.fileURLWithPath(filepath!)
        self.avplayer = AVPlayer.playerWithURL(fileURL) as AVPlayer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd", name: notificationKey, object: self.avplayer)
        
        var height = UIScreen.mainScreen().bounds.size.height / 1.5
        var width = height / 1.778
        
        var layer = AVPlayerLayer(player: self.avplayer)
        self.avplayer.actionAtItemEnd = AVPlayerActionAtItemEnd(rawValue: 2)!
        var rect = CGRectMake(50, 200, width, height)
        rect.origin.x = (self.view.frame.width - width) / 2.0
        rect.origin.y = self.view.frame.height - height - 40
        layer.frame = rect
        
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1.0
        
        self.view.layer.addSublayer(layer)

        // Do any additional setup for FB
    }
    
    /* Currently notification at end of video not working, but in either case, every discusion online states that there is no way to re-start video after end without hicups (with AVPlayer) */
    func playerItemDidReachEnd(notif: NSNotification){
        var p:  AVPlayer = notif.object as AVPlayer
        p.seekToTime(kCMTimeZero)
        p.play()
    }
}
