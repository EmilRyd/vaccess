//
//  WalkthroughViewController.swift
//  Vaccess
//
//  Created by emil on 2020-08-15.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit


class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    
    
    //MARK: Outlets
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25
            nextButton.layer.masksToBounds = true
            nextButton.titleLabel?.text = "NÄSTA"
            nextButton.titleLabel?.font = UIFont(name: "Futura-medium", size: 15)
        }
    }
    
    //MARK: Properties
    
    var walkthroughPageViewController: WalkthroughPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextButton.titleLabel?.text = "NÄSTA"
        nextButton.titleLabel?.font = UIFont(name: "Futura-medium", size: 15)
    }
    
    
    //MARK: Actions
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index  = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...3:
                walkthroughPageViewController?.forwardPage()
            case 4:
                UserDefaults.standard.set(true, forKey: "hasWatchedWalkthrough")
                self.dismiss(animated: true, completion: nil)
                
            default:
                self.dismiss(animated: true, completion: nil)
            
            }
        }
        updateUI()
    }
    
    //MARK: View Controller Life Cycle
    func updateUI() {
        if let index  = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...3:
                nextButton.setTitle("NÄSTA", for: .normal)
            case 4:

                nextButton.setTitle("SÄTT IGÅNG!", for: .normal)
            default:
                self.dismiss(animated: true, completion: nil)
            
            }
            
            pageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
        
    }
    

}
