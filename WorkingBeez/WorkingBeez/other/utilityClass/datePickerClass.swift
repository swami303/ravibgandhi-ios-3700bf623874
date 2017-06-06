//
//  datePickerClass.swift
//  MariCab
//
//  Created by Brainstorm on 1/6/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class datePickerClass: UIViewController
{
    //MARK:- Outlet
    @IBOutlet weak var btnDatePickerDone: UIButton!
    @IBOutlet weak var btnDatePickerCancel: UIButton!
    @IBOutlet weak var lblDatePikerHeader: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var fromWhere: String = ""
    var objRoster: setRosterClass!
    var objSeeker: regSeekerGInfo!
    var objSeekerProfile: myProfileSeeker!
    var strForDateOrTime: String = ""
    var minimumDates: Date!
    
    var custObj : customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        if fromWhere == "roster"
        {
            if minimumDates != nil
            {
                datePicker.minimumDate = minimumDates as Date?
                datePicker.date = minimumDates
            }
            if strForDateOrTime == "date"
            {
                datePicker.datePickerMode = UIDatePickerMode.date
            }
            else
            {
                //datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
                //datePicker.locale = NSLocale(localeIdentifier: "en_US") as Locale
                datePicker.datePickerMode = UIDatePickerMode.time
            }
        }
        else if fromWhere == "seekerReg" || fromWhere == "seekerProfile"
        {
            datePicker.maximumDate = Date().addingTimeInterval(-(60*60*24*365)*16)
            datePicker.maximumDate = datePicker.maximumDate?.addingTimeInterval(-60*60*24*4)
            if strForDateOrTime == "date"
            {
                datePicker.datePickerMode = UIDatePickerMode.date
            }
            else
            {
                datePicker.datePickerMode = UIDatePickerMode.time
                //datePicker.locale = NSLocale(localeIdentifier: "en_US") as Locale
                //datePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
            }
        }
        else if fromWhere == "seekerProfileHistroy"
        {
            datePicker.maximumDate = Date()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnDatePickerDone(_ sender: Any)
    {
        let df: DateFormatter = DateFormatter()
        
        if fromWhere == "roster"
        {
            print(df.string(from: datePicker.date))
            if strForDateOrTime == "date"
            {
                df.dateFormat = "dd/MM/yyyy"
                
                objRoster.txtToDate.text = ""
            }
            else
            {
                df.dateFormat = "hh:mm a"
                //datePicker.locale = NSLocale(localeIdentifier: "en_US") as Locale
                
//                let strTime: String = df.string(from: datePicker.date)
//                if !strTime.lowercased().contains("A".lowercased())
//                {
//                    objRoster.tempTextField.text = API.convertDateToString(strDate: df.string(from: datePicker.date), fromFormat: "HH:mm", toFormat: "hh:mm a")
//                }
//                else
//                {
//                    objRoster.tempTextField.text = df.string(from: datePicker.date)
//                }
            }
            
            objRoster.tempTextField.text = df.string(from: datePicker.date)
            if objRoster.tempTextField == objRoster.txtDate || objRoster.tempTextField == objRoster.txtFromDate
            {
                objRoster.txtDate.text = df.string(from: datePicker.date)
                objRoster.txtFromDate.text = df.string(from: datePicker.date)
                objRoster.txtStartTime.text = ""
            }
            objRoster.calculatePirce()
            
        }
        else if fromWhere == "seekerReg"
        {
            if strForDateOrTime == "date"
            {
                
                let year: Int = Date().yearss(from: datePicker.date)
                if year < 16
                {
                    custObj.alertMessage("Oops..something went wrong! Check your DOB")
                    return
                }
                df.dateFormat = "dd/MM/yyyy"
            }
            else
            {
                df.dateFormat = "hh:mm a"
            }
            objSeeker.txtDOB.text = df.string(from: datePicker.date)
        }
        else if fromWhere == "seekerProfile"
        {
            if strForDateOrTime == "date"
            {
                
                let year: Int = Date().yearss(from: datePicker.date)
                if year < 16
                {
                    custObj.alertMessage("Oops..something went wrong! Check your DOB")
                    return
                }
                
                
                df.dateFormat = "dd/MM/yyyy"
            }
            else
            {
                df.dateFormat = "hh:mm a"
            }
            objSeekerProfile.txtDOB.text = df.string(from: datePicker.date)
        }
        else if fromWhere == "seekerProfileHistroy"
        {
            df.dateFormat = "dd/MM/yyyy"
            objSeekerProfile.tempTextField.text = df.string(from: datePicker.date)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDatePickerCancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDismiss(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
extension Date {
    /// Returns the amount of years from another date
    func yearss(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if yearss(from: date)   > 0 { return "\(yearss(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
