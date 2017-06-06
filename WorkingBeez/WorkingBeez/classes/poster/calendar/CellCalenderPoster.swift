//
//  CellCalenderPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/9/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class CellCalenderPoster: UITableViewCell {

    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblRosterDate: UILabel!
    @IBOutlet weak var lblRosterTime: UILabel!
    @IBOutlet weak var lblRosterRepeatStatus: UILabel!
    @IBOutlet weak var lblRosterTotalPayment: UILabel!
    @IBOutlet weak var lblRosterBreak: UILabel!
    @IBOutlet weak var lblRosterBreakPaid: UILabel!
    @IBOutlet weak var viewRoster: cView!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var imgHireIcon: UIImageView!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnNote: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var scrUsers: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var lblTotalHired: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var lblNoteId: UILabel!
    @IBOutlet weak var imgDollarIcon: UIImageView!
    @IBOutlet weak var lblRemainTime: UILabel!
    
    @IBOutlet weak var btnMon: cButton!
    @IBOutlet weak var btnTue: cButton!
    @IBOutlet weak var btnWed: cButton!
    @IBOutlet weak var btnThu: cButton!
    @IBOutlet weak var btnFri: cButton!
    @IBOutlet weak var btnSat: cButton!
    @IBOutlet weak var btnSun: cButton!
    @IBOutlet weak var viewDays: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
