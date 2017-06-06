//
//  CellacceptedSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/28/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class CellacceptedSeeker: UITableViewCell {

    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var imgCompanyPhoto: cImageView!
    @IBOutlet weak var viewCompanyRating: HCSStarRatingView!
    @IBOutlet weak var btnTotalPayment: UIButton!
    @IBOutlet weak var btnTotalKm: UIButton!
    @IBOutlet weak var btnTotalJobs: UIButton!
    @IBOutlet weak var lblHiredTillDate: UILabel!
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
