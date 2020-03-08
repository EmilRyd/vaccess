//
//  FamilyMemberTableViewCell.swift
//  Vaccess
//
//  Created by emil on 2020-01-11.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class FamilyMemberTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var familyMemberImage: UIImageView!
    @IBOutlet weak var familyMemberNameLabel: UILabel!
    @IBOutlet weak var familyMemberPositionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
