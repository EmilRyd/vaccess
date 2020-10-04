//
//  DataHandlingInformationTableViewCell.swift
//  Vaccess
//
//  Created by emil on 2020-09-13.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class DataHandlingInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
