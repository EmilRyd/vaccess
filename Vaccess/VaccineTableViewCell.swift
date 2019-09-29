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
    @IBOutlet weak var tidsFoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
