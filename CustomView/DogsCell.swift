//
//  DogsCell.swift
//  Vdog
//
//  Created by tanut2539 on 10/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

class DogsCell: UICollectionViewCell {
    
    @IBOutlet weak var Background: UIView!
    @IBOutlet weak var Images: UIImageView!
    @IBOutlet weak var FilterBackground: UIVisualEffectView!
    @IBOutlet weak var DogName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.Background.clipsToBounds = true
        self.Background.layer.cornerRadius = 5.0
        
        
    }
    
}
