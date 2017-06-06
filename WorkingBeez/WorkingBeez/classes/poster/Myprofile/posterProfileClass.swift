//
//  posterProfileClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/6/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

class posterProfileClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblPosterProfile: UITableView!
    @IBOutlet weak var btnPosterType: UIButton!
    var userId : String = ""
    
    var arrOfData : NSMutableArray = NSMutableArray()
    
    let custObj: customClassViewController = customClassViewController()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //userId = "0c564bb0-45f9-4b08-a4a2-d507f63057f7"
        
        self.tblPosterProfile.dataSource = self
        self.tblPosterProfile.delegate = self

        view.backgroundColor = API.appBackgroundColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        
        btnPosterType.isHidden = true
        self.btnPosterType.isSelected = false
        btnPosterType.isUserInteractionEnabled = false
        
        tblPosterProfile.layer.cornerRadius = 10.0
        tblPosterProfile.clipsToBounds = true
        tblPosterProfile.alwaysBounceVertical = false
        //self.setUpPosterStaticData()
        btnPosterType.tintColor = API.themeColorPink()
        self.getProfileAPI()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "posterProfileCell", for: indexPath as IndexPath) as! posterProfileCell
        
        cell.lblCellTitle.text = ((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "key") as! String)
        cell.lblCellValue.text = ((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "value") as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let labelSize = rectForText(text: ((arrOfData.object(at: indexPath.row) as! NSDictionary).object(forKey: "value") as! String), font: UIFont(name: font_openSans_regular, size: 14)!, maxSize: CGSize.init(width: tblPosterProfile.frame.size.width - 140, height: 999))
        
        print(labelSize)
        
        if(labelSize.height < 24)
        {
            return 50
        }
        
        return labelSize.height + 27
    }

    func setUpPosterStaticData(dict1 : NSMutableDictionary)
    {
        arrOfData = NSMutableArray()
        
        var dict : NSMutableDictionary = NSMutableDictionary()
        dict.setObject("Contact Person", forKey: "key" as NSCopying)
        dict.setObject(String.init(format: "%@ %@", dict1.object(forKey: "FirstName") as! String, dict1.object(forKey: "LastName") as! String), forKey: "value" as NSCopying)
        arrOfData.add(dict)
        
        dict = NSMutableDictionary()
        dict.setObject("ABN", forKey: "key" as NSCopying)
        if(dict1.object(forKey: "ABN") as! String == "")
        {
            dict.setObject("Not Provided", forKey: "value" as NSCopying)
        }
        else
        {
            dict.setObject(dict1.object(forKey: "ABN") as! String, forKey: "value" as NSCopying)
        }
        arrOfData.add(dict)
        
        dict = NSMutableDictionary()
        dict.setObject("Website URL", forKey: "key" as NSCopying)
        if(dict1.object(forKey: "WebsiteURL") as! String == "")
        {
            dict.setObject("Not Provided", forKey: "value" as NSCopying)
        }
        else
        {
            dict.setObject(dict1.object(forKey: "WebsiteURL") as! String, forKey: "value" as NSCopying)
        }
        arrOfData.add(dict)
        
        dict = NSMutableDictionary()
        dict.setObject("About", forKey: "key" as NSCopying)
        if(dict1.object(forKey: "AboutYourBusiness") as! String == "")
        {
            dict.setObject("Not Available", forKey: "value" as NSCopying)
        }
        else
        {
            dict.setObject(dict1.object(forKey: "AboutYourBusiness") as! String, forKey: "value" as NSCopying)
        }

        arrOfData.add(dict)
        
        if(dict1.object(forKey: "NameOfBusiness") as! String == "")
        {
            btnPosterType.setTitle("Individual", for: UIControlState.normal)
        }
        else
        {
            btnPosterType.setTitle("Bussiness", for: UIControlState.normal)
        }
        btnPosterType.isHidden = false
        tblPosterProfile.reloadData()
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize
    {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize.init(width: rect.size.width, height: rect.size.height)
        return size
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
        API.callApiPOST(strUrl: API_GET_POSTER_PROFILE,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let firstObj: NSArray = response.object(forKey: "Data") as! NSArray
                let result: NSDictionary = firstObj.object(at: 0) as! NSDictionary
                //let dictData: NSMutableDictionary = NSMutableDictionary.init(dictionary: result)
                let dictData: NSMutableDictionary = self.custObj.dictionaryByReplacingNulls(withStrings:result.mutableCopy() as! NSMutableDictionary)
                self.setUpPosterStaticData(dict1: dictData)
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
