//
//  rateAndReviewCell.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class rateAndReviewCell: UITableViewCell {

    @IBOutlet weak var lblReView: UILabel!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var imgUserPic: cImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
