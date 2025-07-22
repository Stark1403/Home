//
//  SeriesCellCollectionViewCell.swift
//  LocationEKT
//
//  Created by ARIEL DIAZ on 24/11/19.
//  Copyright © 2019 Latbc. All rights reserved.
//

import UIKit

class SeriesCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tumnail: UIImageView!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tumnail.tintColor = .orangePlanningPoker
        
    }

}
