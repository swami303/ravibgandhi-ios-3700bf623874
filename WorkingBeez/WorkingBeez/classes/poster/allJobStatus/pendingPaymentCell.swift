//
//  pendingPaymentCell.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class pendingPaymentCell: UITableViewCell {

    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblSeekerName: UILabel!
    @IBOutlet weak var btnSeekerLocation: UIButton!
    @IBOutlet weak var lblPostNadJobId: UILabel!
    @IBOutlet weak var imgSeekerPhoto: cImageView!
    @IBOutlet weak var lblSeekerStatus: cLable!
    @IBOutlet weak var lblPendingDate: UILabel!
    @IBOutlet weak var lblPendingTime: UILabel!
    @IBOutlet weak var lblPendingRepeatStatus: UILabel!
    @IBOutlet weak var lblPendingTotalPayment: UILabel!
    @IBOutlet weak var lblPendingBreak: UILabel!
    @IBOutlet weak var lblPendingBreakPaid: UILabel!
    @IBOutlet weak var viewPending: cView!
    @IBOutlet weak var btnPay: cButton!
    @IBOutlet weak var btnPayInfo: UIButton!
    @IBOutlet weak var btnFillTimesheet: cButton!
    @IBOutlet weak var lblHourlyRate: UILabel!
    
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
