//
//  menuClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/23/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import MessageUI
class menuClass: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,MFMailComposeViewControllerDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var cvMenu: UICollectionView!
    @IBOutlet weak var viewShare: cView!
    
    var arrOfMenu: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        let logo = UIImage(named: "dashboardLogo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        viewShare.layer.cornerRadius = (20*UIScreen.main.bounds.size.width)/320
        viewShare.clipsToBounds = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        layout.itemSize = CGSize(width: (136*width)/320, height: (110*height)/568)
        cvMenu.collectionViewLayout = layout
        
        var dictMenu: NSMutableDictionary = NSMutableDictionary()
        dictMenu.setValue("MY PROFILE", forKey: "name")
        dictMenu.setValue("menuMyProfile", forKey: "image")
        arrOfMenu.add(dictMenu)
        
        dictMenu = NSMutableDictionary()
        dictMenu.setValue("PAYMENT", forKey: "name")
        dictMenu.setValue("menuPayment", forKey: "image")
        arrOfMenu.add(dictMenu)
        
        dictMenu = NSMutableDictionary()
        dictMenu.setValue("MESSAGE BOX", forKey: "name")
        dictMenu.setValue("menuMessageBox", forKey: "image")
        arrOfMenu.add(dictMenu)
        
        dictMenu = NSMutableDictionary()
        dictMenu.setValue("SETTINGS", forKey: "name")
        dictMenu.setValue("menuSetting", forKey: "image")
        arrOfMenu.add(dictMenu)
        
        dictMenu = NSMutableDictionary()
        dictMenu.setValue("HELP & SUPPORT", forKey: "name")
        dictMenu.setValue("menuHelpSupport", forKey: "image")
        arrOfMenu.add(dictMenu)
        
        dictMenu = NSMutableDictionary()
        dictMenu.setValue("ABOUT US", forKey: "name")
        dictMenu.setValue("menuAboutUs", forKey: "image")
        arrOfMenu.add(dictMenu)
        
        cvMenu.delegate = self
        cvMenu.dataSource = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnrateUs(_ sender: Any)
    {
        UIApplication.shared.openURL(URL.init(string: ITUNE_LINK)!)
    }
    @IBAction func btnShare(_ sender: Any)
    {
        let textToShare =  [SHARE_TEXT]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceRect = self.view.bounds
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func btnContactUs(_ sender: Any)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            custObj.alertMessage("Your device can not send email.  Please check email configuration in your phone setting and try again")
        }
    }
    //MARK:- MAIL
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([BEEZ_EMAIL])
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
    //MARK:- collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrOfMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! certificateCell
        let dd: NSDictionary = arrOfMenu.object(at: indexPath.row) as! NSDictionary
        cell.lblOptionName.text = dd.object(forKey: "name") as? String
        cell.imgMenuOption.image = UIImage.init(named: dd.object(forKey: "image") as! String)
        cell.viewMenuOption.layer.cornerRadius = (50*UIScreen.main.bounds.size.width)/320
        cell.viewMenuOption.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dd: NSDictionary = arrOfMenu.object(at: indexPath.row) as! NSDictionary
        let str: String = dd.object(forKey: "name") as! String
        
        if str == "MY PROFILE"
        {
            if API.getRole() == "2"
            {
                let obj: myProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "myProfileClass") as! myProfileClass
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else
            {
                let obj: myProfileSeeker = self.storyboard?.instantiateViewController(withIdentifier: "myProfileSeeker") as! myProfileSeeker
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
        else if str == "PAYMENT"
        {
            if API.getRole() == "2"
            {
                let obj: posterPaymentCardListClass = self.storyboard?.instantiateViewController(withIdentifier: "posterPaymentCardListClass") as! posterPaymentCardListClass
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else
            {
                let obj: seekerPaymentDetailClass = self.storyboard?.instantiateViewController(withIdentifier: "seekerPaymentDetailClass") as! seekerPaymentDetailClass
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
        else if str == "MESSAGE BOX"
        {
            let obj: notificationClass = self.storyboard?.instantiateViewController(withIdentifier: "notificationClass") as! notificationClass
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if str == "SETTINGS"
        {
            if API.getRole() == "2"
            {
                let obj: settingsPoster = self.storyboard?.instantiateViewController(withIdentifier: "settingsPoster") as! settingsPoster
                self.navigationController!.pushViewController(obj, animated: true)
            }
            else
            {
                let obj: settingsSeeker = self.storyboard?.instantiateViewController(withIdentifier: "settingsSeeker") as! settingsSeeker
                self.navigationController!.pushViewController(obj, animated: true)
            }
        }
        else if str == "HELP & SUPPORT"
        {
            let obj: webViewClass = self.storyboard?.instantiateViewController(withIdentifier: "webViewClass") as! webViewClass
            obj.strNavTitle = str
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else
        {
            let obj: aboutUsClass = self.storyboard?.instantiateViewController(withIdentifier: "aboutUsClass") as! aboutUsClass
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
}
