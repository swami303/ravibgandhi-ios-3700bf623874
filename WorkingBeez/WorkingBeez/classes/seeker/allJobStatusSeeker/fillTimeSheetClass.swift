//
//  fillTimeSheetClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/7/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class fillTimeSheetClass: UIViewController
{
    
    //MARK:- Outlet
    @IBOutlet weak var txtTime: paddingTextField!
    @IBOutlet weak var txtHour: paddingTextField!
    @IBOutlet weak var lblTimeslot: UILabel!
    @IBOutlet weak var viewExtendedSlot: UIView!
    @IBOutlet weak var lblExtendedTimeslot: UILabel!
    @IBOutlet weak var btnEditExtendedTime: UIButton!
    @IBOutlet weak var btnTimeslotEdit: UIButton!
    @IBOutlet weak var viewCharge: cView!
    @IBOutlet weak var lblTotalhrs: UILabel!
    @IBOutlet weak var lblTotalCharge: UILabel!
    @IBOutlet weak var viewExtended: UIView!
    @IBOutlet weak var lblTotalHrsStatic: UILabel!
    @IBOutlet weak var lblEarningStatic: UILabel!
    
    var dictFromPT: NSMutableDictionary = NSMutableDictionary()
    //var totalHour: CGFloat = 0.0
    var JobTimePeriod: CGFloat = 0.0
    var totalExtendedHour: CGFloat = 0.0
    var totalEarning: CGFloat = 0.0
    var hourlyRate: CGFloat = 0.0
    var objPTSeeker: pendingTimesheetClass!
    var fromWhere: String = ""
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if dictFromPT.object(forKey: "ExFromTime") as! String == ""
        {
            btnTimeslotEdit.isHidden = false
            viewExtendedSlot.isHidden = true
        }
        else
        {
            btnTimeslotEdit.isHidden = true
            viewExtendedSlot.isHidden = false
            lblExtendedTimeslot.text = String(format: "%@ - %@", dictFromPT.object(forKey: "ExFromTime") as! String,dictFromPT.object(forKey: "ExToTime") as! String )
        }
        viewExtended.isHidden = true
        lblTimeslot.text = String(format: "%@ - %@", dictFromPT.object(forKey: "FromTime") as! String,dictFromPT.object(forKey: "ToTime") as! String )
        totalExtendedHour = dictFromPT.object(forKey: "NoOfHoursExtended") as! CGFloat
        
        
        var totalTimeInmin: CGFloat = 0
        var totalTimeInHoure: CGFloat = 0
        var integer = 0.0
        totalTimeInmin = CGFloat(modf(Double(totalExtendedHour), &integer))
        totalTimeInHoure = totalExtendedHour - totalTimeInmin
        totalTimeInmin = totalTimeInmin * 100
        totalExtendedHour = totalTimeInmin + (totalTimeInHoure * 60)
        
        
        let strJobTimePeriod: String = dictFromPT.object(forKey: "JobTimePeriod") as! String
        if let n = NumberFormatter().number(from: strJobTimePeriod) {
            JobTimePeriod = CGFloat(n)
        }
        totalTimeInmin = CGFloat(modf(Double(JobTimePeriod), &integer))
        totalTimeInHoure = JobTimePeriod - totalTimeInmin
        totalTimeInmin = totalTimeInmin * 100
        JobTimePeriod = totalTimeInmin + (totalTimeInHoure * 60)
        
        
        let strTE: String = dictFromPT.object(forKey: "TotalAmount") as! String
        let strHR: String = dictFromPT.object(forKey: "HourlyRate") as! String
        if let n = NumberFormatter().number(from: strTE) {
            totalEarning = CGFloat(n)
        }
        if let n = NumberFormatter().number(from: strHR) {
             hourlyRate = CGFloat(n)
        }
        
//        var str: String = String(format: "%0.2f", totalExtendedHour)
//        str = str.replacingOccurrences(of: ".15", with: ".25")
//        str = str.replacingOccurrences(of: ".30", with: ".50")
//        str = str.replacingOccurrences(of: ".45", with: ".75")
        
        
//        if let n = NumberFormatter().number(from: str) {
//            totalExtendedHour = CGFloat(n)
//        }
//        
//        let strTE: String = dictFromPT.object(forKey: "TotalAmount") as! String
//        let strHR: String = dictFromPT.object(forKey: "HourlyRate") as! String
//        if let n = NumberFormatter().number(from: strTE) {
//            totalEarning = CGFloat(n)
//        }
//        if let n = NumberFormatter().number(from: strHR) {
//             hourlyRate = CGFloat(n)
//        }
//        
//        let strJobTimePeriod: String = dictFromPT.object(forKey: "JobTimePeriod") as! String
//        if let n = NumberFormatter().number(from: strJobTimePeriod) {
//            JobTimePeriod = CGFloat(n)
//        }
//        
//        var str1: String = String(format: "%0.2f", JobTimePeriod)
//        str1 = str1.replacingOccurrences(of: ".15", with: ".25")
//        str1 = str1.replacingOccurrences(of: ".30", with: ".50")
//        str1 = str1.replacingOccurrences(of: ".45", with: ".75")
//        
//        
//        if let n = NumberFormatter().number(from: str1) {
//            JobTimePeriod = CGFloat(n)
//        }
        setHourText()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Action Zone
    func dismiss()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDone(_ sender: Any)
    {
        extend()
    }
    @IBAction func btnCancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnIncreaseHr(_ sender: Any)
    {
        totalExtendedHour = totalExtendedHour + 15//+ 0.25
        setHourText()
    }
    @IBAction func btnDecreaseHr(_ sender: Any)
    {
        if totalExtendedHour == 0.0
        {
            return
        }
        totalExtendedHour = totalExtendedHour - 15//- 0.25
        if totalExtendedHour <= 0.0
        {
            totalExtendedHour = 0.0
        }
        setHourText()
    }
    @IBAction func btnTimeSlotEdit(_ sender: Any)
    {
        viewExtended.isHidden = false
    }
    @IBAction func btnEditExtendedTimeslot(_ sender: Any)
    {
        viewExtended.isHidden = false
    }
    @IBAction func btnHideExtendedView(_ sender: Any)
    {
        viewExtended.isHidden = true
//        let strJobTimePeriod: String = dictFromPT.object(forKey: "JobTimePeriod") as! String
//        if let n = NumberFormatter().number(from: strJobTimePeriod) {
//            JobTimePeriod = CGFloat(n)
//        }
//        totalExtendedHour = dictFromPT.object(forKey: "NoOfHoursExtended") as! CGFloat
        
        totalExtendedHour = dictFromPT.object(forKey: "NoOfHoursExtended") as! CGFloat
        
        
        var totalTimeInmin: CGFloat = 0
        var totalTimeInHoure: CGFloat = 0
        
        var integer = 0.0
        totalTimeInmin = CGFloat(modf(Double(totalExtendedHour), &integer))
        totalTimeInHoure = totalExtendedHour - totalTimeInmin
        totalTimeInmin = totalTimeInmin * 100
        totalExtendedHour = totalTimeInmin + (totalTimeInHoure * 60)
        
        
        let strJobTimePeriod: String = dictFromPT.object(forKey: "JobTimePeriod") as! String
        if let n = NumberFormatter().number(from: strJobTimePeriod) {
            JobTimePeriod = CGFloat(n)
        }
        
        totalTimeInmin = CGFloat(modf(Double(JobTimePeriod), &integer))
        totalTimeInHoure = JobTimePeriod - totalTimeInmin
        totalTimeInmin = totalTimeInmin * 100
        JobTimePeriod = totalTimeInmin + (totalTimeInHoure * 60)
        
        setHourText()
    }
    
    func setHourText()
    {
        let min: Int = dictFromPT.object(forKey: "BreakMin") as! Int
        
        var tMin = totalExtendedHour.truncatingRemainder(dividingBy: 60.0)
        tMin = tMin / 100
        var tHour: Int = Int(totalExtendedHour / 60)
        
        if tMin >= 0.59
        {
            tMin = 0
            tHour = tHour + 1
        }
        var str: String = String(format: "%0.2f", CGFloat(tHour) + tMin)
        
        str = str.replacingOccurrences(of: ".", with: ":")
        txtHour.text = String(format: "%@ hrs", str)
        
        
        if dictFromPT.object(forKey: "IsBreak") as! Bool == true
        {
            if dictFromPT.object(forKey: "IsBreakPaid") as! Bool == false
            {
                tMin = (JobTimePeriod + totalExtendedHour - CGFloat(min)).truncatingRemainder(dividingBy: 60.0)
                tMin = tMin / 100
                tHour = Int((JobTimePeriod + totalExtendedHour - CGFloat(min)) / 60)
            }
            else
            {
                tMin = (JobTimePeriod + totalExtendedHour).truncatingRemainder(dividingBy: 60.0)
                tMin = tMin / 100
                tHour = Int((JobTimePeriod + totalExtendedHour) / 60)
            }
        }
        else
        {
            tMin = (JobTimePeriod + totalExtendedHour).truncatingRemainder(dividingBy: 60.0)
            tMin = tMin / 100
            tHour = Int((JobTimePeriod + totalExtendedHour) / 60)
        }
        str = String(format: "%0.2f", CGFloat(tHour) + tMin)
        str = str.replacingOccurrences(of: ".", with: ":")
        lblTotalhrs.text = String(format: "%@ hrs", str)
        
        var TotalAmt: CGFloat = 0
        var totalAmtInmin: CGFloat = 0
        totalAmtInmin = hourlyRate / 60
        
        if dictFromPT.object(forKey: "IsBreak") as! Bool == false
        {
            TotalAmt = totalAmtInmin * (JobTimePeriod + totalExtendedHour)
        }
        else
        {
            if dictFromPT.object(forKey: "IsBreakPaid") as! Bool == false
            {
                if totalExtendedHour == 0
                {
                    TotalAmt = totalAmtInmin * (JobTimePeriod - CGFloat(min))
                }
                else
                {
                    TotalAmt = totalAmtInmin * (JobTimePeriod + (totalExtendedHour - CGFloat(min)))
                }
            }
            else
            {
                TotalAmt = totalAmtInmin * (JobTimePeriod + totalExtendedHour)
            }
        }
        lblTotalCharge.text = String(format: "$ %0.2f", TotalAmt)
    }
    
    //MARK:- CALL API
    func extend()
    {
        let dd: NSMutableDictionary = NSMutableDictionary()
        custObj.showSVHud("Loading")
        dd.setValue(API.getToken(), forKey: "Token")
        dd.setValue(API.getDeviceToken(), forKey: "DeviceID")
        dd.setValue(API.getUserId(), forKey: "SeekerID")
        dd.setValue(dictFromPT.object(forKey: "AcceptedID"), forKey: "JobAcceptedID")
        //dd.setValue(dictFromPT.object(forKey: "UserID"), forKey: "PosterID")
        dd.setValue(dictFromPT.object(forKey: "RosterDateID"), forKey: "RosterDateID")
        //dd.setValue(dictFromPT.object(forKey: "ToTime"), forKey: "ExtendedFromTime")
        if dictFromPT.object(forKey: "ExFromTime") as! String == ""
        {
            dd.setValue(dictFromPT.object(forKey: "ToTime"), forKey: "ExtendedFromTime")
        }
        else
        {
            dd.setValue(dictFromPT.object(forKey: "ExFromTime"), forKey: "ExtendedFromTime")
        }
        
        var tMin = totalExtendedHour.truncatingRemainder(dividingBy: 60.0)
        tMin = tMin / 100
        let tHour: Int = Int(totalExtendedHour / 60)
        
        let str: String = String(format: "%0.2f", CGFloat(tHour) + tMin)
        
        
        
        
        if let n = NumberFormatter().number(from: str) {
            totalExtendedHour = CGFloat(n)
        }
        
        
//        var str: String = String(format: "%0.2f", totalExtendedHour)
//        str = str.replacingOccurrences(of: ".25", with: ".15")
//        str = str.replacingOccurrences(of: ".50", with: ".30")
//        str = str.replacingOccurrences(of: ".75", with: ".45")
//        
//        
//        if let n = NumberFormatter().number(from: str) {
//            totalExtendedHour = CGFloat(n)
//        }
        dd.setValue(totalExtendedHour, forKey: "NoOfHoursExtended")
        print(dd)
        API.callApiPOST(strUrl: API_SetRosterExtendsTime,parameter: dd, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let obj: feedbackClass = self.storyboard?.instantiateViewController(withIdentifier: "feedbackClass") as! feedbackClass
                obj.objSeeker = self
                obj.fromWhere = "submitPT"
                obj.dictFromPT = self.dictFromPT
                self.present(obj, animated: true, completion: nil)
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
