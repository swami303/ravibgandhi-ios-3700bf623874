//
//  regSeekerGInfo.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/21/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class regSeekerGInfo: UIViewController,BSKeyboardControlsDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource
{

    //MARK:- Outlet
    @IBOutlet weak var scrRegister: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEMail: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtABN: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var tvLocation: cTextView!
    @IBOutlet weak var txtWorkingRange: UITextField!
    @IBOutlet weak var viewContainer: cView!
    @IBOutlet weak var imgUserImage: cImageView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var viewAfterPwd: UIView!
    @IBOutlet weak var btnAlreadyAccount: UIButton!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblUploadPic: UILabel!
    
    var strMobile: String = ""
    var socialDict: NSMutableDictionary = NSMutableDictionary()
    var strLat: String = ""
    var strLong: String = ""
    var mainManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    var arrOfLocation: NSMutableArray = NSMutableArray()
    var deleObj: AppDelegate!
    var isImage: Int = 0
    var dictABN: NSDictionary!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lblCompanyName.text = ""
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        for case let txt as UITextField in viewContainer.subviews
        {
            txt.delegate = self
        }
        for case let txt as UITextField in viewAfterPwd.subviews
        {
            txt.delegate = self
        }
        deleObj.dictSeekerReg = NSMutableDictionary()
        deleObj.dictSeekerReg.setValue("", forKey: "ProfilePic")
        deleObj.dictSeekerReg.setValue("", forKey: "SocielID")
        if API.getRegType() != "4"
        {
            let fields: [AnyObject] = [txtFirstName,txtLastName,txtEMail,txtDOB,txtABN,txtLocation,txtWorkingRange]
            self.keyboardControls = BSKeyboardControls(fields: fields)
            viewAfterPwd.frame = CGRect.init(x: viewAfterPwd.frame.origin.x, y: txtPassword.frame.origin.y, width: viewAfterPwd.frame.size.width, height: viewAfterPwd.frame.size.height)
            viewContainer.frame = CGRect.init(x: viewContainer.frame.origin.x, y: viewContainer.frame.origin.y, width: viewContainer.frame.size.width, height: viewContainer.frame.size.height-44)
            btnAlreadyAccount.frame = CGRect.init(x: btnAlreadyAccount.frame.origin.x, y: viewContainer.frame.origin.y + viewContainer.frame.size.height + 12, width: btnAlreadyAccount.frame.size.width, height: btnAlreadyAccount.frame.size.height)
            txtEMail.text = socialDict.object(forKey: "email") as? String
            txtFirstName.text = socialDict.object(forKey: "FirstName") as? String
            txtLastName.text = socialDict.object(forKey: "LastName") as? String
            let strImageUrl = socialDict.object(forKey: "ProfilePic") as! String
            imgUserImage.sd_setImage(with: NSURL.init(string: strImageUrl) as URL!, placeholderImage: UIImage(named: "userPlaceholder"))
            deleObj.dictSeekerReg.setValue(strImageUrl, forKey: "ProfilePic")
            deleObj.dictSeekerReg.setValue(socialDict.object(forKey: "id"), forKey: "SocielID")
        }
        else
        {
            let fields: [AnyObject] = [txtFirstName,txtLastName,txtEMail,txtDOB,txtPassword,txtABN,txtLocation,txtWorkingRange]
            self.keyboardControls = BSKeyboardControls(fields: fields)
        }
        
        
        self.keyboardControls.delegate = self
        self.navigationController?.navigationBar.isTranslucent = false
        //txtABN.text = "74599608295"
        
        tblLocation.delegate = self
        tblLocation.dataSource = self
        
        tblLocation.isHidden = true
        tblLocation.layer.cornerRadius = 15
        tblLocation.clipsToBounds = true
        scrRegister.contentSizeToFit()
        
        btnMale.isSelected = false
        btnFemale.isSelected = true
        btnOther.isSelected = false
        deleObj.isForSeekerEdit = false
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        scrRegister.contentSizeToFit()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        imgUserImage.isUserInteractionEnabled = true
        imgUserImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnNext(_ sender: Any)
    {
//        let obj: regChooseCategory = self.storyboard?.instantiateViewController(withIdentifier: "regChooseCategory") as! regChooseCategory
//        self.navigationController!.pushViewController(obj, animated: true)
//        return
        if txtFirstName.text == ""
        {
            custObj.alertMessage("Please enter first name")
            return
        }
        if txtEMail.text == ""
        {
            custObj.alertMessage("Please enter email ID")
            return
        }
        if validateEmail(enteredEmail: txtEMail.text!) == false
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
//        if txtABN.text != "" && lblCompanyName.text == ""
//        {
//            custObj.alertMessage("Please enter valid ABN number")
//            return
//        }
        if tvLocation.text == "" || strLat == "" || strLong == ""
        {
            custObj.alertMessage("Please select your location")
            return
        }
        
        
        deleObj.dictSeekerReg.setValue(API.getToken(), forKey: "Token")
        deleObj.dictSeekerReg.setValue(API.getDeviceToken(), forKey: "DeviceID")
        deleObj.dictSeekerReg.setValue(txtFirstName.text, forKey: "FirstName")
        deleObj.dictSeekerReg.setValue(txtLastName.text, forKey: "LastName")
        deleObj.dictSeekerReg.setValue(txtDOB.text, forKey: "DOB")
        //deleObj.dictSeekerReg.setValue(API.convertDateToString(strDate: txtDOB.text!, fromFormat: "dd-MM-yyyy", toFormat: "dd/MM/yyyy"), forKey: "DOB")
        deleObj.dictSeekerReg.setValue(txtEMail.text, forKey: "EmailID")
        deleObj.dictSeekerReg.setValue(txtPassword.text, forKey: "Password")
        deleObj.dictSeekerReg.setValue(txtABN.text, forKey: "ABN")
        deleObj.dictSeekerReg.setValue(strLat, forKey: "Latitude")
        deleObj.dictSeekerReg.setValue(strLong, forKey: "Longitude")
        deleObj.dictSeekerReg.setValue(tvLocation.text, forKey: "LocationName")
        
        deleObj.dictSeekerReg.setValue("", forKey: "AboutUs")
        deleObj.dictSeekerReg.setValue("", forKey: "WorkingRightID")
        deleObj.dictSeekerReg.setValue(txtWorkingRange.text, forKey: "WorkingRang")
        
        deleObj.dictSeekerReg.setValue(API.getRegType(), forKey: "RegistrationType")
        deleObj.dictSeekerReg.setValue("1", forKey: "DeviceType")
        deleObj.dictSeekerReg.setValue(strMobile, forKey: "MobileNo")
        deleObj.dictSeekerReg.setValue(lblCompanyName.text, forKey: "NameOfBusiness")
        
        
        if btnMale.isSelected == true
        {
            deleObj.dictSeekerReg.setValue(btnMale.currentTitle, forKey: "Gender")
        }
        else if btnFemale.isSelected == true
        {
            deleObj.dictSeekerReg.setValue(btnFemale.currentTitle, forKey: "Gender")
        }
        else
        {
            deleObj.dictSeekerReg.setValue(btnOther.currentTitle, forKey: "Gender")
        }
        if btnYes.isSelected == true
        {
            deleObj.dictSeekerReg.setValue(true, forKey: "DoYouHaveVehicle")
        }
        else
        {
            deleObj.dictSeekerReg.setValue(false, forKey: "DoYouHaveVehicle")
        }
        checkExisting()
    }
    @IBAction func btnWorkingRangeInfo(_ sender: Any)
    {
        custObj.alertMessage(withTitle: "How far you want to go for work?", with: "Working Range Info")
    }
    @IBAction func btnAlreadyAccount(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMale(_ sender: Any)
    {
        btnMale.isSelected = true
        btnFemale.isSelected = false
        btnOther.isSelected = false
    }
    @IBAction func btnFemale(_ sender: Any)
    {
        btnMale.isSelected = false
        btnFemale.isSelected = true
        btnOther.isSelected = false
    }
    @IBAction func btnOther(_ sender: Any)
    {
        btnMale.isSelected = false
        btnFemale.isSelected = false
        btnOther.isSelected = true
    }
    @IBAction func btnYes(_ sender: Any)
    {
        btnNo.isSelected = false
        btnYes.isSelected = true
    }
    @IBAction func btnNo(_ sender: Any)
    {
        btnYes.isSelected = false
        btnNo.isSelected = true
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
        imgUserImage.image = image;
        isImage = 1
        deleObj.dictSeekerReg.setValue(API.encodeBase64FromData(UIImageJPEGRepresentation(imgUserImage.image!, 1.0)!), forKey: "ProfilePic")
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if txtDOB == textField
        {
            view.endEditing(true)
            let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
            obj.objSeeker = self
            obj.fromWhere = "seekerReg"
            obj.strForDateOrTime = "date"
            self.present(obj, animated: true, completion: nil)
            return false
        }
        return true
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
                    lblCompanyName.text = ""
                }
            }
            else
            {
                lblCompanyName.text = ""
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if txtWorkingRange == textField || txtABN == textField
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
    
    //MARK:- Call API
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
                    self.lblCompanyName.text = ""
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
                            self.lblCompanyName.text = self.dictABN.object(forKey: "EntityName") as? String
                        }
                        
                        print(self.dictABN)
                    }
                    catch let error as NSError
                    {
                        print(error)
                        self.custObj.alertMessage(ABN_MESSAGE)
                        DispatchQueue.main.async {
                            self.lblCompanyName.text = ""
                        }
                    }
                }
            }
            self.custObj.hideSVHud()
            }.resume()
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
    
    
    //MARK:- Call API
    func checkExisting()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(txtEMail.text, forKey: "Email")
        parameter.setValue(strMobile, forKey: "MobileNo")
        print(parameter)
        API.callApiPOST(strUrl: API_CheckDataExist,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                print(self.deleObj.dictSeekerReg)
                let obj: regChooseCategory = self.storyboard?.instantiateViewController(withIdentifier: "regChooseCategory") as! regChooseCategory
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
    
    //MARK:- Email Validation
    func validateEmail(enteredEmail:String) -> Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}
