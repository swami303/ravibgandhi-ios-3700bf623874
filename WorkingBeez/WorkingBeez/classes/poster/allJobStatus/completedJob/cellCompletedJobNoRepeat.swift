//
//  cellCompletedJobNoRepeat.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/8/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class cellCompletedJobNoRepeat: UITableViewCell {

    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblSeekerName: UILabel!
    @IBOutlet weak var lblJobCompleted: UILabel!
    @IBOutlet weak var viewSeekerRating: HCSStarRatingView!
    @IBOutlet weak var imgSeekerPhoto: cImageView!
    @IBOutlet weak var lblSeekerStatus: cLable!
    @IBOutlet weak var btnSeekerKm: UIButton!
    @IBOutlet weak var btnSeekerHaveVehicle: UIButton!
    @IBOutlet weak var btnSeekerExp: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnIvite: cButton!
    @IBOutlet weak var btnInvoice: cButton!
    @IBOutlet weak var btnHelp: cButton!
    @IBOutlet weak var viewRoster: cView!
    @IBOutlet weak var lblRosterDate: UILabel!
    @IBOutlet weak var lblRosterTime: UILabel!
    @IBOutlet weak var lblRosterPayment: UILabel!
    @IBOutlet weak var lblRosterBreak: UILabel!
    @IBOutlet weak var lblRosterBreakPaid: UILabel!
    @IBOutlet weak var viewDays: UIView!
    @IBOutlet weak var lblRosterRepeat: UILabel!
    @IBOutlet weak var btnMon: cButton!
    @IBOutlet weak var btnTue: cButton!
    @IBOutlet weak var btnWed: cButton!
    @IBOutlet weak var btnThu: cButton!
    @IBOutlet weak var btnFri: cButton!
    @IBOutlet weak var btnSat: cButton!
    @IBOutlet weak var btnSun: cButton!
    @IBOutlet weak var lblJobStatus: UILabel!
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet weak var lblHourlyRate: UILabel!
    @IBOutlet weak var lblJobID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
