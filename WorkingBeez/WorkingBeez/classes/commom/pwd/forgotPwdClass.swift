//
//  forgotPwdClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/4/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class forgotPwdClass: UIViewController
{
    //MARK:- Outlet
    @IBOutlet weak var txtEmail: paddingTextField!
    
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        if txtEmail.text == ""
        {
            custObj.alertMessage("Please enter your register Email ID")
            return
        }
        if validateEmail(enteredEmail: txtEmail.text!) == false
        {
            custObj.alertMessage("Please enter valid Email ID")
            return
        }
        forgotPwd()
    }
    
    //MARK:- Call API
    func forgotPwd()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(txtEmail.text, forKey: "Email")
        print(parameter)
        API.callApiPOST(strUrl: API_ForgotPassword,parameter: parameter, success: { (response) in
            
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
    
    //MARK:- Email Validation
    func validateEmail(enteredEmail:String) -> Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}
