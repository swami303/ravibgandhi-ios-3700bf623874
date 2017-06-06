//
//  editTimefromPayment.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/10/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class editTimefromPayment: UIViewController
{
    
    //MARK:- Outlet
    @IBOutlet weak var txtTime: paddingTextField!
    @IBOutlet weak var txtHour: paddingTextField!
    @IBOutlet weak var lblTimeslot: UILabel!
    @IBOutlet weak var viewExtendedSlot: UIView!
    @IBOutlet weak var lblExtendedTimeslot: UILabel!
    @IBOutlet weak var viewCharge: cView!
    @IBOutlet weak var lblTotalhrs: UILabel!
    @IBOutlet weak var lblTotalCharge: UILabel!
    @IBOutlet weak var viewExtended: UIView!
    @IBOutlet weak var btnMainTimeSlotEdit: UIButton!
    @IBOutlet weak var btnEditExtendedTime: UIButton!
    @IBOutlet weak var btnHideTimeSlot: UIButton!
    
    var totalExtendedHour: CGFloat = 0.0
    var totalEarning: CGFloat = 0.0
    var hourlyRate: CGFloat = 0.0
    var JobTimePeriod: CGFloat = 0.0
    var dictFromMP: NSMutableDictionary = NSMutableDictionary()
    var objMakePayment: makePaymentClass!
    var fromWhere: String = ""
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewExtendedSlot.isHidden = true
        btnMainTimeSlotEdit.isHidden = true
        btnEditExtendedTime.isHidden = true
        txtHour.isUserInteractionEnabled = false
        txtTime.isUserInteractionEnabled = false
        if dictFromMP.object(forKey: "ExFromTime") as! String == ""
        {
            
        }
        else
        {
            viewExtendedSlot.isHidden = false
            lblExtendedTimeslot.text = String(format: "%@ - %@", dictFromMP.object(forKey: "ExFromTime") as! String,dictFromMP.object(forKey: "ExToTime") as! String )
        }
        lblTimeslot.text = String(format: "%@ - %@", dictFromMP.object(forKey: "FromTime") as! String,dictFromMP.object(forKey: "ToTime") as! String )
        totalExtendedHour = dictFromMP.object(forKey: "NoOfHoursExtended") as! CGFloat
        
        
        var totalTimeInmin: CGFloat = 0
        var totalTimeInHoure: CGFloat = 0
        
        var integer = 0.0
        totalTimeInmin = CGFloat(modf(Double(totalExtendedHour), &integer))
        totalTimeInHoure = totalExtendedHour - totalTimeInmin
        totalTimeInmin = totalTimeInmin * 100
        totalExtendedHour = totalTimeInmin + (totalTimeInHoure * 60)
        
        print(totalExtendedHour)
        let strJobTimePeriod: String = dictFromMP.object(forKey: "JobTimePeriod") as! String
        if let n = NumberFormatter().number(from: strJobTimePeriod) {
            JobTimePeriod = CGFloat(n)
        }
        
        totalTimeInmin = CGFloat(modf(Double(JobTimePeriod), &integer))
        totalTimeInHoure = JobTimePeriod - totalTimeInmin
        totalTimeInmin = totalTimeInmin * 100
        JobTimePeriod = totalTimeInmin + (totalTimeInHoure * 60)
        
        let strTE: String = dictFromMP.object(forKey: "TotalAmount") as! String
        let strHR: String = dictFromMP.object(forKey: "HourlyRate") as! String
        if let n = NumberFormatter().number(from: strTE) {
            totalEarning = CGFloat(n)
        }
        if let n = NumberFormatter().number(from: strHR) {
            hourlyRate = CGFloat(n)
        }
        setHourText()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Action Zone
    
    @IBAction func btnDone(_ sender: Any)
    {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "hh:mm a"
        let toTime = df.date(from: objMakePayment.dictFromPP.object(forKey: "FromTime") as! String)?.add(minutes: Int(JobTimePeriod)) as Date!
        if toTime == nil
        {
           print("nil")
            
            let strMainTime : String = objMakePayment.dictFromPP.object(forKey: "FromTime") as! String
            
            let arr = strMainTime.components(separatedBy: " ")
            let arrFristPart = arr[0].components(separatedBy: ":")
            
            var baseHour : Int = Int(arrFristPart[0])!

            var baseMin : Int = Int(arrFristPart[1])!
            var baseAMPM : String = arr[1]
            
            let tMin : Int = Int(JobTimePeriod.truncatingRemainder(dividingBy: 60.0))
           // tMin = tMin / 100
            
            let tHour: Int = Int(JobTimePeriod / 60)
            baseHour = baseHour + tHour
            baseMin = baseMin + tMin//Int(ceil(tMin))
            
            
            
            if(baseMin >= 60)
            {
                baseMin = baseMin - 60
                baseHour = baseHour + 1

                if(baseHour >= 24)
                {
                    custObj.alertMessage("Oops! something went wrong! Check your extended time.")
                    return
                }
                else
                {
                    if(baseAMPM == "AM" && baseHour >= 12)
                    {
                        baseAMPM = "PM"
                        
                        if(baseHour > 12)
                        {
                            baseHour = baseHour - 12
                        }
                        
                    }
                    else if(baseAMPM == "PM" && baseHour >= 12)
                    {
                        baseAMPM = "AM"
                        if(baseHour > 12)
                        {
                            baseHour = baseHour - 12
                        }
                    }
                }
            }
            else
            {
                if(baseHour >= 24)
                {
                    custObj.alertMessage("Time exceeds")
                }
                else
                {
                    if(baseAMPM == "AM" && baseHour >= 12)
                    {
                        baseAMPM = "PM"
                        if(baseHour > 12)
                        {
                            baseHour = baseHour - 12
                        }
                        
                    }
                    else if(baseAMPM == "PM" && baseHour >= 12)
                    {
                        baseAMPM = "AM"
                        if(baseHour > 12)
                        {
                            baseHour = baseHour - 12
                        }
                    }
                }
            }
            
            let strFinalTime :String = String.init(format: "%d:%02d %@", baseHour, baseMin, baseAMPM)
            
            if objMakePayment.dictFromPP.object(forKey: "ExFromTime") as! String == ""
            {
                objMakePayment.dictFromPP.setValue(strFinalTime, forKey: "ToTime")
            }
            else
            {
                objMakePayment.dictFromPP.setValue(strFinalTime, forKey: "ExToTime")
            }
        }
        else
        {
            if objMakePayment.dictFromPP.object(forKey: "ExFromTime") as! String == ""
            {
                objMakePayment.dictFromPP.setValue(df.string(from: toTime!), forKey: "ToTime")
            }
            else
            {
                objMakePayment.dictFromPP.setValue(df.string(from: toTime!), forKey: "ExToTime")
            }
        }
        
        var tMin = totalExtendedHour.truncatingRemainder(dividingBy: 60.0)
        tMin = tMin / 100
        var tHour: Int = Int(totalExtendedHour / 60)
        
        var str: String = String(format: "%0.2f", CGFloat(tHour) + tMin)
        
        
        if let n = NumberFormatter().number(from: str) {
            totalExtendedHour = CGFloat(n)
        }
        
        tMin = JobTimePeriod.truncatingRemainder(dividingBy: 60.0)
        tMin = tMin / 100
        tHour = Int(JobTimePeriod / 60)
        
        str = String(format: "%0.2f", CGFloat(tHour) + tMin)
        
        
        if let n = NumberFormatter().number(from: str) {
            JobTimePeriod = CGFloat(n)
        }
        
        objMakePayment.dictFromPP.setValue(String(format:"%0.2f",JobTimePeriod), forKey: "JobTimePeriod")
        objMakePayment.dictFromPP.setValue(totalExtendedHour, forKey: "NoOfHoursExtended")
        objMakePayment.setPrice()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnIncreaseHr(_ sender: Any)
    {
        totalExtendedHour = totalExtendedHour + 15 // + 0.25
        JobTimePeriod = JobTimePeriod + 15// + 0.25
        setHourText()
    }
    @IBAction func btnDecreaseHr(_ sender: Any)
    {
        if totalExtendedHour == 0.0
        {
            return
        }
        
        totalExtendedHour = totalExtendedHour - 15 //- 0.25
        if totalExtendedHour <= 0.0
        {
            totalExtendedHour = 0.0
        }
        JobTimePeriod = JobTimePeriod - 15 //- 0.25
        if JobTimePeriod <= 0.0
        {
            JobTimePeriod = 0.0
        }
        setHourText()
    }
    
    func setHourText()
    {
        print(totalExtendedHour)
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
        
        var TotalAmt: CGFloat = 0
        var totalAmtInmin: CGFloat = 0
        totalAmtInmin = hourlyRate / 60
        if dictFromMP.object(forKey: "IsBreak") as! Bool == false
        {
            TotalAmt = JobTimePeriod * totalAmtInmin
            tMin = JobTimePeriod.truncatingRemainder(dividingBy: 60.0)
            tMin = tMin / 100
            tHour = Int(JobTimePeriod / 60)
        }
        else
        {
            if dictFromMP.object(forKey: "IsBreakPaid") as! Bool == false
            {
                let min: Int = dictFromMP.object(forKey: "BreakMin") as! Int
                TotalAmt = (JobTimePeriod - CGFloat(min)) * totalAmtInmin
                
                let tempJT: CGFloat = JobTimePeriod - CGFloat(min)
                
                tMin = tempJT.truncatingRemainder(dividingBy: 60.0)
                tMin = tMin / 100
                tHour = Int(tempJT / 60)
            }
            else
            {
                TotalAmt = JobTimePeriod * totalAmtInmin
                tMin = JobTimePeriod.truncatingRemainder(dividingBy: 60.0)
                tMin = tMin / 100
                tHour = Int(JobTimePeriod / 60)
            }
        }
        
        str = String(format: "%0.2f", CGFloat(tHour) + tMin)
        str = str.replacingOccurrences(of: ".", with: ":")
        lblTotalhrs.text = String(format: "%@ hrs", str)
        lblTotalCharge.text = String(format: "$ %0.2f", TotalAmt)
    }
    @IBAction func btnMainTimeSlotEdit(_ sender: Any)
    {
        viewExtended.isHidden = false
    }
    @IBAction func btnExtendedTimeSlot(_ sender: Any)
    {
        viewExtended.isHidden = false
    }
    @IBAction func btnHideExtendedView(_ sender: Any)
    {
        viewExtended.isHidden = true
        setHourText()
    }
}
