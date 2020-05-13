//
//  SectionHeaderTableViewCell.swift
//  Vaccess
//
//  Created by emil on 2020-03-15.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class SectionHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = UIFont(name: "Futura-Bold", size: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUp(year: String) {
        titleLabel.text = year
    }

}
