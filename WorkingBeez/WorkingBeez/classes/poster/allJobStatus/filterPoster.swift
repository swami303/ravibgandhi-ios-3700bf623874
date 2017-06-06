//
//  filterPoster.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/11/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class filterPoster: UIViewController,UITextFieldDelegate,BSKeyboardControlsDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var txtCategory: paddingTextField!
    @IBOutlet weak var txtJobTitle: paddingTextField!
    @IBOutlet weak var txtFromKm: paddingTextField!
    @IBOutlet weak var txtToKm: paddingTextField!
    @IBOutlet weak var txtFromRate: paddingTextField!
    @IBOutlet weak var txtToRating: paddingTextField!
    @IBOutlet weak var txtFromYr: paddingTextField!
    @IBOutlet weak var txtToYr: paddingTextField!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var scrFilter: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    
    var categotyID: Int = -1
    var jobTitleID: Int = -1
    
    var distanceFrom: String = "-1"
    var distanceTo: String = "-1"
    
    var ratingFrom: String = "-1"
    var ratingTo: String = "-1"
    
    var expFrom: String = "-1"
    var expTo: String = "-1"
    
    var isVehicle: String = "-1"
    
    
    var deleObj: AppDelegate!
    var arrOfJobTitle: NSMutableArray = NSMutableArray()
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    var txtTemp: UITextField!
    var objPoster: allJobStatusPoster!
    var fromWhere: String = ""
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        let fields: [AnyObject] = [txtCategory,txtJobTitle,txtFromKm,txtToKm,txtFromRate,txtToRating,txtFromYr,txtToYr]
        self.keyboardControls = BSKeyboardControls(fields: fields)
        self.keyboardControls.delegate = self
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        txtCategory.delegate = self
        txtJobTitle.delegate = self
        txtFromKm.delegate = self
        txtToKm.delegate = self
        
        txtFromRate.delegate = self
        txtToRating.delegate = self
        txtFromYr.delegate = self
        txtToYr.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnCancel(_ sender: Any)
    {
        API.resetFilter()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadJobsPoster"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnApply(_ sender: Any)
    {
        distanceFrom = txtFromKm.text!
        distanceTo = txtToKm.text!
        if txtFromKm.text == ""
        {
            distanceFrom = "-1"
        }
        if txtToKm.text == ""
        {
            distanceTo = "-1"
        }
        
        ratingFrom = txtFromRate.text!
        ratingTo = txtToRating.text!
        if txtFromRate.text == ""
        {
            ratingFrom = "-1"
        }
        if txtToRating.text == ""
        {
            ratingTo = "-1"
        }
        
        expFrom = txtFromYr.text!
        expTo = txtToYr.text!
        if txtFromYr.text == ""
        {
            expFrom = "-1"
        }
        if txtToYr.text == ""
        {
            expTo = "-1"
        }
        if expFrom != "-1"
        {
            var FromMonth: Int = Int(expFrom)!
            FromMonth = FromMonth * 12
            expFrom = String(format: "%d", FromMonth)
        }
        if expTo != "-1"
        {
            var ToMonth: Int = Int(expTo)!
            ToMonth = ToMonth * 12
            expTo = String(format: "%d", ToMonth)
        }
        
        if btnYes.isSelected == true
        {
            isVehicle = "1"
        }
        else
        {
            isVehicle = "0"
        }
        
        deleObj.dictFilter.setValue(String(format:"%d",categotyID), forKey: "CategoryID")
        deleObj.dictFilter.setValue(String(format:"%d",jobTitleID), forKey: "TitleID")
        deleObj.dictFilter.setValue(ratingFrom, forKey: "RatingFrom")
        deleObj.dictFilter.setValue(ratingTo, forKey: "RatingTo")
        deleObj.dictFilter.setValue(expFrom, forKey: "ExpFrom")
        deleObj.dictFilter.setValue(expTo, forKey: "ExpTo")
        deleObj.dictFilter.setValue(isVehicle, forKey: "IsVehicle")
        deleObj.dictFilter.setValue(distanceFrom, forKey: "DistanceFrom")
        deleObj.dictFilter.setValue(distanceTo, forKey: "DistanceTo")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadJobsPoster"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnYes(_ sender: Any)
    {
        btnYes.isSelected = true
        btnNo.isSelected = false
    }
    @IBAction func btnNo(_ sender: Any)
    {
        btnYes.isSelected = false
        btnNo.isSelected = true
    }
    // MARK: - BSKeyboardControls Delegate Methods
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls)
    {
        self.dismissKeyboard()
    }
    // MARK: - Textfield Delaget Methods
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.keyboardControls!.activeField = textField
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        txtTemp = textField
        if textField == txtCategory
        {
            view.endEditing(true)
            let arr: NSArray = dictUserData.object(forKey: "PosterCategory") as! NSArray
            let obj: pickerClass = self.storyboard?.instantiateViewController(withIdentifier: "pickerClass") as! pickerClass
            obj.objFilterPoster = self
            obj.fromWhere = "filterPoster"
            obj.arrOfPicker = NSMutableArray.init(array: arr)
            self.present(obj, animated: true, completion: nil)
            return false
        }
        if textField == txtJobTitle
        {
            if txtCategory.text == ""
            {
                custObj.alertMessage("Please select category first")
                return false
            }
            if arrOfJobTitle.count == 0
            {
                custObj.alertMessage("Job title not available")
                return false
            }
            if categotyID == 0
            {
                custObj.alertMessage("Job title not available in other category")
                return false
            }
            view.endEditing(true)
            let obj: pickerClass = self.storyboard?.instantiateViewController(withIdentifier: "pickerClass") as! pickerClass
            obj.objFilterPoster = self
            obj.fromWhere = "filterPoster"
            obj.arrOfPicker = arrOfJobTitle
            self.present(obj, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    //MARK:- Call API
    func getAllJobTitle()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(categotyID, forKey: "CategoryID")
        print(parameter)
        API.callApiPOST(strUrl: API_GET_ALL_JOB_TITLE,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfJobTitle = NSMutableArray.init(array: arr)
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
