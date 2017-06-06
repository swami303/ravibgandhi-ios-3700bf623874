//
//  seekerProfileClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/6/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit
import MessageUI

class seekerProfileClass: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var tblSeekerDetail: UITableView!
    @IBOutlet weak var sgmtSeekerProfile: UISegmentedControl!
    @IBOutlet weak var cvSeekerOverview: UICollectionView!
    @IBOutlet weak var lblSeekerOverviewIDVerificationTitle: UILabel!
    @IBOutlet weak var cvSeekerCertification: UICollectionView!
    @IBOutlet weak var viewReferenceContainer: UIView!
    
    
    var arrOfData : NSMutableArray = NSMutableArray()
    var arrOfWorkHistory : NSMutableArray = NSMutableArray()
    var arrOfOverviewIDVerification : NSMutableArray = NSMutableArray()
    var arrOfCertification : NSMutableArray = NSMutableArray()
    var dictData : NSMutableDictionary = NSMutableDictionary()
    var userId : String = ""
    var emailRef: String = ""
    let custObj: customClassViewController = customClassViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //userId = "9ec7304b-246d-4aea-9983-bfd743b6d6cf"
        //userId = "8bed5c60-d0fd-419c-a0b8-81c663ca2358"


        self.tblSeekerDetail.dataSource = self
        self.tblSeekerDetail.delegate = self
        
        view.backgroundColor = API.appBackgroundColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        
        cvSeekerOverview.isHidden = true
        cvSeekerCertification.isHidden = true
        tblSeekerDetail.isHidden = true
        lblSeekerOverviewIDVerificationTitle.isHidden = true
        
        self.cvSeekerOverview.delegate = self
        self.cvSeekerOverview.dataSource = self
        
        self.cvSeekerCertification.delegate = self
        self.cvSeekerCertification.dataSource = self

        tblSeekerDetail.layer.cornerRadius = 10.0
        tblSeekerDetail.clipsToBounds = true
        
        cvSeekerOverview.layer.cornerRadius = 10.0
        cvSeekerOverview.clipsToBounds = true
        
        cvSeekerCertification.layer.cornerRadius = 10.0
        cvSeekerCertification.clipsToBounds = true
        
        //tblSeekerDetail.alwaysBounceVertical = false
        //self.setUpSeekerStaticData()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        layout.itemSize = CGSize(width: (90*width)/320, height: (104*height)/568)
        layout.headerReferenceSize = CGSize.init(width: cvSeekerCertification.frame.size.width, height: 30)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 15, right: 4)
        cvSeekerCertification.collectionViewLayout = layout
        
        self.getProfileAPI()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func sgmtSeekerProfileChanged(_ sender: Any)
    {
        self.setUpSeekerStaticData()
    }
    //MARK:- Action zone
    @IBAction func btnMobile(_ sender: Any)
    {
        var arr: NSArray!
        let tag: Int = ((sender as! UIButton).superview)!.tag - 999
        for item in arrOfData
        {
            let dd: NSDictionary = item as! NSDictionary
            if((dd.object(forKey: "key") as! String) == "Reference")
            {
                arr = dd.object(forKey: "value") as! NSArray
            }
        }
        let dd: NSDictionary = arr.object(at: tag) as! NSDictionary
        print(dd)
        let number: String = dd.object(forKey: "mobileNo") as! String
        if let url = URL(string:"tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func btnEmail(_ sender: Any)
    {
        var arr: NSArray!
        let tag: Int = ((sender as! UIButton).superview)!.tag - 999
        for item in arrOfData
        {
            let dd: NSDictionary = item as! NSDictionary
            if((dd.object(forKey: "key") as! String) == "Reference")
            {
                arr = dd.object(forKey: "value") as! NSArray
            }
        }
        let dd: NSDictionary = arr.object(at: tag) as! NSDictionary
        print(dd)
        emailRef = dd.object(forKey: "email") as! String
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            //custObj.alertMessage("Your device can not send email.  Please check email configuration in your phone setting and try again")
        }
    }
    //MARK:- MAIL
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([emailRef])
        mailComposerVC.setSubject("")
        return mailComposerVC
    }
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        if (error == nil)
        {
            //custObj.alertMessage(error?.localizedDescription)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(sgmtSeekerProfile.selectedSegmentIndex == 2)
        {
            return arrOfWorkHistory.count
        }
        
        return arrOfData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(sgmtSeekerProfile.selectedSegmentIndex == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "seekerWorkHistoryCell", for: indexPath as IndexPath) as! seekerProfileCell
            
            /*EndDate = "10/10/2017";
            JobTitle = "sample string 1";
            KeyRole = "sample string 5";
            NameOfCompany = demo;
            StartDate = "10/10/2010";
            */
            
            cell.lblWHJobTitle.text = ((arrOfWorkHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "JobTitle") as! String)
            cell.lblWHCompany.text = ((arrOfWorkHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "NameOfCompany") as! String)
            cell.lblWHStartDate.text = ((arrOfWorkHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "StartDate") as! String)
            cell.lblWHEndDate.text = ((arrOfWorkHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "EndDate") as! String)
            cell.lblWHRole.text = ((arrOfWorkHistory.object(at: indexPath.row) as! NSDictionary).object(forKey: "KeyRole") as! String)
            
            return cell
        }
        else
        {
            if(((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "key") as! String) == "Reference")
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "seekerProfileCell", for: indexPath as IndexPath) as! seekerProfileCell
                
                cell.lblCellValue.isHidden = true
                for item in cell.contentView.subviews
                {
                    if(item.tag != 0)
                    {
                        item.removeFromSuperview()
                    }
                }
                
                cell.lblCellTitle.text = ((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "key") as! String)
                
                var newY : CGFloat = 0
                var i: Int = 999
                for item1 in ((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "value") as! NSArray)
                {
                    let archive = NSKeyedArchiver.archivedData(withRootObject: viewReferenceContainer)
                    let referenceViewCopy = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
                    referenceViewCopy.frame = CGRect.init(x: 130, y: newY, width: referenceViewCopy.frame.size.width, height: referenceViewCopy.frame.size.height)
                    referenceViewCopy.backgroundColor = UIColor.clear
                    referenceViewCopy.tag = i
                    i = i + 1
                    let dict : NSDictionary = item1 as! NSDictionary
                    
                    let lblName : UILabel = referenceViewCopy.viewWithTag(1001) as! UILabel
                    
                    if((dict.object(forKey: "name") as! String) == "")
                    {
                        lblName.text = String.init(format: "Name : %@", "---")
                    }
                    else
                    {
                        lblName.text = String.init(format: "Name : %@", (dict.object(forKey: "name") as! String))
                    }
                    
                    let btnMobile: UIButton = referenceViewCopy.viewWithTag(1005) as! UIButton
                    let btnEmail: UIButton = referenceViewCopy.viewWithTag(1006) as! UIButton
                    
                    btnMobile.setImage(UIImage.init(named: "mobile"), for: UIControlState.normal)
                    
                    btnEmail.setImage(UIImage.init(named: "email"), for: UIControlState.normal)
                    
                    let lblEmail : UILabel = referenceViewCopy.viewWithTag(1002) as! UILabel
                    
                    if((dict.object(forKey: "email") as! String) == "")
                    {
                        lblEmail.text = String.init(format: "Email : %@", "---")
                        btnEmail.isHidden = true
                    }
                    else
                    {
                        lblEmail.text = String.init(format: "Email : %@", (dict.object(forKey: "email") as! String))
                        btnEmail.isHidden = false
                        
                    }
                    lblEmail.isHidden = true
                    let lblMobileNo : UILabel = referenceViewCopy.viewWithTag(1003) as! UILabel
                    
                    if((dict.object(forKey: "mobileNo") as! String) == "")
                    {
                        lblMobileNo.text = String.init(format: "Mob : %@", "---")
                        btnMobile.isHidden = true
                    }
                    else
                    {
                        lblMobileNo.text = String.init(format: "Mob : %@", (dict.object(forKey: "mobileNo") as! String))
                        btnMobile.isHidden = false
                        
                    }
                    lblMobileNo.isHidden = true
                    
                    btnEmail.addTarget(self, action: #selector(self.btnEmail(_:)), for: UIControlEvents.touchUpInside)
                    btnMobile.addTarget(self, action: #selector(self.btnMobile(_:)), for: UIControlEvents.touchUpInside)
                    
                    let lblOrganization : UILabel = referenceViewCopy.viewWithTag(1004) as! UILabel
                    if((dict.object(forKey: "organization") as! String) == "")
                    {
                        lblOrganization.text = String.init(format: "Org : %@", "---")
                    }
                    else
                    {
                        lblOrganization.text = String.init(format: "Org : %@", (dict.object(forKey: "organization") as! String))
                    }
                    
                    
                    referenceViewCopy.bringSubview(toFront: lblName)
                    referenceViewCopy.bringSubview(toFront: lblEmail)
                    referenceViewCopy.bringSubview(toFront: lblMobileNo)
                    referenceViewCopy.bringSubview(toFront: lblOrganization)

                    cell.contentView.addSubview(referenceViewCopy)
                    
                    newY = newY + referenceViewCopy.frame.size.height
                    cell.contentView.bringSubview(toFront: referenceViewCopy)
                }
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "seekerProfileCell", for: indexPath as IndexPath) as! seekerProfileCell
                
                for item in cell.contentView.subviews
                {
                    if(item.tag != 0)
                    {
                        item.removeFromSuperview()
                    }
                }
                
                cell.lblCellValue.isHidden = false
                cell.lblCellTitle.text = ((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "key") as! String)
                cell.lblCellValue.text = ((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "value") as! String)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(sgmtSeekerProfile.selectedSegmentIndex == 2)
        {
            return 165
        }
        else
        {
            if(((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "key") as! String) == "Reference")
            {
                return CGFloat(((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "value") as! NSArray).count * 75)
            }
            else
            {
                let labelSize = rectForText(text: ((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "value") as! String), font: UIFont(name: font_openSans_regular, size: 14)!, maxSize: CGSize.init(width: tblSeekerDetail.frame.size.width - 140, height: 999))
                
                if(labelSize.height < 24)
                {
                    return 50
                }
                
                return labelSize.height + 27
            }
        }
    }
    //MARK:- Set data
    func setUpSeekerStaticData()
    {
        if(sgmtSeekerProfile.selectedSegmentIndex == 0)
        {
            tblSeekerDetail.backgroundColor = UIColor.white
            tblSeekerDetail.isHidden = false
            cvSeekerOverview.isHidden = false
            lblSeekerOverviewIDVerificationTitle.isHidden = false
            cvSeekerCertification.isHidden = true
            
            arrOfData = NSMutableArray()
            
            arrOfCertification = NSMutableArray.init(array: dictData.object(forKey: "SeekerCertificate") as! NSArray)
            
            
            arrOfOverviewIDVerification = NSMutableArray()
            for item in dictData.object(forKey: "SeekerIDProof") as! NSArray
            {
                arrOfOverviewIDVerification.add(item as! NSDictionary)
            }

            
            cvSeekerOverview.reloadData()
            
            var dict : NSMutableDictionary = NSMutableDictionary()
            dict.setObject("Mobile Number", forKey: "key" as NSCopying)
            dict.setObject("Verified", forKey: "value" as NSCopying)
            arrOfData.add(dict)
            
            self.navigationItem.title = String.init(format: "%@ %@", dictData.object(forKey: "FirstName") as! String, dictData.object(forKey: "LastName") as! String)
            
            dict = NSMutableDictionary()
            dict.setObject("ABN", forKey: "key" as NSCopying)
            //dict.setObject("Not Provided", forKey: "value" as NSCopying)
            
             if(dictData.object(forKey: "ABN") as! String == "")
             {
                dict.setObject("Not Provided", forKey: "value" as NSCopying)
             }
             else
             {
                dict.setObject(dictData.object(forKey: "ABN") as! String, forKey: "value" as NSCopying)
             }
            arrOfData.add(dict)
            
            
            dict = NSMutableDictionary()
            dict.setObject("Working Rights", forKey: "key" as NSCopying)
            
            if(dictData.object(forKey: "WorkingRightName") as! String == "")
            {
                dict.setObject("Not Available", forKey: "value" as NSCopying)
            }
            else
            {
                dict.setObject(dictData.object(forKey: "WorkingRightName") as! String, forKey: "value" as NSCopying)
            }
            arrOfData.add(dict)
            
            let arrOfReference : NSMutableArray = NSMutableArray()
            
            for item in (dictData.object(forKey: "SeekerRef") as! NSArray)
            {
                let dictOfData : NSDictionary = item as! NSDictionary
                dict = NSMutableDictionary()
                dict.setObject(dictOfData.object(forKey: "Name") as! String, forKey: "name" as NSCopying)
                dict.setObject(dictOfData.object(forKey: "NameOfOrg") as! String, forKey: "organization" as NSCopying)
                dict.setObject(dictOfData.object(forKey: "Email") as! String, forKey: "email" as NSCopying)
                dict.setObject(dictOfData.object(forKey: "ContactNo") as! String, forKey: "mobileNo" as NSCopying)
                arrOfReference.add(dict)
            }
            
            dict = NSMutableDictionary()
            dict.setObject("Reference", forKey: "key" as NSCopying)
            dict.setObject(arrOfReference, forKey: "value" as NSCopying)
            arrOfData.add(dict)
            
            dict = NSMutableDictionary()
            dict.setObject("About", forKey: "key" as NSCopying)
            
            if(dictData.object(forKey: "AboutYou") as! String == "")
            {
                dict.setObject("Not Available", forKey: "value" as NSCopying)
            }
            else
            {
                dict.setObject(dictData.object(forKey: "AboutYou") as! String, forKey: "value" as NSCopying)
            }
            
            arrOfData.add(dict)
            print(arrOfData)
            
            tblSeekerDetail.reloadData()
            
            tblSeekerDetail.frame = CGRect.init(x: tblSeekerDetail.frame.origin.x, y: cvSeekerOverview.frame.size.height + cvSeekerOverview.frame.origin.y + 8, width: tblSeekerDetail.frame.size.width, height: (self.view.frame.size.height - (cvSeekerOverview.frame.origin.y + cvSeekerOverview.frame.size.height + 16)))

            arrOfWorkHistory = NSMutableArray()
            for item in (dictData.object(forKey: "SeekerWorkHistory") as! NSArray)
            {
                let dictOfData : NSDictionary = item as! NSDictionary
                dict = NSMutableDictionary()
                dict.setObject(dictOfData.object(forKey: "JobTitle") as! String, forKey: "JobTitle" as NSCopying)
                dict.setObject(dictOfData.object(forKey: "NameOfCompany") as! String, forKey: "NameOfCompany" as NSCopying)
                dict.setObject(dictOfData.object(forKey: "StartDate") as! String, forKey: "StartDate" as NSCopying)
                dict.setObject(dictOfData.object(forKey: "EndDate") as! String, forKey: "EndDate" as NSCopying)
                dict.setObject(dictOfData.object(forKey: "KeyRole") as! String, forKey: "KeyRole" as NSCopying)

                arrOfWorkHistory.add(dict)
            }

            
        }
        else if(sgmtSeekerProfile.selectedSegmentIndex == 1)
        {
            cvSeekerCertification.isHidden = false
            tblSeekerDetail.isHidden = true
            cvSeekerOverview.isHidden = true
            lblSeekerOverviewIDVerificationTitle.isHidden = true
            cvSeekerCertification.reloadData()
        }
        else
        {
            tblSeekerDetail.backgroundColor = UIColor.clear
            cvSeekerCertification.isHidden = true
            cvSeekerOverview.isHidden = true
            lblSeekerOverviewIDVerificationTitle.isHidden = true
            tblSeekerDetail.isHidden = false
            tblSeekerDetail.frame = CGRect.init(x: tblSeekerDetail.frame.origin.x, y: lblSeekerOverviewIDVerificationTitle.frame.origin.y, width: tblSeekerDetail.frame.size.width, height: (self.view.frame.size.height - (lblSeekerOverviewIDVerificationTitle.frame.origin.y + lblSeekerOverviewIDVerificationTitle.frame.size.height - 16)))
            
            tblSeekerDetail.reloadData()
        }
        
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize
    {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize.init(width: rect.size.width, height: rect.size.height)
        return size
    }
    
    
    //MARK:- collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if(collectionView == cvSeekerCertification)
        {
            return arrOfCertification.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collectionView == cvSeekerCertification)
        {
            return ((arrOfCertification.object(at: section) as! NSDictionary).object(forKey: "CerficateFile") as! NSArray).count
        }
        return arrOfOverviewIDVerification.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if(collectionView == cvSeekerOverview)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "certificateCell", for: indexPath as IndexPath) as! certificateCell
            cell.lblCertificateName.text = ((arrOfOverviewIDVerification.object(at: indexPath.row) as! NSDictionary).object(forKey: "ProofName") as! String)
            cell.imgCertificate.sd_setImage(with: URL.init(string: ((arrOfOverviewIDVerification.object(at: indexPath.row) as! NSDictionary).object(forKey: "Path") as! String)), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload)
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "certificationCell", for: indexPath as IndexPath) as! certificateCell
            cell.lblCertificateName.text = ((((arrOfCertification.object(at: indexPath.section) as! NSDictionary).object(forKey: "CerficateFile") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "CertificateName") as! String)
            cell.imgCertificate.sd_setImage(with: URL.init(string: ((((arrOfCertification.object(at: indexPath.section) as! NSDictionary).object(forKey: "CerficateFile") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "CertificateImage") as! String)), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(collectionView == cvSeekerOverview)
        {
            if ((arrOfOverviewIDVerification.object(at: indexPath.row) as! NSDictionary).object(forKey: "Path") as! String) != ""
            {
                let obj: zoomImageViewClass = self.storyboard?.instantiateViewController(withIdentifier: "zoomImageViewClass") as! zoomImageViewClass
                obj.strImageUrl = ((arrOfOverviewIDVerification.object(at: indexPath.row) as! NSDictionary).object(forKey: "Path") as! String)
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
        else
        {
            if ((((arrOfCertification.object(at: indexPath.section) as! NSDictionary).object(forKey: "CerficateFile") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "CertificateImage") as! String) != ""
            {
                let obj: zoomImageViewClass = self.storyboard?.instantiateViewController(withIdentifier: "zoomImageViewClass") as! zoomImageViewClass
                obj.strImageUrl = ((((arrOfCertification.object(at: indexPath.section) as! NSDictionary).object(forKey: "CerficateFile") as! NSArray).object(at: indexPath.row) as! NSDictionary).object(forKey: "CertificateImage") as! String)
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if(collectionView == cvSeekerCertification)
        {
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
                
                headerView.backgroundColor = UIColor.clear
                
                for item in headerView.subviews
                {
                    item.removeFromSuperview()
                }
                let lblCatName : UILabel = UILabel.init(frame: CGRect.init(x: 4, y: 4, width: headerView.frame.size.width - 8, height: headerView.frame.size.height - 8))
                lblCatName.backgroundColor = UIColor.clear
                lblCatName.font = UIFont.init(name: "OpenSans", size: 15)
                lblCatName.textAlignment = .center
                lblCatName.layer.cornerRadius = 8.0
                lblCatName.layer.borderColor = API.themeColorBlue().cgColor
                lblCatName.layer.borderWidth = 1.0
                lblCatName.clipsToBounds = true
                lblCatName.text = ((arrOfCertification.object(at: indexPath.section) as! NSDictionary).object(forKey: "CategoryName") as! String)
                
                headerView.addSubview(lblCatName)
                
                
                return headerView
                
    //        case UICollectionElementKindSectionFooter:
    //            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath) as! UICollectionReusableView
    //            
    //            footerView.backgroundColor = UIColor.greenColor();
    //            return footerView
                
            default:
                
                assert(false, "Unexpected element kind")
            }
        }
        
        return UIView.init(frame: CGRect.zero) as! UICollectionReusableView
    }
    
    //MARK:- Call API
    func getProfileAPI()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(userId, forKey: "UserID")
        
        print(parameter)
        API.callApiPOST(strUrl: API_GET_SEEKER_PROFILE,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let firstObj: NSArray = response.object(forKey: "Data") as! NSArray
                let result: NSDictionary = firstObj.object(at: 0) as! NSDictionary
                //let dictData: NSMutableDictionary = NSMutableDictionary.init(dictionary: result)
                self.dictData = NSMutableDictionary()
                self.dictData = self.custObj.dictionaryByReplacingNulls(withStrings:result.mutableCopy() as! NSMutableDictionary)
                self.setUpSeekerStaticData()
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
