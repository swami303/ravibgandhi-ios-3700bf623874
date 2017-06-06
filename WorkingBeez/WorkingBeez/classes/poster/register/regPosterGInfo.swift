//
//  regPosterGInfo.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/21/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class regPosterGInfo: UIViewController,BSKeyboardControlsDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var scrRegsister: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var imgBusinessPhoto: cImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtOfbusiness: UITextField!
    @IBOutlet weak var txtABN: UITextField!
    @IBOutlet weak var txtWebsiteUrl: UITextField!
    @IBOutlet weak var txtLocation: paddingTextField!
    @IBOutlet weak var tvLocation: cTextView!
    @IBOutlet weak var viewGenInfo: cView!
    @IBOutlet weak var viewAddInfo: cView!
    @IBOutlet weak var tvAbout: placeholderTextView!
    @IBOutlet weak var lblAboutCharLeft: UILabel!
    @IBOutlet weak var lblAddiInfo: UILabel!
    @IBOutlet weak var btnAlreadAccount: UIButton!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var lblUploadPic: UILabel!

    var dictABN: NSDictionary!
    var strMobile: String = ""
    var strLat: String = ""
    var strLong: String = ""
    var mainManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    var arrOfLocation: NSMutableArray = NSMutableArray()
    var deleObj: AppDelegate!
    var isImage: Int = 0
    var socialDict: NSMutableDictionary = NSMutableDictionary()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        deleObj = UIApplication.shared.delegate as! AppDelegate!
        self.navigationController?.navigationBar.isTranslucent = false
        for case let txt as UITextField in viewGenInfo.subviews
        {
            txt.delegate = self
        }
        for case let txt as UITextField in viewAddInfo.subviews
        {
            txt.delegate = self
        }
        tvAbout.delegate = self
        
        
        tvAbout.layer.borderColor = API.dividerColor().cgColor
        tvAbout.layer.borderWidth = 1
        
        tvAbout.layer.cornerRadius = 5
        tvAbout.clipsToBounds = true
        
        deleObj.dictPosterReg = NSMutableDictionary()
        deleObj.dictPosterReg.setValue("", forKey: "ProfilePic")
        deleObj.dictPosterReg.setValue("", forKey: "SocielID")
        if API.getRegType() != "4"
        {
            let fields: [AnyObject] = [txtFirstName,txtLastName,txtEmail,txtABN,txtOfbusiness,txtWebsiteUrl,tvAbout]
            self.keyboardControls = BSKeyboardControls(fields: fields)
            self.keyboardControls.delegate = self
            viewGenInfo.frame = CGRect.init(x: viewGenInfo.frame.origin.x, y: viewGenInfo.frame.origin.y, width: viewGenInfo.frame.size.width, height: viewGenInfo.frame.size.height - txtPassword.frame.size.height - 16)
            lblAddiInfo.frame = CGRect.init(x: lblAddiInfo.frame.origin.x, y: viewGenInfo.frame.origin.y + viewGenInfo.frame.size.height + 8, width: lblAddiInfo.frame.size.width, height: lblAddiInfo.frame.size.height)
            viewAddInfo.frame = CGRect.init(x: viewAddInfo.frame.origin.x, y: lblAddiInfo.frame.origin.y + lblAddiInfo.frame.size.height + 8, width: viewAddInfo.frame.size.width, height: viewAddInfo.frame.size.height)
            btnAlreadAccount.frame = CGRect.init(x: btnAlreadAccount.frame.origin.x, y: viewAddInfo.frame.origin.y + viewAddInfo.frame.size.height + 12, width: btnAlreadAccount.frame.size.width, height: btnAlreadAccount.frame.size.height)
            
            txtEmail.text = socialDict.object(forKey: "email") as? String
            txtFirstName.text = socialDict.object(forKey: "FirstName") as? String
            txtLastName.text = socialDict.object(forKey: "LastName") as? String
            let strImageUrl = socialDict.object(forKey: "ProfilePic") as! String
            imgBusinessPhoto.sd_setImage(with: NSURL.init(string: strImageUrl) as URL!, placeholderImage: UIImage(named: "userPlaceholder"))
            deleObj.dictPosterReg.setValue(strImageUrl, forKey: "ProfilePic")
            deleObj.dictPosterReg.setValue(socialDict.object(forKey: "id"), forKey: "SocielID")
        }
        else
        {
            let fields: [AnyObject] = [txtFirstName,txtLastName,txtEmail,txtPassword,txtABN,txtOfbusiness,txtWebsiteUrl,tvAbout]
            self.keyboardControls = BSKeyboardControls(fields: fields)
            self.keyboardControls.delegate = self
        }
        scrRegsister.contentSizeToFit()
        
        tblLocation.delegate = self
        tblLocation.dataSource = self
        
        tblLocation.isHidden = true
        tblLocation.layer.cornerRadius = 15
        tblLocation.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        scrRegsister.contentSizeToFit()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        imgBusinessPhoto.isUserInteractionEnabled = true
        imgBusinessPhoto.addGestureRecognizer(tapGestureRecognizer)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnAlreadyAccount(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: Any)
    {
        if txtFirstName.text == ""
        {
            custObj.alertMessage("Please enter first name")
            return
        }
        if txtEmail.text == ""
        {
            custObj.alertMessage("Please enter email ID")
            return
        }
        if validateEmail(enteredEmail: txtEmail.text!) == false
        {
            custObj.alertMessage("Please enter valid Email ID")
            return
        }
        if API.getRegType() == "4"
        {
            if txtPassword.text == ""
            {
                custObj.alertMessage("Please enter password")
                return
            }
            if (txtPassword.text?.length)! < 6
            {
                custObj.alertMessage("Password length must be greater than or equal to 6 character")
                return
            }
        }
//        if txtABN.text != "" && txtOfbusiness.text == ""
//        {
//            custObj.alertMessage("Please enter valid ABN number")
//            return
//        }
//        if txtWebsiteUrl.text != ""
//        {
//            if verifyUrl(urlString: txtWebsiteUrl.text) == false
//            {
//                custObj.alertMessage("Please enter valid website URL")
//                return
//            }
//        }
        if tvAbout.text == ""
        {
            custObj.alertMessage("Please enter about you or your business")
            return
        }
        if tvLocation.text == "" || strLat == "" || strLong == ""
        {
            custObj.alertMessage("Please select your location")
            return
        }
        
        
        deleObj.dictPosterReg.setValue(API.getToken(), forKey: "Token")
        deleObj.dictPosterReg.setValue(API.getDeviceToken(), forKey: "DeviceID")
        deleObj.dictPosterReg.setValue(txtFirstName.text, forKey: "FirstName")
        deleObj.dictPosterReg.setValue(txtLastName.text, forKey: "LastName")
        deleObj.dictPosterReg.setValue(txtEmail.text, forKey: "EmailID")
        deleObj.dictPosterReg.setValue(txtPassword.text, forKey: "Password")
        deleObj.dictPosterReg.setValue(txtABN.text, forKey: "ABN")
        deleObj.dictPosterReg.setValue(txtOfbusiness.text, forKey: "NameOfBusiness")
        deleObj.dictPosterReg.setValue(strLat, forKey: "Latitude")
        deleObj.dictPosterReg.setValue(strLong, forKey: "Longitude")
        deleObj.dictPosterReg.setValue(tvLocation.text, forKey: "LocationName")
        
        deleObj.dictPosterReg.setValue(tvAbout.text, forKey: "AboutYourBusiness")
        deleObj.dictPosterReg.setValue(txtWebsiteUrl.text, forKey: "WebSite")
        
        deleObj.dictPosterReg.setValue(API.getRegType(), forKey: "RegistrationType")
        deleObj.dictPosterReg.setValue("1", forKey: "DeviceType")
        deleObj.dictPosterReg.setValue(strMobile, forKey: "MobileNo")
        
        checkExisting()
    }
    
    //MARK:- image Delegate
    func imageTapped(img: AnyObject)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
        })
        
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(gallery)
        optionMenu.addAction(camera)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.navigationController!.dismiss(animated: true, completion: { _ in })
        let image: UIImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        imgBusinessPhoto.image = image;
        isImage = 1
        deleObj.dictPosterReg.setValue(API.encodeBase64FromData(UIImageJPEGRepresentation(imgBusinessPhoto.image!, 1.0)!), forKey: "ProfilePic")
        lblUploadPic.isHidden = true
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.navigationController!.dismiss(animated: true, completion: { _ in })
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
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField == txtABN
        {
            if textField.text != ""
            {
                if custObj.validateABN(txtABN.text) == true
                {
                    self.validateABNAPI(abnNumber: txtABN.text!)
                }
                else
                {
                    custObj.alertMessage("This ABN is Not Valid")
                    txtABN.text = ""
                    txtOfbusiness.text = ""
                }
            }
            else
            {
                txtOfbusiness.text = ""
            }
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if txtABN == textField
        {
            if string.length != 0
            {
                if !"0123456789".contains(string)
                {
                    return false
                }
            }
        }
        if textField == txtLocation
        {
            var serachText = ""
            if txtLocation.text?.characters.count == 0
            {
                serachText = string
            }
            else if range.location > 0 && range.length == 1 && string.characters.count == 0 {
                serachText = (txtLocation.text?.substring(to: (txtLocation.text?.index((txtLocation.text?.startIndex)!, offsetBy: (txtLocation.text?.characters.count)! - 1))!))!
            }
            else if string.characters.count == 0 && txtLocation.text?.characters.count == 1 {
                serachText = ""
            }
            else if string.characters.count == 0 && (txtLocation.text?.characters.count)! > 1
            {
                serachText = ""
            }
            else
            {
                serachText = (txtLocation.text?.appending(string))!
            }
            getLocation(str: serachText)
        }
        return true
    }
    //MARK:- TextView delegate
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView == tvAbout
        {
            var serachText = ""
            if tvAbout.text?.characters.count == 0
            {
                serachText = text
            }
            else if range.location > 0 && range.length == 1 && text.characters.count == 0 {
                serachText = (tvAbout.text?.substring(to: (tvAbout.text?.index((tvAbout.text?.startIndex)!, offsetBy: (tvAbout.text?.characters.count)! - 1))!))!
            }
            else if text.characters.count == 0 && tvAbout.text?.characters.count == 1 {
                serachText = ""
            }
            else if text.characters.count == 0 && (tvAbout.text?.characters.count)! > 1
            {
                serachText = ""
            }
            else
            {
                serachText = (tvAbout.text?.appending(text))!
            }
            if serachText.length >= 301
            {
                return false
            }
            
            //print(serachText.length)
        }
        return true
    }
    func textViewDidChangeSelection(_ textView: UITextView)
    {
        lblAboutCharLeft.text = String(format: "%d Left", 300 - textView.text.length)
    }
    //MARK:- UITableviewDelegatde
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfLocation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
        cell.imgLocatiobIcon.tintColor = API.blackColor()
        
        let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
        cell.lblLocationName?.text = dd.object(forKey: "description") as? String
        //cell.lblLocationName?.text = (dd.object(forKey: "structured_formatting") as AnyObject).object(forKey:"main_text") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tblLocation.isHidden = true
        let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
        //cell.lblLocationName?.text = dd.object(forKey: "description") as? String
        //cell.lblLocationName?.text = dd.object(forKey: "description") as? String
        tvLocation.text = dd.object(forKey: "description") as? String
        if deleObj.locationForReg == ""
        {
            self.view.endEditing(true)
            getLatLong(str: dd.object(forKey: "description") as! String)
        }
        else
        {
            if (tvLocation.text.lowercased()).contains(deleObj.locationForReg.lowercased())
            {
                self.view.endEditing(true)
                getLatLong(str: dd.object(forKey: "description") as! String)
            }
            else
            {
                custObj.alertMessage(SEVERING_MESSAGE_REG)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 36
    }
    //MARK:- API CALL
    func validateABNAPI(abnNumber : String)
    {
        custObj.showSVHud("Loading")
        var request = URLRequest(url: URL(string: String.init(format: "https://abr.business.gov.au/json/AbnDetails.aspx?abn=%@&guid=92d728e5-3a71-4d47-aeca-4ded28063fb8", abnNumber))!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Entered the completionHandler")
            
            if(err != nil)
            {
                print(err?.localizedDescription as Any)
                self.custObj.alertMessage(ABN_MESSAGE)
                DispatchQueue.main.async {
                    self.txtOfbusiness.text = ""
                }
            }
            else
            {
                var resultString : String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                resultString = resultString.replacingOccurrences(of: "callback(", with: "")
                resultString = String(resultString.characters.dropLast())
                
                if let data = resultString.data(using: String.Encoding.utf8)
                {
                    do
                    {
                        self.dictABN = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary!
                        DispatchQueue.main.async {
                            self.txtOfbusiness.text = self.dictABN.object(forKey: "EntityName") as? String
                        }
                        
                        print(self.dictABN)
                    }
                    catch let error as NSError
                    {
                        print(error)
                        self.custObj.alertMessage(ABN_MESSAGE)
                        DispatchQueue.main.async {
                            self.txtOfbusiness.text = ""
                        }
                    }
                }
            }
            self.custObj.hideSVHud()
            }.resume()
    }
    func checkExisting()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(txtEmail.text, forKey: "Email")
        parameter.setValue(strMobile, forKey: "MobileNo")
        print(parameter)
        API.callApiPOST(strUrl: API_CheckDataExist,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                print(self.deleObj.dictPosterReg)
                let obj: regCategoryClass = self.storyboard?.instantiateViewController(withIdentifier: "regCategoryClass") as! regCategoryClass
                self.navigationController!.pushViewController(obj, animated: true)
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
    func getLocation(str: String)
    {
        if custObj.checkInternet() == false
        {
            return
        }
        
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(GoogleAutocompleteKey, forKey: "key")
        parameter.setValue(str, forKey: "input")
        
        mainManager.operationQueue.cancelAllOperations()
        mainManager = AFHTTPRequestOperationManager(baseURL: URL(string: "https://maps.googleapis.com/maps/api/"))
        mainManager.operationQueue.cancelAllOperations()
        mainManager.get("place/autocomplete/json", parameters: parameter,
                        success: { (op, response) -> Void in
                            
                            let dict: NSDictionary!
                            dict = response as! NSDictionary
                            print(response ?? 0)
                            let aa: NSArray = dict.object(forKey: "predictions") as! NSArray
                            //print(aa)
                            if aa.count != 0
                            {
                                self.tblLocation.isHidden = false
                                self.arrOfLocation = NSMutableArray.init(array: aa)
                            }
                            else
                            {
                                self.tblLocation.isHidden = true
                            }
                            self.tblLocation.reloadData()
        },failure: { (op, fault) -> Void in
            print(op?.error ?? 0)
        })
        
    }
    func getLatLong(str: String)
    {
        if custObj.checkInternet() == false
        {
            return
        }
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(false, forKey: "sensor")
        parameter.setValue(str, forKey: "address")
        var manager: AFHTTPRequestOperationManager!
        manager = AFHTTPRequestOperationManager(baseURL: URL(string: "http://maps.google.com/maps/api/"))
        manager?.get("geocode/json", parameters: parameter,
                     success: { (op, response) -> Void in
                        
                        let dict: NSDictionary!
                        dict = response as! NSDictionary
                        print(dict)
                        if dict.object(forKey: "status") as! String == "OK"
                        {
                            let arrResult: NSArray = dict.object(forKey: "results") as! NSArray
                            if arrResult.count != 0
                            {
                                print((arrResult.object(at: 0) as AnyObject).object(forKey:"formatted_address") ?? "Not found")
                                let dd: NSDictionary = (arrResult.object(at: 0) as AnyObject).object(forKey:"geometry") as! NSDictionary
                                let ddLocation: NSDictionary = dd.object(forKey: "location") as! NSDictionary
                                self.strLat = String(format: "%f", ddLocation.object(forKey: "lat") as! Float)
                                self.strLong = String(format: "%f", ddLocation.object(forKey: "lng") as! Float)
                            }
                        }
                        self.custObj.hideSVHud()
        },failure: { (op, fault) -> Void in
            print(op?.error ?? 0)
            self.custObj.hideSVHud()
        })
        
    }
    //MARK:- Email Validation
    func validateEmail(enteredEmail:String) -> Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //MARK:- Validate URL
    func verifyUrl (urlString: String?) -> Bool
    {
        var strUrl: String = ""
        strUrl = urlString!
        if !strUrl.contains("http://")
        {
            strUrl = "http://" + strUrl
        }
        if let url = NSURL(string: strUrl)
        {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
}
