//
//  customCellSwift.swift
//  orderpilz
//
//  Created by Brainstorm on 11/29/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

class customCellSwift: UITableViewCell
{

    //MARK:- Outlet
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLastMessage: UILabel!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var imgUserImage: cImageView!
    @IBOutlet weak var lblUserStatus: cLable!
    @IBOutlet weak var imgLocatiobIcon: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var btnCheckedCate: UIButton!
    
    //About US 
    @IBOutlet weak var lblAboutUsOptionName: UILabel!
    
    //New Post
    @IBOutlet weak var lblLocationName: UILabel!
    
    //Setting Seeker
    @IBOutlet weak var swSeekerSettings: cSwitch!
    @IBOutlet weak var lblSeekerSettingOptions: UILabel!
    @IBOutlet weak var lblActualAddress: UILabel!
    
    //Abort
    @IBOutlet weak var lblAbortReason: UILabel!
    @IBOutlet weak var btnReasonSelected: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
