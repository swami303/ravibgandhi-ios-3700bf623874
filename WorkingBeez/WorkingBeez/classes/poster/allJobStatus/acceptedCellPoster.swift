//
//  acceptedCellPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/24/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class acceptedCellPoster: UITableViewCell {

    
    @IBOutlet weak var lblSeekerName: UILabel!
    @IBOutlet weak var lblJobCompleted: UILabel!
    @IBOutlet weak var viewSeekerRating: HCSStarRatingView!
    @IBOutlet weak var imgSeekerPhoto: cImageView!
    @IBOutlet weak var lblSeekerStatus: cLable!
    @IBOutlet weak var btnSeekerKm: UIButton!
    @IBOutlet weak var btnSeekerHaveVehicle: UIButton!
    @IBOutlet weak var btnSeekerTotalJobs: UIButton!
    @IBOutlet weak var btnSeekerTotalPayment: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
