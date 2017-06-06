//
//  runningJobCellPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/25/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class runningJobCellPoster: UITableViewCell {

    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblSeekerName: UILabel!
    @IBOutlet weak var btnSeekerLocation: UIButton!
    @IBOutlet weak var lblPostNadJobId: UILabel!
    @IBOutlet weak var imgSeekerPhoto: cImageView!
    @IBOutlet weak var lblSeekerStatus: cLable!
    @IBOutlet weak var lblRunningDate: UILabel!
    @IBOutlet weak var lblRunningTime: UILabel!
    @IBOutlet weak var lblRunningRepeatStatus: UILabel!
    @IBOutlet weak var lblRunningRemainingTime: UILabel!
    @IBOutlet weak var lblRunningTotalPayment: UILabel!
    @IBOutlet weak var lblRunningBreak: UILabel!
    @IBOutlet weak var lblRunningBreakPaid: UILabel!
    @IBOutlet weak var viewRunning: cView!
    @IBOutlet weak var btnAbort: cButton!
    @IBOutlet weak var btnExtend: cButton!
    @IBOutlet weak var imgTimerIcon: UIImageView!
    
    @IBOutlet weak var viewDays: UIView!
    @IBOutlet weak var btnMon: cButton!
    @IBOutlet weak var btnTue: cButton!
    @IBOutlet weak var btnWed: cButton!
    @IBOutlet weak var btnThu: cButton!
    @IBOutlet weak var btnFri: cButton!
    @IBOutlet weak var btnSat: cButton!
    @IBOutlet weak var btnSun: cButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
