//
//  CountryTableViewCell.swift
//  Vaccess
//
//  Created by emil on 2019-10-30.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellStyler: UIView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var continentLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//27    G: 171    B: 89
        
        cellStyler.backgroundColor = Theme.primary
        countryLabel.font = UIFont(name: "Proxima Nova", size: 17.0)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
