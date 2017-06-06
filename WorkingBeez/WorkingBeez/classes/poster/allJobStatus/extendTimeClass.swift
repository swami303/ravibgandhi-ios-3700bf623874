//
//  extendTimeClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class extendTimeClass: UIViewController
{

    //MARK:- Outlet
    @IBOutlet weak var txtTime: paddingTextField!
    @IBOutlet weak var txtHour: paddingTextField!
    
    var dictFromRunning: NSMutableDictionary = NSMutableDictionary()
    var totalHour: CGFloat = 0.0
    var objRunning: allJobStatusPoster!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //totalHour = dictFromRunning.object(forKey: "NoOfHoursExtended") as! CGFloat
        setHourText()
        txtTime.text = String(format: "%@ - %@", dictFromRunning.object(forKey: "FromTime") as! String,dictFromRunning.object(forKey: "ToTime") as! String)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Action Zone
    
    @IBAction func btnDone(_ sender: Any)
    {
        if totalHour == 0
        {
            custObj.alertMessage("Please extend time")
            return
        }
        extend()
    }
    @IBAction func btnCancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnIncreaseHr(_ sender: Any)
    {
        totalHour = totalHour + 0.25
        setHourText()
    }
    @IBAction func btnDecreaseHr(_ sender: Any)
    {
        if totalHour == 0.0
        {
            return
        }
        totalHour = totalHour - 0.25
        setHourText()
    }
    
    func setHourText()
    {
        var str: String = String(format: "%0.2f", totalHour)
        str = str.replacingOccurrences(of: ".25", with: ":15")
        str = str.replacingOccurrences(of: ".50", with: ":30")
        str = str.replacingOccurrences(of: ".75", with: ":45")
        str = str.replacingOccurrences(of: ".00", with: ":00")
        
        print(str)
        txtHour.text = String(format: "%@ hrs", str)
    }
    //MARK:- CALL API
    func extend()
    {
        let dd: NSMutableDictionary = NSMutableDictionary()
        custObj.showSVHud("Loading")
        dd.setValue(API.getToken(), forKey: "Token")
        dd.setValue(API.getDeviceToken(), forKey: "DeviceID")
        dd.setValue(API.getUserId(), forKey: "PosterID")
        dd.setValue(dictFromRunning.object(forKey: "AcceptedID"), forKey: "JobAcceptedID")
        //dd.setValue(dictFromRunning.object(forKey: "UserID"), forKey: "SeekerID")
        dd.setValue(dictFromRunning.object(forKey: "RosterDateID"), forKey: "RosterDateID")
        dd.setValue(dictFromRunning.object(forKey: "ToTime"), forKey: "ExtendedFromTime")
        
        var str: String = String(format: "%0.2f", totalHour)
        str = str.replacingOccurrences(of: ".25", with: ".15")
        str = str.replacingOccurrences(of: ".50", with: ".30")
        str = str.replacingOccurrences(of: ".75", with: ".45")
        
        
        if let n = NumberFormatter().number(from: str) {
            totalHour = CGFloat(n)
        }
        
        dd.setValue(totalHour, forKey: "NoOfHoursExtended")
        print(dd)
        API.callApiPOST(strUrl: API_SetRosterExtendsTime,parameter: dd, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.objRunning.getRunning(show: true)
                self.dismiss(animated: true, completion: nil)
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
