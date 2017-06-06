//
//  matchingDetailPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/4/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class matchingDetailPoster: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var viewSeekerInfo: UIView!
    @IBOutlet weak var lblSeekerName: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblJobCompleted: UILabel!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var imgUserPhoto: cImageView!
    @IBOutlet weak var lblSeekerStatus: cLable!
    @IBOutlet weak var btnKm: UIButton!
    @IBOutlet weak var btnHasVehicle: UIButton!
    @IBOutlet weak var btnTotalExp: UIButton!
    @IBOutlet weak var scrCoreSkills: UIScrollView!
    @IBOutlet weak var scrCertifiactes: UIScrollView!
    @IBOutlet weak var lblRatingAndReview: UILabel!
    @IBOutlet weak var tblRating: UITableView!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btnSeekerAddress: UIButton!
    @IBOutlet weak var btnSave: cButton!
    @IBOutlet weak var btnInvite: cButton!
    @IBOutlet weak var btnPass: cButton!
    @IBOutlet weak var btnTotalAmount: UIButton!
    
    var objMatching: allJobStatusPoster!
    var arrOfCerti: NSMutableArray = NSMutableArray()
    var arrOfSkill: NSMutableArray = NSMutableArray()
    var arrofRating: NSMutableArray = NSMutableArray()
    var DictPostDetail: NSMutableDictionary = NSMutableDictionary()
    var dictPost: NSMutableDictionary = NSMutableDictionary()
    var strFrom: String = ""
    var yOffset: CGFloat = 0.0
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrMain.isHidden = true
        viewButtons.isHidden = true
        self.view.backgroundColor = API.appBackgroundColor()
        
        tblRating.register(UINib(nibName: "rateAndReviewCell", bundle: nil), forCellReuseIdentifier: "rateAndReviewCell")
        tblRating.delegate = self
        tblRating.dataSource = self
        
        if strFrom == "Invited"
        {
            viewButtons.isHidden = true
            scrMain.frame = CGRect.init(x: scrMain.frame.origin.x, y: scrMain.frame.origin.y, width: scrMain.frame.size.width, height: scrMain.frame.size.height + viewButtons.frame.size.height)
        }
        getMatchingDetail()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnSave(_ sender: Any)
    {
        saveProfile()
    }
    @IBAction func btnInvite(_ sender: Any)
    {
        inviteSeeker(status: true)
    }
    @IBAction func btnReject(_ sender: Any)
    {
        inviteSeeker(status: false)
    }
    @IBAction func btnSeekerAddress(_ sender: Any)
    {
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrofRating.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateAndReviewCell", for: indexPath as IndexPath) as! rateAndReviewCell
        let dd: NSDictionary = arrofRating.object(at: indexPath.row) as! NSDictionary
        cell.lblReView.text = dd.object(forKey: "Review") as? String
        cell.viewRating.value = dd.object(forKey: "Rate") as! CGFloat
        cell.imgUserPic.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "ProfilePic") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        cell.lblReView.frame = CGRect(x: cell.lblReView.frame.origin.x, y: cell.lblReView.frame.origin.y, width: cell.lblReView.frame.size.width, height: CGFloat(API.HieghtForText(text: cell.lblReView.text!, font: cell.lblReView.font, maxSize: CGSize(width: cell.lblReView.frame.size.width, height: 90000))))
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dd: NSDictionary = arrofRating.object(at: indexPath.row) as! NSDictionary
        let str: String = dd.object(forKey: "Review") as! String
        var h: CGFloat = 32
        h = h + CGFloat(API.HieghtForText(text:str , font: UIFont.init(name: font_openSans_regular, size: 14)!, maxSize: CGSize(width: (223 * UIScreen.main.bounds.size.width)/320, height: 90000)))
        h = h + 7
        if h < 60
        {
            h = 60
        }
        return h
    }
    
    //MARK:- TagList Method
    func manageTag(arrTag: NSMutableArray, scr:UIScrollView)
    {
        for case let vv as CustomViewWithoutButton in scr.subviews
        {
            vv.removeFromSuperview()
        }
        
        if arrTag.count == 0
        {
            return
        }
        for i in 0..<arrTag.count
        {
            let dd: NSDictionary = arrTag.object(at: i) as! NSDictionary
            let view1 : CustomViewWithoutButton = CustomViewWithoutButton.init(s: dd.object(forKey: "Name") as! String, viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
            print(view1.frame)
            // view1.viewBackColor = UIColor.lightGray
            // view1.frame = CGRect.init(x: 0, y: 20, width: view1.btnSecondOutlet.frame.origin.x + view1.btnSecondOutlet.frame.size.width + 3, height: view1.lblText.frame.size.height + 6)
            view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 6)
            view1.tag = 2000 + i
            view1.clipsToBounds = true
            //            view1.btnFirstOutlet.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            //            view1.btnSecondOutlet.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            
            view1.backgroundColor = API.lightBlueColor()
            view1.layer.borderColor = API.themeColorBlue().cgColor
            view1.layer.borderWidth = 1
            view1.clipsToBounds = true
            scr.addSubview(view1)
            self.view.layoutIfNeeded()
        }
        arrangeTags(scrToArrange: scr, arrTag: arrTag)
    }
    func arrangeTags(scrToArrange: UIScrollView,arrTag: NSMutableArray)
    {
        var prevViewWidth : CGFloat = 20
        var prevViewY : CGFloat = 35
        var lastViewFrame : CGFloat = 0
        
        for v in scrToArrange.subviews
        {
            if(v.tag >= 2000 && v.tag < 99999)
            {
                if(v is CustomViewWithoutButton)
                {
                    let cv : CustomViewWithoutButton = v as! CustomViewWithoutButton
                    
                    if(((prevViewWidth + cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9) <= 280))
                    {
                        cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9, height: cv.lblText.frame.size.height + 6)
                    }
                    else
                    {
                        prevViewWidth = 20
                        cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9, height: cv.lblText.frame.size.height + 6)
                    }
                    
                    if(self.view.viewWithTag(v.tag + 1) != nil)
                    {
                        let nextView : CustomViewWithoutButton = self.view.viewWithTag(v.tag + 1) as! CustomViewWithoutButton
                        
                        if(!((prevViewWidth + (cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9) + 9 + nextView.lblText.frame.origin.x + nextView.lblText.frame.size.width + 9) <= 280))
                        {
                            prevViewY = cv.frame.origin.y + cv.frame.size.height + 5
                        }
                    }
                    
                    lastViewFrame = cv.frame.size.height
                    //cv.layer.borderColor = UIColor.init(red: 20/255.0, green: 164/255.0, blue: 245/255.0, alpha: 1.0).cgColor
                    cv.layer.cornerRadius = 13//cv.frame.size.height / 2
                    //cv.layer.borderWidth = 0.5
                    cv.clipsToBounds = true
                    prevViewWidth = cv.frame.size.width + cv.frame.origin.x + 9
                }
            }
        }
        scrToArrange.frame = CGRect.init(x: scrToArrange.frame.origin.x, y: scrToArrange.frame.origin.y, width: scrToArrange.frame.size.width, height: prevViewY + lastViewFrame)
    }
    
    //MARK:- Arrange Views
    func arrangeView()
    {
        yOffset = viewSeekerInfo.frame.size.height + viewSeekerInfo.frame.origin.y + 8
        
        scrCoreSkills.frame = CGRect.init(x: scrCoreSkills.frame.origin.x, y: yOffset, width: scrCoreSkills.frame.size.width, height: scrCoreSkills.frame.size.height)
        yOffset = scrCoreSkills.frame.size.height + scrCoreSkills.frame.origin.y + 8
        
        scrCertifiactes.frame = CGRect.init(x: scrCertifiactes.frame.origin.x, y: yOffset, width: scrCertifiactes.frame.size.width, height: scrCertifiactes.frame.size.height)
        yOffset = scrCertifiactes.frame.size.height + scrCertifiactes.frame.origin.y + 8
        
        lblRatingAndReview.frame = CGRect.init(x: lblRatingAndReview.frame.origin.x, y: yOffset, width: lblRatingAndReview.frame.size.width, height: lblRatingAndReview.frame.size.height)
        yOffset = lblRatingAndReview.frame.size.height + lblRatingAndReview.frame.origin.y + 8
        
        var tblratingHieght: CGFloat = 0
        for item in arrofRating
        {
            let dd: NSDictionary = item as! NSDictionary
            let str: String = dd.object(forKey: "Review") as! String
            var h: CGFloat = 32
            h = h + CGFloat(API.HieghtForText(text:str , font: UIFont.init(name: font_openSans_regular, size: 14)!, maxSize: CGSize(width: (223 * UIScreen.main.bounds.size.width)/320, height: 90000)))
            h = h + 7
            if h < 60
            {
                h = 60
            }
            tblratingHieght = tblratingHieght + h
        }
        tblRating.frame = CGRect.init(x: tblRating.frame.origin.x, y: yOffset, width: tblRating.frame.size.width, height: tblratingHieght)
        yOffset = tblRating.frame.size.height + tblRating.frame.origin.y + 8
        
        scrMain.contentSizeToFit()
    }
    //MARK:- Set Detail
    func setDetail()
    {
        scrMain.isHidden = false
        if strFrom == "Matching"
        {
            viewButtons.isHidden = false
        }
        let acerti: NSArray = DictPostDetail.object(forKey: "Certificate") as! NSArray
        arrOfCerti = NSMutableArray.init(array: acerti)
        
        let aSkill: NSArray = DictPostDetail.object(forKey: "CoreSkill") as! NSArray
        arrOfSkill = NSMutableArray.init(array: aSkill)
        
        let aReview: NSArray = DictPostDetail.object(forKey: "Review") as! NSArray
        arrofRating = NSMutableArray.init(array: aReview)
        
        manageTag(arrTag: arrOfSkill, scr: scrCoreSkills)
        manageTag(arrTag: arrOfCerti, scr: scrCertifiactes)
        
        imgUserPhoto.sd_setImage(with: NSURL.init(string: (DictPostDetail.object(forKey: "ProfilePic") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(tapGestureRecognizer:)))
        imgUserPhoto.isUserInteractionEnabled = true
        imgUserPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        lblSeekerName.text = DictPostDetail.object(forKey: "Title") as? String
        lblJobTitle.text = DictPostDetail.object(forKey: "Name") as? String
        viewRating.value = DictPostDetail.object(forKey: "ProfileRating") as! CGFloat
        lblJobCompleted.text = String(format: "Job Completed %d", DictPostDetail.object(forKey: "TotalCompletedJob") as! Int)
        
        
        let strFromLat: String = DictPostDetail.object(forKey: "Latitude") as! String
        let strFromLong: String = DictPostDetail.object(forKey: "Longitude") as! String
        
        let strLatitude: String = DictPostDetail.object(forKey: "Latitude1") as! String
        let strLongitude: String = DictPostDetail.object(forKey: "Longitude1") as! String
        let strDistance: String = API.getDistance(strToLate: strLatitude, strToLong: strLongitude, strFromLat: strFromLat, strFromLong: strFromLong)
        
        btnKm.setTitle(String(format:"%@",strDistance), for: UIControlState.normal)
        btnKm.titleLabel?.adjustsFontSizeToFitWidth = true
        //btnKm.setTitle(DictPostDetail.object(forKey: "Distance") as? String, for: UIControlState.normal)
        btnTotalExp.setTitle(String(format:"%0.2f Yr",DictPostDetail.object(forKey: "TotalExperienced") as! CGFloat), for: UIControlState.normal)
        btnTotalAmount.setTitle(String(format:"%@",DictPostDetail.object(forKey: "HourlyRate") as! String), for: UIControlState.normal)
        if DictPostDetail.object(forKey: "TotalExperienced") as! CGFloat == 0
        {
            lblExp.isHidden = true
        }
        
        if DictPostDetail.object(forKey: "IsVehicle") as! Bool == true
        {
            btnHasVehicle.isSelected = false
        }
        else
        {
            btnHasVehicle.isSelected = true
        }
        if DictPostDetail.object(forKey: "IsAvailable") as! Bool == true
        {
            lblSeekerStatus.backgroundColor = API.onlineColor()
        }
        else
        {
            lblSeekerStatus.backgroundColor = API.offline()
        }
        btnSeekerAddress.setTitle(DictPostDetail.object(forKey: "LocationName") as? String, for: UIControlState.normal)
        arrangeView()
        tblRating.reloadData()
    }
    //MARK:- GO TO SEEKER PROFILE
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let obj: seekerProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerProfileClass") as! seekerProfileClass
        obj.userId = DictPostDetail.object(forKey: "UserID") as! String
        self.navigationController!.pushViewController(obj, animated: true)
    }
    //MARK:- Call API
    func getMatchingDetail()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dictPost.object(forKey: "UserID"), forKey: "UserID")
        parameter.setValue(dictPost.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(API.getUserId(), forKey: "LoginUserID")
        print(parameter)
        API.callApiPOST(strUrl: API_JobPostProfile,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let result: NSArray = response.object(forKey: "Data") as! NSArray
                if result.count != 0
                {
                    let dd: NSDictionary = result.object(at: 0) as! NSDictionary
                    self.DictPostDetail = NSMutableDictionary.init(dictionary: dd)
                    self.setDetail()
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func saveProfile()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dictPost.object(forKey: "UserID"), forKey: "SeekerID")
        parameter.setValue(dictPost.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(true, forKey: "Status")
        print(parameter)
        API.callApiPOST(strUrl: API_SaveProfile,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func inviteSeeker(status: Bool)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dictPost.object(forKey: "UserID"), forKey: "SeekerID")
        parameter.setValue(dictPost.object(forKey: "JobPostID"), forKey: "PostID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(status, forKey: "Status")
        print(parameter)
        API.callApiPOST(strUrl: API_InviteSeeker,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                 _ = self.navigationController?.popViewController(animated: true)
//                if self.objMatching.arrOfMatchingProfile.count != 0
//                {
//                    self.objMatching.arrOfMatchingProfile.removeObject(at: self.objMatching.selectedIndex)
//                    self.objMatching.lblMatchingCnt.text = String(format: "%d", self.objMatching.arrOfMatchingProfile.count)
//                    self.objMatching.tblMtching.reloadData()
//                }
//                
//                if self.objMatching.arrOfMatchingProfile.count == 0
//                {
//                    self.objMatching.contentMsg.isHidden = false
//                }
//                if status == true
//                {
//                    var cnt = Int(self.objMatching.lblInvitedCnt.text!)
//                    cnt = cnt! + 1
//                    self.objMatching.lblInvitedCnt.text = String(format: "%d", cnt!)
//                    self.objMatching.dropAllPins()
//                    _ = self.navigationController?.popViewController(animated: true)
//                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    
}
