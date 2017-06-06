//
//  posterPaymentCardListCell.swift
//  WorkingBeez
//
//  Created by Swami on 3/6/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class posterPaymentCardListCell: UITableViewCell
{
    @IBOutlet weak var imgCardType: UIImageView!
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var btnEditOutlet: UIButton!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBOutlet weak var btnSelectCard: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
