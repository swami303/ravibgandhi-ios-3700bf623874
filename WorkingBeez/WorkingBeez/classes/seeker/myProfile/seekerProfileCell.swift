//
//  seekerProfileCell.swift
//  WorkingBeez
//
//  Created by Swami on 3/6/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class seekerProfileCell: UITableViewCell {

    @IBOutlet weak var lblCellTitle: UILabel!
    @IBOutlet weak var lblCellValue: UILabel!
    
    @IBOutlet weak var lblWHJobTitle: UILabel!
    @IBOutlet weak var lblWHCompany: UILabel!
    @IBOutlet weak var lblWHStartDate: UILabel!
    @IBOutlet weak var lblWHEndDate: UILabel!
    @IBOutlet weak var lblWHRole: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
