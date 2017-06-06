//
//  pickerClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/3/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class pickerClass: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var btnDatePickerDone: UIButton!
    @IBOutlet weak var btnDatePickerCancel: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    var fromWhere: String = ""
    var objSetRoster: setRosterClass!
    var objSeekerProfile: myProfileSeeker!
    var objFilterSeeker: filterSeeker!
    var objFilterPoster: filterPoster!
    
    var arrOfPicker: NSMutableArray = NSMutableArray()
    var custObj : customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        if fromWhere == "setRoster"
        {
            
        }
        picker.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnDatePickerDone(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        if arrOfPicker.count != 0
        {
            if fromWhere == "setRoster"
            {
                let str: String = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "Name") as! String
                objSetRoster.breakTime = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "min") as! Int
                if objSetRoster.breakTime == 0
                {
                    objSetRoster.txtBreak.text = ""
                }
                else
                {
                    objSetRoster.txtBreak.text = str
                }
                objSetRoster.calculatePirce()
            }
            else if fromWhere == "seekerProfile"
            {
                let str: String = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "Name") as! String
                objSeekerProfile.WorkingRightID = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "ID") as! Int
                objSeekerProfile.txtWorkingRights.text = str
            }
            else if fromWhere == "filterSeeker"
            {
                if objFilterSeeker.txtTemp == objFilterSeeker.txtCategory
                {
                    let str: String = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "CategoryName") as! String
                    objFilterSeeker.categotyID = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "CategoryID") as! Int
                    objFilterSeeker.txtTemp.text = str
                    objFilterSeeker.txtJobTitle.text = ""
                    objFilterSeeker.jobTitleID = -1
                    objFilterSeeker.getAllJobTitle()
                }
                else
                {
                    let str: String = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "Name") as! String
                    objFilterSeeker.jobTitleID = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "ID") as! Int
                    objFilterSeeker.txtTemp.text = str
                }
            }
            else if fromWhere == "filterPoster"
            {
                if objFilterPoster.txtTemp == objFilterPoster.txtCategory
                {
                    let str: String = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "Path") as! String
                    objFilterPoster.categotyID = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "ID") as! Int
                    objFilterPoster.txtTemp.text = str
                    objFilterPoster.txtJobTitle.text = ""
                    objFilterPoster.jobTitleID = -1
                    objFilterPoster.getAllJobTitle()
                }
                else
                {
                    let str: String = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "Name") as! String
                    objFilterPoster.jobTitleID = (arrOfPicker.object(at: picker.selectedRow(inComponent: 0)) as AnyObject).object(forKey: "ID") as! Int
                    objFilterPoster.txtTemp.text = str
                }
            }
        }
    }
    @IBAction func btnDatePickerCancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDismiss(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Uipickerview Delegate
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrOfPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if fromWhere == "filterSeeker"
        {
            if objFilterSeeker.txtTemp == objFilterSeeker.txtCategory
            {
                let str: String = (arrOfPicker.object(at: row) as AnyObject).object(forKey: "CategoryName") as! String
                return str
            }
            else
            {
                let str: String = (arrOfPicker.object(at: row) as AnyObject).object(forKey: "Name") as! String
                return str
            }
        }
        else if fromWhere == "filterPoster"
        {
            if objFilterPoster.txtTemp == objFilterPoster.txtCategory
            {
                let str: String = (arrOfPicker.object(at: row) as AnyObject).object(forKey: "Path") as! String
                return str
            }
            else
            {
                let str: String = (arrOfPicker.object(at: row) as AnyObject).object(forKey: "Name") as! String
                return str
            }
        }
        else
        {
            let str: String = (arrOfPicker.object(at: row) as AnyObject).object(forKey: "Name") as! String
            return str
        }
    }
}
