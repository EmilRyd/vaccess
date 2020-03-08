//
//  CountryViewController.swift
//  Vaccess
//
//  Created by emil on 2020-01-24.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {

    @IBOutlet weak var randomTextView: UITextView!
    var font: UIFont?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomTextView.font = font ?? UIFont(name: "Helvetica", size: 17.0)
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
