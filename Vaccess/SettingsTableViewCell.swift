//
//  SettingsTableViewCell.swift
//  Vaccess
//
//  Created by emil on 2020-03-04.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var yesNoSwitch: UISwitch! {
        didSet {
            yesNoSwitch.layer.cornerRadius = yesNoSwitch.frame.height/2

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subjectLabel.adjustsFontSizeToFitWidth = true
        yesNoSwitch.backgroundColor = Theme.secondary
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
