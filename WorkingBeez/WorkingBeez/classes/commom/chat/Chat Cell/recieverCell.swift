//
//  recieverCell.swift
//  SnowSensei
//
//  Created by Brainstorm on 12/13/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

class recieverCell: UITableViewCell {

    
    @IBOutlet weak var imgleftTail: UIImageView!
    @IBOutlet weak var imgUserImage: cImageView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblMsgTime: UILabel!
    
    @IBOutlet weak var lblMsgBackground: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
