//
//  VaccineTableViewCell.swift
//  Vaccess
//
//  Created by Gustav Ryd on 2019-09-14.
//  Copyright © 2019 Ryd Corporation. All rights reserved.
//

import UIKit

class VaccineTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var namnEtikett: UILabel!
    @IBOutlet weak var tidsEtikett: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var vaccinationProgramLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2

        timeView.layer.cornerRadius = timeView.frame.size.width/2
        namnEtikett.numberOfLines = 1
        namnEtikett.adjustsFontSizeToFitWidth = true
        namnEtikett.font = UIFont(name: "Futura-Medium", size: 22.0)
        tidsEtikett.font = UIFont(name: "Futura-Medium", size: 17.0)
        
        vaccinationProgramLabel.isHidden = true

        //colorView.frame = CGRect(x: colorView.frame.maxX, y: colorView.frame.maxY, width: namnEtikett.frame.width, height: colorView.frame.height)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
