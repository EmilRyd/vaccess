//
//  VaccineHistoryTableViewCell.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-10-02.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class VaccineHistoryTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var startdateTextField: UITextField!
    @IBOutlet weak var enddateTextField: UITextField!
    @IBOutlet weak var doseTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        startdateTextField.font = UIFont(name: "Futura-Medium", size: 17.0)
        enddateTextField.font = UIFont(name: "Futura-Medium", size: 17.0)
        doseTextField.font = UIFont(name: "Futura-Medium", size: 17.0)
        
        doseTextField.adjustsFontSizeToFitWidth = true
        enddateTextField.adjustsFontSizeToFitWidth = true
        startdateTextField.adjustsFontSizeToFitWidth = true

        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
