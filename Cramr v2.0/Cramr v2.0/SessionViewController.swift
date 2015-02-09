//
//  DetailViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 1/26/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit

class SessionViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var sessions: [String] = []
    var pageController: UIPageViewController?
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

    
    var detailItem: String? {
        didSet {
           
        }
    }
    
    func viewControllerAtIndex(index: Int) -> SessionContentViewController? {
        if (sessions.count == 0 || index >= sessions.count) {
            return nil
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let dataViewController = storyboard?.instantiateViewControllerWithIdentifier("sessionContent") as SessionContentViewController
        dataViewController.dataObject = self.sessions[index]
        return dataViewController
    }
    
    
    func indexOfViewController(viewController: SessionContentViewController) -> Int {
        if let dataObject: String = viewController.dataObject {
            return find(sessions, dataObject)!
        } else {
            return NSNotFound
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController
            as SessionContentViewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController
            as SessionContentViewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == sessions.count {
            return nil
        }
        return viewControllerAtIndex(index)
    }

    func organizeChildren() {
        pageController = UIPageViewController(
            transitionStyle: .Scroll,
            navigationOrientation: .Horizontal,
            options: nil)
        
        pageController!.delegate = self
        pageController!.dataSource = self
        
        let startingViewController: SessionContentViewController =
        viewControllerAtIndex(0)!
        
        let viewControllers: NSArray = [startingViewController]
        pageController!.setViewControllers(viewControllers,
            direction: .Forward,
            animated: false,
            completion: nil)
        
        self.addChildViewController(pageController!)
        self.view.addSubview(self.pageController!.view)
        
        var pageViewRect = self.view.bounds
        pageController!.view.frame = pageViewRect
        pageController!.didMoveToParentViewController(self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
//        sessions = ["First", "Second"]
        self.configureView()
        organizeChildren()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureView() {
        var sessionQuery = PFQuery(className: "activeSessions")
        sessionQuery.whereKey("courseName", equalTo: self.detailItem)
        var session = sessionQuery.getFirstObject()
        if session == nil {
            self.sessions = [self.detailItem!]
            //create new session
        } else {
            var currentSessionArray = session["currentSessions"] as [String] //I think we will want to convert this to an object, because it will have information associated with it
            for currentSession in currentSessionArray {
                self.sessions.append(currentSession)
            }
            //self.sessions = [self.detailItem!, self.detailItem! + " SECOND"]
        }
        

        
        
    }

}

