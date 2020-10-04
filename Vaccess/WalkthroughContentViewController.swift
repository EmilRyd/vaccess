//
//  WalkthroughContentViewController.swift
//  Vaccess
//
//  Created by emil on 2020-08-15.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var subHeadingLabel: UILabel! {
        didSet {
            subHeadingLabel.numberOfLines = 0
            
        }
    }
    
    @IBOutlet var imageContentView: UIImageView! {
        didSet {
            //imageContentView.layer.borderWidth = 10
            //imageContentView.layer.borderColor = .init(srgbRed: 1, green: 1, blue: 0, alpha: 1)
        }
    }
    
    //MARK: Variables and properties
    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        imageContentView.image = UIImage(named: imageFile)

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

}
