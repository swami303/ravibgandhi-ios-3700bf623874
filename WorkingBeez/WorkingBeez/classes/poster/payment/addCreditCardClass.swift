//
//  addCreditCardClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/12/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class addCreditCardClass: UIViewController, UITextFieldDelegate,BSKeyboardControlsDelegate
{
    @IBOutlet weak var scrlAddCreditCard: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var btnSaveCard: cButton!

    @IBOutlet weak var btnMarkAsDefaultOutlet: UIButton!

    @IBOutlet weak var txtNameOnCard: UITextField!
    @IBOutlet weak var txtCardNmuber: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCVVNumber: UITextField!
    
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    var fromWhere: String = ""
    var objCardList: posterPaymentCardListClass!
    var objPostJob: rosterDetailClass!
    var strMonth: String = ""
    var strYear: String = ""
    var isDefault: Bool = false
    let custObj: customClassViewController = customClassViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        dictUserData = NSMutableDictionary.init(dictionary: API.getLoggedUserData())
        view.backgroundColor = API.appBackgroundColor()
        btnMarkAsDefaultOutlet.isSelected = false
        btnMarkAsDefaultOutlet.tintColor = API.themeColorBlue()
        
        txtNameOnCard.delegate = self
        txtCardNmuber.delegate = self
        txtExpiryDate.delegate = self
        txtCVVNumber.delegate = self
        
        let fields: [AnyObject]
        fields = [txtNameOnCard,txtCardNmuber,txtExpiryDate,txtCVVNumber]
        
        self.keyboardControls = BSKeyboardControls(fields: fields)
        self.keyboardControls.delegate = self
        scrlAddCreditCard.contentSizeToFit()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnSaveCardAction(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if(txtNameOnCard.text == "")
        {
            custObj.alertMessage("Please enter Name available on Card")
            return
        }
        else if(txtCardNmuber.text == "")
        {
            custObj.alertMessage("Please enter Card Number available on Card")
            return
        }
        else if (txtCardNmuber.text?.length)! < 16
        {
            custObj.alertMessage("Please enter valid card number")
            return
        }
        else if(txtExpiryDate.text == "")
        {
            custObj.alertMessage("Please select Expiry Month and Year")
            return
        }

        else if(txtCVVNumber.text == "")
        {
            custObj.alertMessage("Please enter CVV Number available on Card")
            return
        }
        else if (txtCardNmuber.text?.length)! < 3
        {
            custObj.alertMessage("Please enter valid CVV number")
            return
        }
        saveCard()
    }
    
    @IBAction func btnmarkAsDefaultAction(_ sender: Any)
    {
        if isDefault == true
        {
            isDefault = false
        }
        else
        {
            isDefault = true
        }
        btnMarkAsDefaultOutlet.isSelected = !btnMarkAsDefaultOutlet.isSelected
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
    
    // MARK: - Textfield Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.keyboardControls!.activeField = textField
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if(textField == txtExpiryDate)
        {
            self.view.endEditing(true)
            let obj : expiryMonthAndYearPickerClass = self.storyboard?.instantiateViewController(withIdentifier: "expiryMonthAndYearPickerClass") as! expiryMonthAndYearPickerClass
            obj.fromWhere = "creditCard"
            obj.objAddCreditCard = self
            self.present(obj, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }

    //MARK:- Call API
    func saveCard()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(txtCardNmuber.text, forKey: "Number")
        parameter.setValue(txtNameOnCard.text, forKey: "Name")
        parameter.setValue(txtCVVNumber.text, forKey: "CVC")
        parameter.setValue(strMonth, forKey: "Month")
        parameter.setValue(strYear, forKey: "Year")
        parameter.setValue(isDefault, forKey: "IsDefault")
        print(parameter)
        API.callApiPOST(strUrl: API_SaveCard,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                if self.fromWhere == "cardList"
                {
                    self.objCardList.getCardList()
                }
                else if self.fromWhere == "postJob"
                {
                    self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                    self.dictUserData.setValue(true, forKey: "IsPaymentVerify")
                    API.setLoggedUserData(dict: self.dictUserData)
                }
                _ = self.navigationController?.popViewController(animated: true)
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
