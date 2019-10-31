//
//  BeginningViewController.swift
//  Vaccess
//
//  Created by emil on 2019-10-19.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class BeginningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
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
