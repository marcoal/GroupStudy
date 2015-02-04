//
//  DetailViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 1/26/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var sessions: [String] = []
    var pageController: UIPageViewController?
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

    
    var detailItem: String? {
        didSet {
            // Update the view.
//            self.configureView()
        }
    }
    
    func viewControllerAtIndex(index: Int) -> SessionContentViewController? {
        if (sessions.count == 0 || index >= sessions.count) {
            return nil
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let dataViewController = storyboard?.instantiateViewControllerWithIdentifier("sessionContent") as SessionContentViewController
        dataViewController.dataObject = sessions[index]
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
        sessions = ["First", "Second"]
        
        organizeChildren()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureView() {
        // Update the user interface for the detail item.
        //        if let detail: AnyObject = self.detailItem {
        //            if let label = self.detailDescriptionLabel {
        //                if (detail.valueForKey("course_desc")? != nil) {
        //                    label.text = "COURSE DESCRIPTION: " + detail.valueForKey("course_desc")!.description
        //                }
        //            }
        //        }
    }

}

