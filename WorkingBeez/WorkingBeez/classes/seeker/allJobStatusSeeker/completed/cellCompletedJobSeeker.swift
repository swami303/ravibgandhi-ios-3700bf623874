//
//  cellCompletedJobSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/12/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class cellCompletedJobSeeker: UITableViewCell
{

    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblHiredTillDate: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var imgCompanyPhoto: cImageView!
    @IBOutlet weak var lblHourlyRate: UILabel!
    @IBOutlet weak var lblTotalPayment: UILabel!
    @IBOutlet weak var lblRosterDate: UILabel!
    @IBOutlet weak var lblRosterTime: UILabel!
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
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var lblJobStatus: UILabel!
    @IBOutlet weak var btnfeedback: UIButton!
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
