//
//  changePwdClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/4/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class changePwdClass: UIViewController,UITextFieldDelegate,BSKeyboardControlsDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var txtCurrentpwd: paddingTextField!
    @IBOutlet weak var txtNewPwd: paddingTextField!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let fields: [AnyObject] = [txtCurrentpwd,txtNewPwd]
        self.keyboardControls = BSKeyboardControls(fields: fields)
        self.keyboardControls.delegate = self
        
        txtNewPwd.delegate = self
        txtCurrentpwd.delegate = self
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnChangePwd(_ sender: Any)
    {
        if txtCurrentpwd.text == ""
        {
            custObj.alertMessage("Please enter your current password")
            return
        }
        if txtNewPwd.text == ""
        {
            custObj.alertMessage("Please enter new password")
            return
        }
        if (txtNewPwd.text?.length)! < 6
        {
            custObj.alertMessage("Password length must be greater than or equal to 6 character")
            return
        }
        if txtNewPwd.text == txtCurrentpwd.text
        {
            custObj.alertMessage("This is your current password! Please try with different password")
            return
        }
        ChangePwd()
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
        return true
    }
    
    //MARK:- Call API
    func ChangePwd()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(txtNewPwd.text, forKey: "NewPass")
        parameter.setValue(txtCurrentpwd.text, forKey: "OldPass")
        print(parameter)
        API.callApiPOST(strUrl: API_ChangePassword,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                _ = self.navigationController?.popViewController(animated: true)
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
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
