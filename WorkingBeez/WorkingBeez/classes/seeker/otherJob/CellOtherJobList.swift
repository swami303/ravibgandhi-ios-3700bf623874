//
//  CellOtherJobList.swift
//  WorkingBeez
//
//  Created by Brainstorm on 4/8/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class CellOtherJobList: UITableViewCell {

    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCateName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblTotalApplied: UILabel!
    @IBOutlet weak var imgCompanyPhoto: cImageView!
    @IBOutlet weak var viewCompanyRating: HCSStarRatingView!
    @IBOutlet weak var btnTotalPayment: UIButton!
    @IBOutlet weak var btnTotalKm: UIButton!
    @IBOutlet weak var btnTotalJobs: UIButton!
    @IBOutlet weak var lblHiredTillDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
