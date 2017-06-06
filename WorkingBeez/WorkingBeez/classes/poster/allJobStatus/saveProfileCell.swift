//
//  saveProfileCell.swift
//  WorkingBeez
//
//  Created by Brainstorm on 4/17/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class saveProfileCell: UITableViewCell {

    
    @IBOutlet weak var btnRemoveSavedProfile: UIButton!
    @IBOutlet weak var btnInviteToSavedProfile: cButton!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblSeekerName: UILabel!
    @IBOutlet weak var lblJobCompleted: UILabel!
    @IBOutlet weak var viewSeekerRating: HCSStarRatingView!
    @IBOutlet weak var imgSeekerPhoto: cImageView!
    @IBOutlet weak var lblSeekerStatus: cLable!
    @IBOutlet weak var btnSeekerKm: UIButton!
    @IBOutlet weak var btnSeekerHaveVehicle: UIButton!
    @IBOutlet weak var btnSeekerExp: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
