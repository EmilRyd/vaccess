//
//  SettingsHeaderTableViewCell.swift
//  Vaccess
//
//  Created by emil on 2020-03-09.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class SettingsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func setUp(title: String) {
        titleLabel.text = title
    }

}
