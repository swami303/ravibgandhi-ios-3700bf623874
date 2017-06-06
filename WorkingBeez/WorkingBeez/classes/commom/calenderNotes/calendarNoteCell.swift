//
//  calendarNoteCell.swift
//  WorkingBeez
//
//  Created by Swami on 3/13/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class calendarNoteCell: UITableViewCell {

    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblNoteDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
