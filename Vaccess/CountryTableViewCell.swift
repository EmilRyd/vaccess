//
//  CountryTableViewCell.swift
//  Vaccess
//
//  Created by emil on 2019-10-30.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var counrtyImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
