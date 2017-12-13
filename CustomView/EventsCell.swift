//
//  EventsCell.swift
//  Vdog
//
//  Created by tanut2539 on 9/12/2560 BE.
//  Copyright © 2560 Development. All rights reserved.
//

import UIKit

class EventsCell: UITableViewCell {

    @IBOutlet weak var Background: UIView!
    @IBOutlet weak var Images: UIImageView!
    @IBOutlet weak var TitleEvent: UILabel!
    @IBOutlet weak var DateEvent: UILabel!
    @IBOutlet weak var DogEvent: UILabel!
    @IBOutlet weak var HospitalEvent: UILabel!
    @IBOutlet weak var DetailsEvent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.Background.clipsToBounds = true
        self.Background.layer.cornerRadius = 10.0

        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.Images.clipsToBounds = true
        self.Images.layer.cornerRadius = self.Images.frame.height / 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
