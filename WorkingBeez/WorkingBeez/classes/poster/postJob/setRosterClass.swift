//
//  setRosterClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/24/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class setRosterClass: UIViewController,UITextFieldDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var viewBottomInfo: UIView!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var viewNoRepeatInfo: UIView!
    @IBOutlet weak var viewRepeatInfo: UIView!
    @IBOutlet weak var viewScrInnermain: UIView!
    @IBOutlet weak var viewRepeat: cView!
    @IBOutlet weak var viewRepeatWithDate: UIView!
    @IBOutlet weak var txtDate: paddingTextField!
    @IBOutlet weak var txtStartTime: paddingTextField!
    @IBOutlet weak var txtHours: paddingTextField!
    @IBOutlet weak var txtBreak: paddingTextField!
    @IBOutlet weak var btnBreakPaid: UIButton!
    @IBOutlet weak var txtRate: paddingTextField!
    @IBOutlet weak var txtTotalHire: paddingTextField!
    @IBOutlet weak var btnMon: cButton!
    @IBOutlet weak var btnTue: cButton!
    @IBOutlet weak var btnWed: cButton!
    @IBOutlet weak var btnThu: cButton!
    @IBOutlet weak var btnFri: cButton!
    @IBOutlet weak var btnSat: cButton!
    @IBOutlet weak var btnSun: cButton!
    @IBOutlet weak var txtFromDate: paddingTextField!
    @IBOutlet weak var txtToDate: paddingTextField!
    @IBOutlet weak var txtTotalRepeatDay: paddingTextField!
    @IBOutlet weak var swRepeatSetting: cSwitch!
    @IBOutlet weak var viewTopInnerView: UIView!
    @IBOutlet weak var lblPerDayCharge: UILabel!
    @IBOutlet weak var lblTotalDayCharge: UILabel!
    @IBOutlet weak var lblWithoutRepeatCharge: UILabel!
    @IBOutlet weak var imgHireIcon: UIImageView!
    @IBOutlet weak var lblTotalDays: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    
    var fromWhere: String = ""
    var objHisEdit: postHisDetail!
    var objComEdit: completedJobDetailPoster!
    var isForEditRoster: Bool = false
    var arrOfDaySelected: NSMutableArray = NSMutableArray()
    var breakTime: Int = 0
    var tempTextField: paddingTextField!
    var rate: CGFloat = 25
    var totalHire: Int = 1
    var totalHour: CGFloat = 3
    var totalHourTemp: CGFloat = 3
    var totalRepeatDays: CGFloat = 0
    var TotalWorkingBeezCharge: CGFloat = 0.0
    var deleObj: AppDelegate!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scrMain.contentSizeToFit()
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        swRepeatSetting.isOn = false
        setHideShowView()
        view.backgroundColor = API.appBackgroundColor()
        
        
        for case let txt as paddingTextField in self.viewTopInnerView.subviews
        {
            txt.delegate = self
        }
        for case let txt as paddingTextField in self.viewRepeatWithDate.subviews
        {
            txt.delegate = self
        }
        if fromWhere == "objPostHisEdit"
        {
            if objHisEdit.isAdd == false
            {
                fillDataGLobally(dictRoster: objHisEdit.dictRoster)
            }
            btnNext.setTitle("Done", for: UIControlState.normal)
            viewStep.isHidden = true
        }
        else if fromWhere == "objComEdit"
        {
            if objComEdit.isAdd == false
            {
                fillDataGLobally(dictRoster: objComEdit.dictRoster)
            }
            btnNext.setTitle("Done", for: UIControlState.normal)
            viewStep.isHidden = true
        }
        imgHireIcon.tintColor = API.themeColorBlue()
        NotificationCenter.default.addObserver(self, selector: #selector(resetAll), name: NSNotification.Name(rawValue: "resetRoster"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prefillRoster), name: NSNotification.Name(rawValue: "prefillRoster"), object: nil)
        setHourText()
        //calculatePirce()
        txtTotalHire.text = String(format: "%d", totalHire)
        txtRate.text = String(format: "$ %0.f", rate)
        setHourText()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        //resetAll()
    }
    //MARK:- POST NOTIFICATION
    func prefillRoster(n: Notification)
    {
        isForEditRoster = true
        let dd: NSDictionary = n.object as! NSDictionary
        fillDataGLobally(dictRoster: NSMutableDictionary.init(dictionary: dd))
    }
    func fillDataGLobally(dictRoster: NSMutableDictionary)
    {
        print(dictRoster)
        
        if dictRoster.object(forKey: "BreakTimeInMin") as! Int == 0
        {
            txtBreak.text = ""
            btnBreakPaid.isSelected = false
        }
        else
        {
            txtBreak.text = String(format: "%d min", dictRoster.object(forKey: "BreakTimeInMin") as! Int)
            if dictRoster.object(forKey: "IsPaid") as! Bool == true
            {
                btnBreakPaid.isSelected = true
            }
            else
            {
                btnBreakPaid.isSelected = false
            }
        }
        rate = dictRoster.object(forKey: "Rate") as! CGFloat
        totalHire = dictRoster.object(forKey: "NoOfHire") as! Int
        totalHour = dictRoster.object(forKey: "Hours") as! CGFloat
        TotalWorkingBeezCharge = dictRoster.object(forKey: "totalCharge") as! CGFloat
        totalRepeatDays = dictRoster.object(forKey: "totalDays") as! CGFloat
        
        var str: String = String(format: "%0.2f", totalHour)
        str = str.replacingOccurrences(of: ".15", with: ".25")
        str = str.replacingOccurrences(of: ".30", with: ".50")
        str = str.replacingOccurrences(of: ".45", with: ".75")
        
        
        if let n = NumberFormatter().number(from: str) {
            totalHour = CGFloat(n)
        }
        
        txtDate.text = dictRoster.object(forKey: "Date") as? String
        txtFromDate.text = dictRoster.object(forKey: "Date") as? String
        txtStartTime.text = dictRoster.object(forKey: "StartTime") as? String
        txtHours.text = String(format: "%0.1f hrs", dictRoster.object(forKey: "Hours") as! CGFloat)
        breakTime = dictRoster.object(forKey: "BreakTimeInMin") as! Int
        txtTotalHire.text = String(format: "%d", totalHire)
        txtRate.text = String(format: "$ %0.f", rate)
        
        if dictRoster.object(forKey: "IsRepete") as! Bool == true
        {
            arrOfDaySelected = NSMutableArray()
            swRepeatSetting.isOn = true
            txtFromDate.text = dictRoster.object(forKey: "FromDate") as? String
            txtToDate.text = dictRoster.object(forKey: "ToDate") as? String
            
            let strDays: String = (dictRoster.object(forKey: "DayOfWeek") as? String)!
            if strDays.contains("1")
            {
                btnMon.backgroundColor = API.themeColorBlue()
                btnMon.isSelected = true
                arrOfDaySelected.add("1")
            }
            else
            {
                btnMon.backgroundColor = UIColor.white
                btnMon.isSelected = false
            }
            if strDays.contains("2")
            {
                btnTue.backgroundColor = API.themeColorBlue()
                btnTue.isSelected = true
                arrOfDaySelected.add("2")
            }
            else
            {
                btnTue.backgroundColor = UIColor.white
                btnTue.isSelected = false
            }
            if strDays.contains("3")
            {
                btnWed.backgroundColor = API.themeColorBlue()
                btnWed.isSelected = true
                arrOfDaySelected.add("3")
            }
            else
            {
                btnWed.backgroundColor = UIColor.white
                btnWed.isSelected = false
            }
            if strDays.contains("4")
            {
                btnThu.backgroundColor = API.themeColorBlue()
                btnThu.isSelected = true
                arrOfDaySelected.add("4")
            }
            else
            {
                btnThu.backgroundColor = UIColor.white
                btnThu.isSelected = false
            }
            if strDays.contains("5")
            {
                btnFri.backgroundColor = API.themeColorBlue()
                btnFri.isSelected = true
                arrOfDaySelected.add("5")
            }
            else
            {
                btnFri.backgroundColor = UIColor.white
                btnFri.isSelected = false
            }
            if strDays.contains("6")
            {
                btnSat.backgroundColor = API.themeColorBlue()
                btnSat.isSelected = true
                arrOfDaySelected.add("6")
            }
            else
            {
                btnSat.backgroundColor = UIColor.white
                btnSat.isSelected = false
            }
            if strDays.contains("0")
            {
                btnSun.backgroundColor = API.themeColorBlue()
                btnSun.isSelected = true
                arrOfDaySelected.add("0")
            }
            else
            {
                btnSun.backgroundColor = UIColor.white
                btnSun.isSelected = false
            }
        }
        else
        {
            swRepeatSetting.isOn = false
        }
        setHourText()
        setHideShowView()
        calculatePirce()
    }
    
    //MARK:- Calculate Price
    func calculatePirce()
    {
        var breakPrice: CGFloat = 0.0
        var totalHourPrice: CGFloat = 0.0
        totalRepeatDays = 0
        if txtBreak.text != ""
        {
            if btnBreakPaid.isSelected == false
            {
                breakPrice = CGFloat((CGFloat(breakTime) * rate) / 60)
            }
        }
        totalHourPrice = totalHour * rate
        totalHourPrice = totalHourPrice - breakPrice
        
        if swRepeatSetting.isOn == false
        {
            
        }
        else
        {
            if txtFromDate.text == "" || txtToDate.text == ""
            {
                
            }
            else
            {
                let df: DateFormatter = DateFormatter()
                df.dateFormat = "dd/MM/yyyy"
                var fromDate: Date = df.date(from: txtFromDate.text!)! // first date
                let endDate: Date = df.date(from: txtToDate.text!)! // last date
                
                // Formatter for printing the date, adjust it according to your needs:
                
                while fromDate <= endDate {
                    print(df.string(from: fromDate))
                    let dfForDay: DateFormatter = DateFormatter()
                    dfForDay.dateFormat = "EEE"
                    print(dfForDay.string(from: fromDate))
                    if btnMon.isSelected == true
                    {
                        if "Mon".lowercased() == dfForDay.string(from: fromDate).lowercased()
                        {
                            totalRepeatDays = totalRepeatDays + 1
                        }
                    }
                    
                    if btnTue.isSelected == true
                    {
                        if "Tue".lowercased() == dfForDay.string(from: fromDate).lowercased()
                        {
                            totalRepeatDays = totalRepeatDays + 1
                        }
                    }
                    
                    if btnWed.isSelected == true
                    {
                        if "Wed".lowercased() == dfForDay.string(from: fromDate).lowercased()
                        {
                            totalRepeatDays = totalRepeatDays + 1
                        }
                    }
                    
                    if btnThu.isSelected == true
                    {
                        if "Thu".lowercased() == dfForDay.string(from: fromDate).lowercased()
                        {
                            totalRepeatDays = totalRepeatDays + 1
                        }
                    }
                    
                    if btnFri.isSelected == true
                    {
                        if "Fri".lowercased() == dfForDay.string(from: fromDate).lowercased()
                        {
                            totalRepeatDays = totalRepeatDays + 1
                        }
                    }
                    
                    if btnSat.isSelected == true
                    {
                        if "Sat".lowercased() == dfForDay.string(from: fromDate).lowercased()
                        {
                            totalRepeatDays = totalRepeatDays + 1
                        }
                    }
                    
                    if btnSun.isSelected == true
                    {
                        if "Sun".lowercased() == dfForDay.string(from: fromDate).lowercased()
                        {
                            totalRepeatDays = totalRepeatDays + 1
                        }
                    }
                    fromDate = Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
                }
            }
        }
        
        TotalWorkingBeezCharge = totalHourPrice * CGFloat(totalHire)
        lblWithoutRepeatCharge.text = String(format: "$ %0.2f", TotalWorkingBeezCharge)
        lblPerDayCharge.text = String(format: "$ %0.2f", TotalWorkingBeezCharge)
        lblTotalDayCharge.text = String(format: "$ %0.2f", TotalWorkingBeezCharge * totalRepeatDays)
        
        
        if totalRepeatDays == 1 || totalRepeatDays == 0
        {
            lblTotalDays.text = String(format: "%0.f Day", totalRepeatDays)
            txtTotalRepeatDay.text = String(format: "%0.f Day", totalRepeatDays)
        }
        else
        {
            lblTotalDays.text = String(format: "%0.f Days", totalRepeatDays)
            txtTotalRepeatDay.text = String(format: "%0.f Days", totalRepeatDays)
        }
    }
    func setHourText()
    {
        var str: String = String(format: "%0.2f", totalHour)
        str = str.replacingOccurrences(of: ".25", with: ":15")
        str = str.replacingOccurrences(of: ".50", with: ":30")
        str = str.replacingOccurrences(of: ".75", with: ":45")
        str = str.replacingOccurrences(of: ".00", with: ":00")
        
        print(str)
        txtHours.text = String(format: "%@ hrs", str)
        calculatePirce()
    }
    //MARK:- Action Zone
    @IBAction func btnNext(_ sender: Any)
    {
        if txtDate.text == ""
        {
            custObj.alertMessage("Please select date")
            return
        }
        if txtStartTime.text == ""
        {
            custObj.alertMessage("Please select start time")
            return
        }
        if swRepeatSetting.isOn == true
        {
            if txtToDate.text == ""
            {
                custObj.alertMessage("Please select end date")
                return
            }
            if arrOfDaySelected.count == 0
            {
                custObj.alertMessage("Please select atleast one day for repeat")
                return
            }
            if totalRepeatDays == 0
            {
                custObj.alertMessage("There is no any repeat day in your selected dates")
                return
            }
        }
        if btnBreakPaid.isSelected == true
        {
            if txtBreak.text == ""
            {
                custObj.alertMessage("Please select break time if you are paying for break")
                return
            }
        }
        let dictRoster: NSMutableDictionary = NSMutableDictionary()
        
        
        if fromWhere == "objPostHisEdit"
        {
            
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "hh:mm a"
            let min: CGFloat = 60
            let toTime = df.date(from: txtStartTime.text!)?.add(minutes: Int (totalHour * min))
            
            dictRoster.setValue(API.convertDateToString(strDate: txtDate.text!, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"), forKey: "Date")
            dictRoster.setValue(API.convertDateToString(strDate: txtDate.text!, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"), forKey: "FromDate")
            dictRoster.setValue(API.convertDateToString(strDate: txtToDate.text!, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"), forKey: "ToDate")
            dictRoster.setValue(df.string(from: toTime!), forKey: "ToTime")
            dictRoster.setValue(txtStartTime.text, forKey: "FromTime")
            
            
            var str: String = String(format: "%0.2f", totalHour)
            str = str.replacingOccurrences(of: ".25", with: ".15")
            str = str.replacingOccurrences(of: ".50", with: ".30")
            str = str.replacingOccurrences(of: ".75", with: ".45")
            
            
            if let n = NumberFormatter().number(from: str) {
                totalHour = CGFloat(n)
            }
            
            dictRoster.setValue(totalHour, forKey: "Hours")
            dictRoster.setValue(breakTime, forKey: "BreakMin")
            dictRoster.setValue(btnBreakPaid.isSelected, forKey: "IsBreakPaid")
            dictRoster.setValue(String(format:"%0.2f",rate), forKey: "Rate")
            dictRoster.setValue(totalHire, forKey: "NoOfHire")
            dictRoster.setValue(swRepeatSetting.isOn, forKey: "IsRepete")
            let strDays = arrOfDaySelected.componentsJoined(by: ",")
            dictRoster.setValue(strDays, forKey: "DayOfWeekIDs")
            dictRoster.setValue(TotalWorkingBeezCharge, forKey: "totalCharge")
            dictRoster.setValue(totalRepeatDays, forKey: "totalDays")
            dictRoster.setValue(0, forKey: "TotalApplied")
            dictRoster.setValue(objHisEdit.dictRoster.object(forKey: "RosterID"), forKey: "RosterID")
            if txtBreak.text == ""
            {
                dictRoster.setValue(false, forKey: "IsBreak")
            }
            else
            {
                dictRoster.setValue(true, forKey: "IsBreak")
            }
            print(dictRoster)
            if objHisEdit.isAdd == false
            {
                objHisEdit.arrOfRoster.replaceObject(at: objHisEdit.selectedIndex, with: dictRoster)
            }
            else
            {
                objHisEdit.arrOfRoster.add(dictRoster)
            }
            objHisEdit.tblRoster.reloadData()
            objHisEdit.arrangeView()
            _ = self.navigationController?.popViewController(animated: true)
        }
        else if fromWhere == "objComEdit"
        {
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "hh:mm a"
            let min: CGFloat = 60
            let toTime = df.date(from: txtStartTime.text!)?.add(minutes: Int (totalHour * min))
            
            dictRoster.setValue(API.convertDateToString(strDate: txtDate.text!, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"), forKey: "Date")
            dictRoster.setValue(API.convertDateToString(strDate: txtDate.text!, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"), forKey: "FromDate")
            dictRoster.setValue(API.convertDateToString(strDate: txtToDate.text!, fromFormat: "dd/MM/yyyy", toFormat: "dd MMM yyyy"), forKey: "ToDate")
            dictRoster.setValue(df.string(from: toTime!), forKey: "ToTime")
            dictRoster.setValue(txtStartTime.text, forKey: "FromTime")
            
            var str: String = String(format: "%0.2f", totalHour)
            str = str.replacingOccurrences(of: ".25", with: ".15")
            str = str.replacingOccurrences(of: ".50", with: ".30")
            str = str.replacingOccurrences(of: ".75", with: ".45")
            
            
            if let n = NumberFormatter().number(from: str) {
                totalHour = CGFloat(n)
            }
            dictRoster.setValue(totalHour, forKey: "Hours")
            dictRoster.setValue(breakTime, forKey: "BreakMin")
            dictRoster.setValue(btnBreakPaid.isSelected, forKey: "IsBreakPaid")
            dictRoster.setValue(String(format:"%0.2f",rate), forKey: "Rate")
            dictRoster.setValue(totalHire, forKey: "NoOfHire")
            dictRoster.setValue(swRepeatSetting.isOn, forKey: "IsRepete")
            let strDays = arrOfDaySelected.componentsJoined(by: ",")
            dictRoster.setValue(strDays, forKey: "DayOfWeekIDs")
            dictRoster.setValue(TotalWorkingBeezCharge, forKey: "totalCharge")
            dictRoster.setValue(totalRepeatDays, forKey: "totalDays")
            dictRoster.setValue(0, forKey: "TotalApplied")
            dictRoster.setValue(objComEdit.dictRoster.object(forKey: "RosterID"), forKey: "RosterID")
            if txtBreak.text == ""
            {
                dictRoster.setValue(false, forKey: "IsBreak")
            }
            else
            {
                dictRoster.setValue(true, forKey: "IsBreak")
            }
            print(dictRoster)
            if objComEdit.isAdd == false
            {
                objComEdit.arrOfRoster.replaceObject(at: objComEdit.selectedIndex, with: dictRoster)
            }
            else
            {
                objComEdit.arrOfRoster.add(dictRoster)
            }
            objComEdit.tblRoster.reloadData()
            objComEdit.arrangeView()
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            //totalHour = 1
            dictRoster.setValue(txtDate.text, forKey: "Date")
            dictRoster.setValue(txtStartTime.text, forKey: "StartTime")
            
            
            var str: String = String(format: "%0.2f", totalHour)
            str = str.replacingOccurrences(of: ".25", with: ".15")
            str = str.replacingOccurrences(of: ".50", with: ".30")
            str = str.replacingOccurrences(of: ".75", with: ".45")
            
            
            if let n = NumberFormatter().number(from: str) {
                totalHour = CGFloat(n)
            }
            dictRoster.setValue(totalHour, forKey: "Hours")
            dictRoster.setValue(breakTime, forKey: "BreakTimeInMin")
            dictRoster.setValue(btnBreakPaid.isSelected, forKey: "IsPaid")
            dictRoster.setValue(rate, forKey: "Rate")
            dictRoster.setValue(totalHire, forKey: "NoOfHire")
            dictRoster.setValue(swRepeatSetting.isOn, forKey: "IsRepete")
            let strDays = arrOfDaySelected.componentsJoined(by: ",")
            dictRoster.setValue(strDays, forKey: "DayOfWeek")
            dictRoster.setValue(txtDate.text, forKey: "FromDate")
            dictRoster.setValue(txtToDate.text, forKey: "ToDate")
            dictRoster.setValue(TotalWorkingBeezCharge, forKey: "totalCharge")
            dictRoster.setValue(totalRepeatDays, forKey: "totalDays")
            if deleObj.arrOfRoster.contains(dictRoster)
            {
                
            }
            else if isForEditRoster == true
            {
                deleObj.arrOfRoster.replaceObject(at: deleObj.arrIndexForRosterEdit, with: dictRoster)
            }
            else
            {
                deleObj.arrOfRoster.add(dictRoster)
            }
            isForEditRoster = false
            deleObj.dictPosJob.setValue(deleObj.arrOfRoster, forKey: "Roster")
            let obj: rosterDetailClass = self.storyboard?.instantiateViewController(withIdentifier: "rosterDetailClass") as! rosterDetailClass
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    @IBAction func btnIncreaseHr(_ sender: Any)
    {
        totalHour = totalHour + 0.25
        setHourText()
    }
    @IBAction func btnDecreaseHr(_ sender: Any)
    {
        if totalHour == 3
        {
            return
        }
        
        totalHour = totalHour - 0.25
        if totalHour <= 4
        {
            txtBreak.text = ""
            breakTime = 0
            btnBreakPaid.isSelected = false
        }
        setHourText()
    }
    @IBAction func btnPaid(_ sender: Any)
    {
        btnBreakPaid.isSelected = !btnBreakPaid.isSelected
        calculatePirce()
    }
    @IBAction func btnIncreaseRate(_ sender: Any)
    {
        rate = rate + 1
        txtRate.text = String(format: "$ %0.f", rate)
        calculatePirce()
    }
    @IBAction func btnDecreaseRate(_ sender: Any)
    {
        if rate == 25
        {
            return
        }
        rate = rate - 1
        txtRate.text = String(format: "$ %0.f", rate)
        calculatePirce()
    }
    @IBAction func btnIncreaseHire(_ sender: Any)
    {
        if totalHire == 9
        {
            return
        }
        totalHire = totalHire + 1
        txtTotalHire.text = String(format: "%d", totalHire)
        calculatePirce()
    }
    @IBAction func btnDecreaseHire(_ sender: Any)
    {
        if totalHire == 1
        {
            return
        }
        totalHire = totalHire - 1
        txtTotalHire.text = String(format: "%d", totalHire)
        calculatePirce()
    }
    @IBAction func swRepeateSetting(_ sender: Any)
    {
        setHideShowView()
    }
    
    //MARK:- Day Selection
    @IBAction func btnMon(_ sender: Any)
    {
        if btnMon.isSelected == true
        {
            btnMon.isSelected = false
            btnMon.backgroundColor = UIColor.white
            arrOfDaySelected.remove("1")
        }
        else
        {
            btnMon.isSelected = true
            btnMon.backgroundColor = API.themeColorBlue()
            arrOfDaySelected.add("1")
        }
        calculatePirce()
    }
    @IBAction func btnTue(_ sender: Any)
    {
        if btnTue.isSelected == true
        {
            btnTue.isSelected = false
            btnTue.backgroundColor = UIColor.white
            arrOfDaySelected.remove("2")
        }
        else
        {
            btnTue.isSelected = true
            btnTue.backgroundColor = API.themeColorBlue()
            arrOfDaySelected.add("2")
        }
        calculatePirce()
    }
    @IBAction func btnWed(_ sender: Any)
    {
        if btnWed.isSelected == true
        {
            btnWed.isSelected = false
            btnWed.backgroundColor = UIColor.white
            arrOfDaySelected.remove("3")
        }
        else
        {
            btnWed.isSelected = true
            btnWed.backgroundColor = API.themeColorBlue()
            arrOfDaySelected.add("3")
        }
        calculatePirce()
    }
    @IBAction func btnThu(_ sender: Any)
    {
        if btnThu.isSelected == true
        {
            btnThu.isSelected = false
            btnThu.backgroundColor = UIColor.white
            arrOfDaySelected.remove("4")
        }
        else
        {
            btnThu.isSelected = true
            btnThu.backgroundColor = API.themeColorBlue()
            arrOfDaySelected.add("4")
        }
        calculatePirce()
    }
    @IBAction func btnFir(_ sender: Any)
    {
        if btnFri.isSelected == true
        {
            btnFri.isSelected = false
            btnFri.backgroundColor = UIColor.white
            arrOfDaySelected.remove("5")
        }
        else
        {
            btnFri.isSelected = true
            btnFri.backgroundColor = API.themeColorBlue()
            arrOfDaySelected.add("5")
        }
        calculatePirce()
    }
    @IBAction func btnSat(_ sender: Any)
    {
        if btnSat.isSelected == true
        {
            btnSat.isSelected = false
            btnSat.backgroundColor = UIColor.white
            arrOfDaySelected.remove("6")
        }
        else
        {
            btnSat.isSelected = true
            btnSat.backgroundColor = API.themeColorBlue()
            arrOfDaySelected.add("6")
        }
        calculatePirce()
    }
    @IBAction func btnSun(_ sender: Any)
    {
        if btnSun.isSelected == true
        {
            btnSun.isSelected = false
            btnSun.backgroundColor = UIColor.white
            arrOfDaySelected.remove("0")
        }
        else
        {
            btnSun.isSelected = true
            btnSun.backgroundColor = API.themeColorBlue()
            arrOfDaySelected.add("0")
        }
        calculatePirce()
    }
    //MARK:- Reset All
    func resetAll()
    {
        if isForEditRoster == true
        {
            return
        }
        breakTime = 0
        rate = 25
        totalHire = 1
        totalHour = 3
        totalRepeatDays = 0
        TotalWorkingBeezCharge = 0
        
        txtTotalHire.text = String(format: "%d", totalHire)
        txtRate.text = String(format: "$ %0.f", rate)
        txtDate.text = ""
        txtFromDate.text = ""
        txtToDate.text = ""
        txtStartTime.text = ""
        txtBreak.text = ""
        
        btnBreakPaid.isSelected = false
        txtTotalRepeatDay.text = ""
        btnSun.isSelected = false
        btnMon.isSelected = false
        btnTue.isSelected = false
        btnWed.isSelected = false
        btnThu.isSelected = false
        btnFri.isSelected = false
        btnSat.isSelected = false
        
        btnSun.backgroundColor = UIColor.white
        btnMon.backgroundColor = UIColor.white
        btnTue.backgroundColor = UIColor.white
        btnWed.backgroundColor = UIColor.white
        btnThu.backgroundColor = UIColor.white
        btnFri.backgroundColor = UIColor.white
        btnSat.backgroundColor = UIColor.white
        
        swRepeatSetting.isOn = false
        setHideShowView()
        setHourText()
        calculatePirce()
    }
    //MARK:- From Date - To Date
    @IBAction func btnFromDate(_ sender: Any)
    {
        tempTextField = txtFromDate
        let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
        obj.objRoster = self
        obj.fromWhere = "roster"
        obj.strForDateOrTime = "date"
        self.present(obj, animated: true, completion: nil)
    }
    @IBAction func btnToDate(_ sender: Any)
    {
        tempTextField = txtToDate
        let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
        obj.objRoster = self
        obj.fromWhere = "roster"
        obj.strForDateOrTime = "date"
        self.present(obj, animated: true, completion: nil)
    }
    
    
    func setHideShowView()
    {
        var animDuration: CGFloat = 0.0
        animDuration = 0.2;
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(TimeInterval(animDuration))
        if swRepeatSetting.isOn == true
        {
            viewRepeatWithDate.isHidden = false
            viewRepeatInfo.isHidden = false
            lblNotes.isHidden = false
            viewNoRepeatInfo.isHidden = true
        }
        else
        {
            viewRepeatWithDate.isHidden = true
            viewRepeatInfo.isHidden = true
            lblNotes.isHidden = true
            viewNoRepeatInfo.isHidden = false
        }
        UIView.commitAnimations()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        tempTextField = textField as! paddingTextField
        if tempTextField == txtFromDate || tempTextField == txtDate || tempTextField == txtToDate
        {
            let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
            obj.objRoster = self
            obj.fromWhere = "roster"
            obj.strForDateOrTime = "date"
            obj.minimumDates = Date() as Date
            self.present(obj, animated: true, completion: nil)
        }
        if tempTextField == txtStartTime
        {
            let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
            obj.objRoster = self
            obj.fromWhere = "roster"
            obj.strForDateOrTime = "time"
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "dd/MM/yyyy"
            let strDate: String = df.string(from: Date())
            if txtDate.text == "" || txtDate.text == strDate
            {
                obj.minimumDates = Date().add(minutes: 105) as Date
            }
            self.present(obj, animated: true, completion: nil)
        }
        if tempTextField == txtBreak
        {
            if totalHour <= 4
            {
                custObj.alertMessage("You have to set more than 4 hour for break")
                return false
            }
            let arr: NSMutableArray = NSMutableArray()
            var dd: NSMutableDictionary = NSMutableDictionary()
            dd.setValue("No break", forKey: "Name")
            dd.setValue(0, forKey: "min")
            arr.add(dd)
            
            dd = NSMutableDictionary()
            dd.setValue("10 min", forKey: "Name")
            dd.setValue(10, forKey: "min")
            arr.add(dd)
            
            dd = NSMutableDictionary()
            dd.setValue("15 min", forKey: "Name")
            dd.setValue(15, forKey: "min")
            arr.add(dd)
            
            dd = NSMutableDictionary()
            dd.setValue("30 min", forKey: "Name")
            dd.setValue(30, forKey: "min")
            arr.add(dd)
            
            let obj: pickerClass = self.storyboard?.instantiateViewController(withIdentifier: "pickerClass") as! pickerClass
            obj.objSetRoster = self
            obj.fromWhere = "setRoster"
            obj.arrOfPicker = arr
            self.present(obj, animated: true, completion: nil)
        }
        return false
    }
 }

extension Date {
    func add(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
}
