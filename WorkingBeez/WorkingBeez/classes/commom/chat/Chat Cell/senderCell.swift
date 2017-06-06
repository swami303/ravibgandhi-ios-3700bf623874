//
//  senderCell.swift
//  SnowSensei
//
//  Created by Brainstorm on 12/13/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

class senderCell: UITableViewCell {

    @IBOutlet weak var lblMsgBackground: UILabel!
    @IBOutlet weak var imgRightTail: UIImageView!
    @IBOutlet weak var lblMsg: cLable!
    @IBOutlet weak var btnMsgTime: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
