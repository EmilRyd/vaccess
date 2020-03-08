//
//  ProtectionTableViewCell.swift
//  Vaccess
//
//  Created by emil on 2020-02-17.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class ProtectionTableViewCell: UITableViewCell {

    @IBOutlet weak var namnEtikett: UILabel!
    @IBOutlet weak var timeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeView.layer.cornerRadius = timeView.frame.size.width/2
        namnEtikett.numberOfLines = 1
        namnEtikett.adjustsFontSizeToFitWidth = true
        namnEtikett.font = UIFont(name: "Futura-Medium", size: 17.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
