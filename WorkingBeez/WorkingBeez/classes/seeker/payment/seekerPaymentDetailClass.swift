//
//  seekerPaymentDetailClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/6/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class seekerPaymentDetailClass: UIViewController,BSKeyboardControlsDelegate,UITextFieldDelegate,UIWebViewDelegate
{
    @IBOutlet weak var scrlSeekerPaymentDetail: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var txtDCNameOnCard: UITextField!
    @IBOutlet weak var txtDCCardNumber: UITextField!
    @IBOutlet weak var txtDCExpiryDate: UITextField!
    @IBOutlet weak var txtDCCVV: UITextField!
    
    @IBOutlet weak var txtBAccountNumber: UITextField!
    @IBOutlet weak var txtBAccountHolderName: UITextField!
    @IBOutlet weak var txtBBankName: UITextField!
    @IBOutlet weak var txtBRoutingNumber: UITextField!
    @IBOutlet weak var txtBBSB: UITextField!
    @IBOutlet weak var btnDCDefault: cButton!
    @IBOutlet weak var btnBankDefault: cButton!
    @IBOutlet weak var web: UIWebView!
    
    var dictStripe: NSDictionary!
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    let custObj: customClassViewController = customClassViewController()
    override func viewDidLoad()
    {
        super.viewDidLoad()

        web.delegate = self
        view.backgroundColor = API.appBackgroundColor()
        
        txtDCNameOnCard.delegate = self
        txtDCCardNumber.delegate = self
        txtDCExpiryDate.delegate = self
        txtDCCVV.delegate = self
        txtBAccountHolderName.delegate = self
        txtBAccountNumber.delegate = self
        txtBBankName.delegate = self
        txtBRoutingNumber.delegate = self
        txtBBSB.delegate = self
        
        let fields: [AnyObject] = [txtDCNameOnCard,txtDCCardNumber,txtDCExpiryDate,txtDCCVV,txtBAccountNumber,txtBAccountHolderName,txtBBankName, txtBRoutingNumber, txtBBSB]
        self.keyboardControls = BSKeyboardControls(fields: fields)
        self.keyboardControls.delegate = self
        
        scrlSeekerPaymentDetail.contentSizeToFit()
        btnDCDefault.tintColor = API.themeColorPink()
        btnBankDefault.tintColor = API.themeColorPink()
    
        dictUserData = NSMutableDictionary.init(dictionary: API.getLoggedUserData())
        /*if dictUserData.object(forKey: "IsPaymentVerify") as! Bool == true
        {
            //web.isHidden = true
        }
        else
        {
            let url = NSURL (string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_AJ1xeooHsu5J3HwPeo6O7o9opibYzd44&scope=read_write")
            let requestObj = NSURLRequest(url: url! as URL);
            web.loadRequest(requestObj as URLRequest)
            web.delegate = self
            //scrlSeekerPaymentDetail.isHidden = true
        }*/
        scrlSeekerPaymentDetail.isHidden = true
        web.delegate = self
        if dictUserData.object(forKey: "IsPaymentVerify") as! Bool == true
        {
            let url = NSURL (string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_AJ1xeooHsu5J3HwPeo6O7o9opibYzd44")// - test Mode
            //let url = NSURL (string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_AJ1xPryNU6srzu2DG0SIZkw82zJi2ZMa")  // Live Mode
            let requestObj = NSURLRequest(url: url! as URL)
            web.loadRequest(requestObj as URLRequest)
        }
        else
        {
            
            let url = NSURL (string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_AJ1xeooHsu5J3HwPeo6O7o9opibYzd44&scope=read_write")// - Test mode
            //let url = NSURL (string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_AJ1xPryNU6srzu2DG0SIZkw82zJi2ZMa&scope=read_write") //  Live mode
            let requestObj = NSURLRequest(url: url! as URL)
            web.loadRequest(requestObj as URLRequest)
        }
        web.isHidden = false
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
 
    @IBAction func btnSaveDebitCard(_ sender: Any)
    {
        custObj.alertMessage("Debit Card Saved")
    }
    
    @IBAction func btnSaveBank(_ sender: Any)
    {
        custObj.alertMessage("Bank Saved")
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
        if txtDCExpiryDate == textField
        {
//            view.endEditing(true)
//            let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
//            obj.objSeeker = self
//            obj.fromWhere = "seekerReg"
//            obj.strForDateOrTime = "date"
//            self.present(obj, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    //MARK:- Webview delegate
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        custObj.showSVHud("Loading")
        return true
    }
    public func webViewDidStartLoad(_ webView: UIWebView)
    {
        
    }
    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        custObj.hideSVHud()
        print(webView.request?.url?.absoluteString ?? 0)
        let str: String = webView.request!.url!.absoluteString
        if str.contains("access_denied") || str.contains("error")
        {
            
        }
        else if str.contains(".php")
        {
            //http://workingbeez.live/stripe.php?scope=read_write&code=ac_AXoXyjTneILJYYXfg9w95pWfhImrEvhB
            //NSString *res = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('json').innerHTML"];
            let strResponse: String = (webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")!)
            dictStripe = convertToDictionary(text: strResponse) as NSDictionary!
            print(dictStripe)
            if let val = dictStripe["error"]
            {
                
            }
            else if let val = dictStripe["access_token"]
            {
                if dictStripe["access_token"] as! String != ""
                {
                    saveBankcDetail()
                }
            }
        }
    }
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        custObj.hideSVHud()
        custObj.alertMessage(error.localizedDescription)
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //MARK:- Call API
    func saveBankcDetail()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(dictStripe.object(forKey: "access_token"), forKey: "AccessToken")
        parameter.setValue(dictStripe.object(forKey: "livemode"), forKey: "LiveMde")
        parameter.setValue(dictStripe.object(forKey: "refresh_token"), forKey: "RefreshToken")
        parameter.setValue(dictStripe.object(forKey: "token_type"), forKey: "TokenType")
        parameter.setValue(dictStripe.object(forKey: "stripe_publishable_key"), forKey: "StripePublishableKey")
        parameter.setValue(dictStripe.object(forKey: "stripe_user_id"), forKey: "StripeUserID")
        parameter.setValue(dictStripe.object(forKey: "scope"), forKey: "Scope")
        print(parameter)
        API.callApiPOST(strUrl: API_SaveSeekerStripeInfomation,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.web.isHidden = true
                self.dictUserData.setValue(true, forKey: "IsPaymentVerify")
                API.setLoggedUserData(dict: self.dictUserData)
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
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
