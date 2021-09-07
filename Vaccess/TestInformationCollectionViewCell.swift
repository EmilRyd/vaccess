//
//  TestInformationCollectionViewCell.swift
//  Vaccess
//
//  Created by emil on 2020-09-30.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit

class TestInformationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vaccineLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var protectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//27    G: 171    B: 89
        
        //cellStyler.backgroundColor = Theme.primary
        
        //cardView.addRoundedCorners()
        
        vaccineLabel.adjustsFontSizeToFitWidth = true
        

        vaccineLabel.font = UIFont(name: "Futura-Bold", size: 16.0)
        
       // vaccineLabel.lineBreakMode = .byClipping
        //if #available(iOS 14.0, *) {
       //     vaccineLabel.lineBreakStrategy = .hangulWordPriority
      //  } else {
            // Fallback on earlier versions
      //}
        
        
    }

    }
