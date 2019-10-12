//
//  VaccinationTabBarController.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-26.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class VaccinationTabBarController: UITabBarController {

    //MARK: Properties
    var vaccinations = [Vaccination]()
    var allVaccinations = [Vaccination]()
    var ongoingVaccinations = [Vaccination]()
    var vaccinationsWereChangedInVaccinationHistoryTableViewController: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
