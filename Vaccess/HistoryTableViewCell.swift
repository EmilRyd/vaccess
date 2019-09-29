//
//  HistoryTableViewCell.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-26.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var VaccineImage: UIImageView!
    @IBOutlet weak var VaccineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
