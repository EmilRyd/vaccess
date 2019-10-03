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
    @IBOutlet weak var startdateLabel: UILabel!
    @IBOutlet weak var enddateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
