//
//  BarChartStackViewTestViewController.swift
//  Vaccess
//
//  Created by Emil Ryd on 2020-07-12.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class BarChartStackViewTestViewController: UIViewController {

    @IBOutlet weak var barchartstackview: BarChartView!
    @IBOutlet weak var barchart: BarChartStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        barchart.handleTap(increase: true)
        barchartstackview.handleTap(toValue: 1.0)
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
