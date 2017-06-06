//
//  webViewClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/17/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class webViewClass: UIViewController,UITextFieldDelegate,BSKeyboardControlsDelegate,UITextViewDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var scrHelp: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var tvQuery: placeholderTextView!
    @IBOutlet weak var txtJobId: UITextField!
    
    var strNavTitle: String = ""
    var strKey: String = ""
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        self.navigationItem.title = strNavTitle
        scrHelp.isHidden = true
        if strNavTitle == "HELP & SUPPORT"
        {
            scrHelp.isHidden = false
            let fields: [AnyObject] = [txtJobId,tvQuery]
            self.keyboardControls = BSKeyboardControls(fields: fields)
            self.keyboardControls.delegate = self
            txtJobId.delegate = self
            tvQuery.delegate = self
        }
        else if strNavTitle == "Terms"
        {
            if let pdf = Bundle.main.url(forResource: "terms", withExtension: "pdf", subdirectory: nil, localization: nil)
            {
                let req = NSURLRequest(url: pdf)
                webView.loadRequest(req as URLRequest)
            }
        }
        else if strNavTitle == "About"
        {
            if let pdf = Bundle.main.url(forResource: "about", withExtension: "pdf", subdirectory: nil, localization: nil)
            {
                let req = NSURLRequest(url: pdf)
                webView.loadRequest(req as URLRequest)
            }
        }
        else if strNavTitle == "Privacy Policy"
        {
            if let pdf = Bundle.main.url(forResource: "privacy_policy", withExtension: "pdf", subdirectory: nil, localization: nil)
            {
                let req = NSURLRequest(url: pdf)
                webView.loadRequest(req as URLRequest)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnSubmit(_ sender: Any)
    {
        if txtJobId.text == ""
        {
            custObj.alertMessage("Please enter Job ID")
            return
        }
        if tvQuery.text == ""
        {
            custObj.alertMessage("Please enter your query")
            return
        }
        sendQuery()
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
    
    //MARK:- Email Validation
    func validateEmail(enteredEmail:String) -> Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //MARK:- Call API
    func sendQuery()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(txtJobId.text, forKey: "JobID")
        parameter.setValue(tvQuery.text, forKey: "Query")
        parameter.setValue(dictUserData.object(forKey: "EmailID"), forKey: "Email")
        print(parameter)
        API.callApiPOST(strUrl: API_HelpSupport,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.txtJobId.text = ""
                self.tvQuery.text = ""
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
