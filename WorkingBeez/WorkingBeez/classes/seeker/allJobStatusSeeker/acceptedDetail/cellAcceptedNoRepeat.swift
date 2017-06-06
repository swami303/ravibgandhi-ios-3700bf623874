//
//  cellAcceptedNoRepeat.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class cellAcceptedNoRepeat: UITableViewCell {

    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblRosterDate: UILabel!
    @IBOutlet weak var lblRosterTime: UILabel!
    @IBOutlet weak var lblRosterRepeatStatus: UILabel!
    @IBOutlet weak var lblRosterTotalPayment: UILabel!
    @IBOutlet weak var lblRosterBreak: UILabel!
    @IBOutlet weak var lblRosterBreakPaid: UILabel!
    @IBOutlet weak var viewRoster: cView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var imgWatchIcon: UIImageView!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var lblCompleted: cLable!
    
    @IBOutlet weak var btnMon: cButton!
    @IBOutlet weak var btnTue: cButton!
    @IBOutlet weak var btnWed: cButton!
    @IBOutlet weak var btnThu: cButton!
    @IBOutlet weak var btnFri: cButton!
    @IBOutlet weak var btnSat: cButton!
    @IBOutlet weak var btnSun: cButton!
    @IBOutlet weak var viewDays: UIView!
    @IBOutlet weak var btnNotes: UIButton!
    @IBOutlet weak var lblRosterTimePeriod: UILabel!
    @IBOutlet weak var lblJobId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
