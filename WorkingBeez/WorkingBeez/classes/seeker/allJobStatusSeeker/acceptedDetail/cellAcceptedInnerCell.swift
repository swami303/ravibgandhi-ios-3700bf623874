//
//  cellAcceptedInnerCell.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class cellAcceptedInnerCell: UITableViewCell {

    @IBOutlet weak var lblRosterDate: UILabel!
    @IBOutlet weak var lblRosterTime: UILabel!
    @IBOutlet weak var lblRosterTotalPayment: UILabel!
    @IBOutlet weak var viewRoster: cView!
    @IBOutlet weak var lblRemainTime: UILabel!
    @IBOutlet weak var imgWatchIcon: UIImageView!
    @IBOutlet weak var btnCancel: cButton!
    @IBOutlet weak var btnStart: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}