//
//  WalkthroughPageViewController.swift
//  Vaccess
//
//  Created by emil on 2020-08-15.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit


protocol WalkthroughPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
        
    
}



class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    //MARK: Helper Method
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        if #available(iOS 13.0, *) {
            if let contentViewController = storyboard.instantiateViewController(identifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
                contentViewController.imageFile = pageImages[index]
                contentViewController.heading = pageHeadings[index]
                contentViewController.subHeading = pageSubHeadings[index]
                
                contentViewController.index = index
                
                return contentViewController
            }
        } else {
            if let contentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
                contentViewController.imageFile = pageImages[index]
                contentViewController.heading = pageHeadings[index]
                contentViewController.subHeading = pageSubHeadings[index]
                
                contentViewController.index = index
                
                return contentViewController
            }
        }
        
        return nil
    }
    
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    
    let pageHeadings = ["Katalogisera", "Håll koll", "Statistik", "Information", "Sätt igång!"]
    
    let pageSubHeadings = ["Lägg in tagna vaccinationer och få förslag på kommande vaccinationer", "Få notiser om kommande vaccinationer", "Tracka din historik", "Läs på om vacciner och ditt skydd", ""]
    
    let pageImages = ["undraw_add_post_64nu", "undraw_new_notifications_fhvw", "undraw_analytics_5pgy", "undraw_online_information_4ui6", "undraw_happy_announcement_ac67" ]
    
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set data source and delegate to itself
        dataSource = self
        delegate = self
        
        //Set first contentVeiwController
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: Page View Controller Delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }

}
