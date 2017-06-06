//
//  loginClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/20/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit

class loginClass: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextFieldDelegate,BSKeyboardControlsDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var scrLogin: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var txtEmail: paddingTextField!
    @IBOutlet weak var txtPassword: paddingTextField!
    @IBOutlet weak var btnTerms: UIButton!
    
    let dictSocial: NSMutableDictionary = NSMutableDictionary()
    
    
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let fields: [AnyObject] = [txtEmail,txtPassword]
        self.keyboardControls = BSKeyboardControls(fields: fields)
        self.keyboardControls.delegate = self
        btnTerms.tintColor = UIColor.white
        let signIn = GIDSignIn.sharedInstance()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        signIn?.shouldFetchBasicProfile = true
        signIn?.clientID = Google_Client_ID
        signIn?.scopes = ["profile", "email"]
        signIn?.delegate = self
        signIn?.uiDelegate = self
        if API.getRole() == "2"
        {
            txtEmail.text = "ravibgandhi@gmail.com"
            txtPassword.text = "123456"
        }
        else
        {
            txtEmail.text = "workingbeez.live@gmail.com"
            txtPassword.text = "123456"
        }
        txtEmail.delegate = self
        txtPassword.delegate = self
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnBack(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFacebook(_ sender: Any)
    {
        if btnTerms.isSelected == false
        {
            custObj.alertMessage("Please accept the Terms and Privacy Policy")
            return
        }
        API.setRegType(type: "1")
        API.setLoginType(type: "1")
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logIn(withReadPermissions: ["email"], handler: { (result, error) -> Void in
            if (error == nil)
            {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.isCancelled
                {
                    self.custObj.alertMessage("Please authorise to login with facebook")
                }
                else if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
                else
                {
                    self.custObj.alertMessage("You cancel facbook login")
                }
            }
            else
            {
                self.custObj.alertMessage(error?.localizedDescription)
            }
        })
    }
    @IBAction func btnGoogle(_ sender: Any)
    {
        if btnTerms.isSelected == false
        {
            custObj.alertMessage("Please accept the Terms and Privacy Policy")
            return
        }
        API.setRegType(type: "2")
        API.setLoginType(type: "2")
        
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func btnSignIn(_ sender: Any)
    {
        if txtEmail.text == ""
        {
            custObj.alertMessage("Please enter your email ID")
            return
        }
        if txtPassword.text == ""
        {
            custObj.alertMessage("Please enter your password")
            return
        }
        API.setLoginType(type: "4")
        API.setRegType(type: "4")
        loginAPI()
    }
    @IBAction func btnForgotPwd(_ sender: Any)
    {
        let obj: forgotPwdClass = self.storyboard?.instantiateViewController(withIdentifier: "forgotPwdClass") as! forgotPwdClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnRegister(_ sender: Any)
    {
        if btnTerms.isSelected == false
        {
            custObj.alertMessage("Please accept the Terms and Privacy Policy")
            return
        }
        API.setRegType(type: "4")
        API.setLoginType(type: "4")
        digitVerify()
        
//        if API.getRole() == "2"
//        {
//            let obj: regPosterGInfo = self.storyboard?.instantiateViewController(withIdentifier: "regPosterGInfo") as! regPosterGInfo
//            obj.socialDict = self.dictSocial
//            obj.strMobile = "223232"
//            self.navigationController!.pushViewController(obj, animated: true)
//        }
//        else
//        {
//            let obj: regSeekerGInfo = self.storyboard?.instantiateViewController(withIdentifier: "regSeekerGInfo") as! regSeekerGInfo
//            obj.socialDict = self.dictSocial
//            obj.strMobile = "2323245454"
//            self.navigationController!.pushViewController(obj, animated: true)
//        }
    }
    @IBAction func btnTerms(_ sender: Any)
    {
        btnTerms.isSelected = !btnTerms.isSelected
    }
    @IBAction func btnPrivacy(_ sender: Any)
    {
        let obj: webViewClass = self.storyboard?.instantiateViewController(withIdentifier: "webViewClass") as! webViewClass
        obj.strNavTitle = "Privacy Policy"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnTermsAndCondition(_ sender: Any)
    {
        let obj: webViewClass = self.storyboard?.instantiateViewController(withIdentifier: "webViewClass") as! webViewClass
        obj.strNavTitle = "Terms"
        self.navigationController!.pushViewController(obj, animated: true)
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
    //MARK:- Facebook
    //MARK:- facebook Delegate
    func getFBUserData()
    {
        custObj.showSVHud("Loading")
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    print(result ?? 0)
                    let dict: NSDictionary = result as! NSDictionary
                    self.dictSocial.setValue(dict.object(forKey: "id") as! String, forKey: "id")
                    self.dictSocial.setValue(dict.object(forKey: "email") as! String, forKey: "email")
                    self.dictSocial.setValue(dict.object(forKey: "first_name"), forKey: "FirstName")
                    self.dictSocial.setValue(dict.object(forKey: "last_name"), forKey: "LastName")
                    let strImageUrl : String = ((dict.object(forKey: "picture") as AnyObject).object(forKey:"data")as AnyObject).object(forKey:"url") as! String
                    self.dictSocial.setValue(strImageUrl, forKey: "ProfilePic")
                    print(self.dictSocial)
                    self.custObj.hideSVHud()
                    self.loginAPI()
                }
                else
                {
                    self.custObj.hideSVHud()
                    self.custObj.alertMessage(error?.localizedDescription)
                }
            })
        }
    }
    //MARK:- Google Plus Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        custObj.hideSVHud()
        if (error != nil)
        {
            custObj.alertMessage("Error to login with google! please try again later")
        }
        else
        {
            dictSocial.setValue(user.userID, forKey: "id")
            dictSocial.setValue(user.profile.email, forKey: "email")
            dictSocial.setValue(user.profile.name, forKey: "FirstName")
            dictSocial.setValue(user.profile.givenName, forKey: "LastName")
            dictSocial.setValue(String(format:"%@",user.profile.imageURL(withDimension: 500) as CVarArg), forKey: "ProfilePic")
            print(dictSocial)
            loginAPI()
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
    {
        print("disconnected")
    }
    
    //MARK:- Call API
    func loginAPI()
    {
        view.endEditing(true)
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceKey")
        parameter.setValue(API.getRole(), forKey: "LoginUserType")
        parameter.setValue(API.getLoginType(), forKey: "LoginType")
        parameter.setValue("1", forKey: "DeviceType")
        
        if API.getLoginType() == "1"
        {
            parameter.setValue(dictSocial.object(forKey: "id"), forKey: "SocielID")
            parameter.setValue(dictSocial.object(forKey: "email"), forKey: "UserName")
            parameter.setValue("", forKey: "Password")
        }
        else if API.getLoginType() == "2"
        {
            parameter.setValue(dictSocial.object(forKey: "id"), forKey: "SocielID")
            parameter.setValue(dictSocial.object(forKey: "email"), forKey: "UserName")
            parameter.setValue("", forKey: "Password")
        }
        else
        {
            parameter.setValue("", forKey: "SocielID")
            parameter.setValue(txtEmail.text, forKey: "UserName")
            parameter.setValue(txtPassword.text, forKey: "Password")
            
        }
        
        print(parameter)
        API.callApiPOST(strUrl: API_LOGIN,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let firstObj: NSArray = response.object(forKey: "Data") as! NSArray
                let result: NSDictionary = firstObj.object(at: 0) as! NSDictionary
                let dictData: NSMutableDictionary = NSMutableDictionary.init(dictionary: result)
                //let dictData: NSMutableDictionary = self.custObj.dictionaryByReplacingNulls(withStrings:result.mutableCopy() as! NSMutableDictionary)

                API.setXMPPUSER(type: dictData.object(forKey: JID) as! String)
                API.setXMPPPWD(type: dictData.object(forKey: "JPassword") as! String)
                API.setLoggedUserData(dict: dictData)
                API.setUserId(user_id: dictData.object(forKey: "UserID") as! String)
                API.setIsLogin(type: true)
                if API.getRole() == "2"
                {
                    let dashboard: dashboardPoster = self.storyboard!.instantiateViewController(withIdentifier: "dashboardPoster") as! dashboardPoster
                    let homeNavigation = UINavigationController(rootViewController: dashboard)
                    let window = UIApplication.shared.delegate!.window!!
                    window.rootViewController = homeNavigation
                    UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                }
                else
                {
                    let dashboard: dashboardSeeker = self.storyboard!.instantiateViewController(withIdentifier: "dashboardSeeker") as! dashboardSeeker
                    let homeNavigation = UINavigationController(rootViewController: dashboard)
                    let window = UIApplication.shared.delegate!.window!!
                    window.rootViewController = homeNavigation
                    UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                }
            }
            else if response.object(forKey: "ReturnCode") as! String == "10"
            {
                self.digitVerify()
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
    
    //MARK:- Digit
    func digitVerify()
    {
        let digits = Digits.sharedInstance()
        digits.logOut()
        let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
        configuration?.appearance = DGTAppearance()
        configuration?.appearance.backgroundColor = UIColor.white
        configuration?.appearance.accentColor = API.themeColorBlue()
        configuration?.appearance.headerFont = UIFont.init(name: font_openSans_regular, size: 14)
        configuration?.appearance.bodyFont = UIFont.init(name: font_openSans_regular, size: 14)
        configuration?.appearance.labelFont = UIFont.init(name: font_openSans_regular, size: 14)
        //configuration?.phoneNumber = "+61"
        // Start the authentication flow with the custom appearance. Nil parameters for default values.
        digits.authenticate(with: nil, configuration:configuration!) { (session, error) in
            // Inspect session/error objects
            
            if session != nil
            {
                if API.getRole() == "2"
                {
                    let obj: regPosterGInfo = self.storyboard?.instantiateViewController(withIdentifier: "regPosterGInfo") as! regPosterGInfo
                    obj.socialDict = self.dictSocial
                    obj.strMobile = (session?.phoneNumber)!
                    self.navigationController!.pushViewController(obj, animated: true)
                }
                else
                {
                    let obj: regSeekerGInfo = self.storyboard?.instantiateViewController(withIdentifier: "regSeekerGInfo") as! regSeekerGInfo
                    obj.socialDict = self.dictSocial
                    obj.strMobile = (session?.phoneNumber)!
                    self.navigationController!.pushViewController(obj, animated: true)
                }
            }
        }
    }
}
