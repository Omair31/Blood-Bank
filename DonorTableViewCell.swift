//
//  DonorTableViewCell.swift
//  BloodBank2
//
//  Created by Omeir on 17/05/2017.
//  Copyright © 2017 Omeir. All rights reserved.
//

import UIKit

class DonorTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userContactLabel: UILabel!
    
    @IBOutlet weak var userBloodGroupLabel: UILabel!
    
    @IBOutlet weak var userRHValueLabel: UILabel!
    
    @IBOutlet weak var userTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
