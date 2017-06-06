//
//  myProfileClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/22/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit

class myProfileClass: UIViewController,BSKeyboardControlsDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Outlet
    @IBOutlet weak var scrRegsister: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var imgBusinessPhoto: cImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOfbusiness: UITextField!
    @IBOutlet weak var txtABN: UITextField!
    @IBOutlet weak var txtWebsiteUrl: UITextField!
    @IBOutlet weak var tvAbout: cTextView!
    @IBOutlet weak var txtLocation: paddingTextField!
    @IBOutlet weak var tvLocation: cTextView!
    @IBOutlet weak var viewGenInfo: cView!
    @IBOutlet weak var viewAddInfo: cView!
    @IBOutlet weak var btnChangePwd: cButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var txtMobile: paddingTextField!
    @IBOutlet weak var lblAboutCharLeft: UILabel!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var viewCategory: cView!
    @IBOutlet weak var btnEditProfile: cButton!
    @IBOutlet weak var lblAdditionInfo: UILabel!
    @IBOutlet weak var viewcateWithBtn: UIView!
    @IBOutlet weak var lblUploadPic: UILabel!
    
    var strFromWhere: String = ""
    var dictABN: NSDictionary!
    var arrOfCategory: NSMutableArray = NSMutableArray()
    var strLat: String = ""
    var strLong: String = ""
    var mainManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    var arrOfLocation: NSMutableArray = NSMutableArray()
    var isImage: Int = 0
    var deleObj: AppDelegate!
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        for case let txt as UITextField in viewGenInfo.subviews
        {
            txt.delegate = self
            txt.isUserInteractionEnabled = false
        }
        for case let txt as UITextField in viewAddInfo.subviews
        {
            txt.delegate = self
            txt.isUserInteractionEnabled = false
        }
        txtMobile.isUserInteractionEnabled = false
        tvAbout.delegate = self
        tvAbout.isUserInteractionEnabled = false
        let fields: [AnyObject] = [txtFirstName,txtLastName,txtEmail,txtABN,txtOfbusiness,txtWebsiteUrl,tvAbout]
        self.keyboardControls = BSKeyboardControls(fields: fields)
        self.keyboardControls.delegate = self
        
        tblLocation.delegate = self
        tblLocation.dataSource = self
        
        tblLocation.isHidden = true
        tblLocation.layer.cornerRadius = 15
        tblLocation.clipsToBounds = true
        setProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCategoryProfilePoster), name: NSNotification.Name(rawValue: "reloadCategoryProfilePoster"), object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        imgBusinessPhoto.isUserInteractionEnabled = true
        imgBusinessPhoto.addGestureRecognizer(tapGestureRecognizer)
        if API.getLoginType() != "4"
        {
            btnChangePwd.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: API.blackColor(), NSFontAttributeName: UIFont(name: font_openSans_regular, size: 14)!]
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = API.NavigationbarColor()
        scrRegsister.contentSizeToFit()
        
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- POST NOTIFICATION
    func reloadCategoryProfilePoster(n: NSNotification)
    {
        btnEdit.setTitle("Save", for: UIControlState.normal)
        for case let txt as UITextField in viewGenInfo.subviews
        {
            txt.isUserInteractionEnabled = true
        }
        for case let txt as UITextField in viewAddInfo.subviews
        {
            txt.isUserInteractionEnabled = true
        }
        txtMobile.isUserInteractionEnabled = false
        tvAbout.isUserInteractionEnabled = true
        let arr: NSArray = n.object as! NSArray
        arrOfCategory = NSMutableArray.init(array: arr)
        manageTag(arrTag: arrOfCategory)
    }
    //MARK:- Set Profile
    func setProfile()
    {
        print(API.getLoggedUserData())
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        imgBusinessPhoto.sd_setImage(with: NSURL.init(string: (dictUserData.object(forKey: "ProfilePic") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        if dictUserData.object(forKey: "ProfilePic") as! String != ""
        {
            lblUploadPic.isHidden = true
        }
        txtFirstName.text = dictUserData.object(forKey: "FirstName") as? String
        txtLastName.text = dictUserData.object(forKey: "LastName") as? String
        txtEmail.text = dictUserData.object(forKey: "EmailID") as? String
        txtMobile.text = dictUserData.object(forKey: "MobileNo") as? String
        txtABN.text = dictUserData.object(forKey: "ABN") as? String
        txtOfbusiness.text = dictUserData.object(forKey: "NameOfBusiness") as? String
        txtWebsiteUrl.text = dictUserData.object(forKey: "WebsiteURL") as? String
        tvAbout.text = dictUserData.object(forKey: "AboutYourBusiness") as? String
        tvLocation.text = dictUserData.object(forKey: "LocationName") as? String
        lblAboutCharLeft.text = String(format: "%d Left", 300 - tvAbout.text.length)
        strLat = dictUserData.object(forKey: "Latitude") as! String
        strLong = dictUserData.object(forKey: "Longitude") as! String
        let arrCate: NSArray = dictUserData.object(forKey: "PosterCategory") as! NSArray
        for item in arrCate
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary()
            dictMutable.setValue(dd.object(forKey: "ID"), forKey: "ID")
            dictMutable.setValue(dd.object(forKey: "Path"), forKey: "Name")
            arrOfCategory.add(dictMutable)
        }
        manageTag(arrTag: arrOfCategory)
        scrRegsister.contentSizeToFit()
    }
    
    //MARK:- Action Zone
    @IBAction func btnEdit(_ sender: Any)
    {
        if btnEdit.currentTitle == "Edit"
        {
            btnEdit.setTitle("Save", for: UIControlState.normal)
            for case let txt as UITextField in viewGenInfo.subviews
            {
                txt.isUserInteractionEnabled = true
            }
            for case let txt as UITextField in viewAddInfo.subviews
            {
                txt.isUserInteractionEnabled = true
            }
            txtMobile.isUserInteractionEnabled = false
            tvAbout.isUserInteractionEnabled = true
            txtFirstName.becomeFirstResponder()
        }
        else
        {
            //btnEdit.setTitle("Edit", for: UIControlState.normal)
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
//            if txtABN.text != "" && txtOfbusiness.text == ""
//            {
//                custObj.alertMessage("Please enter valid ABN number")
//                return
//            }
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
            
            let parameter: NSMutableDictionary = NSMutableDictionary()
            
            parameter.setValue(API.getToken(), forKey: "Token")
            parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
            parameter.setValue(txtFirstName.text, forKey: "FirstName")
            parameter.setValue(txtLastName.text, forKey: "LastName")
            parameter.setValue(API.getUserId(), forKey: "UserID")
            parameter.setValue(txtEmail.text, forKey: "EmailID")
            parameter.setValue(txtABN.text, forKey: "ABN")
            parameter.setValue(txtOfbusiness.text, forKey: "NameOfBusiness")
            parameter.setValue(strLat, forKey: "Latitude")
            parameter.setValue(strLong, forKey: "Longitude")
            parameter.setValue(tvLocation.text, forKey: "LocationName")
            parameter.setValue(txtMobile.text, forKey: "MobileNo")
            
            parameter.setValue(tvAbout.text, forKey: "AboutYourBusiness")
            parameter.setValue(txtWebsiteUrl.text, forKey: "WebSite")
            parameter.setValue(txtMobile.text, forKey: "MobileNo")
            
            let arrId: NSMutableArray = NSMutableArray()
            for item in arrOfCategory
            {
                let dd: NSDictionary = item as! NSDictionary
                arrId.add(dd.object(forKey: "ID") ?? 0)
            }
            let strDs = arrId.componentsJoined(by: ",")
            parameter.setValue(strDs, forKey: "CategoryIDs")
            checkExisting(dict: parameter)
        }
    }
    @IBAction func btnEditMobile(_ sender: Any)
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
        
        // Start the authentication flow with the custom appearance. Nil parameters for default values.
        digits.authenticate(with: nil, configuration:configuration!) { (session, error) in
            // Inspect session/error objects
            
            if session != nil
            {
                self.txtMobile.text = (session?.phoneNumber)!
                self.btnEdit.setTitle("Save", for: UIControlState.normal)
                for case let txt as UITextField in self.viewGenInfo.subviews
                {
                    txt.isUserInteractionEnabled = true
                }
                for case let txt as UITextField in self.viewAddInfo.subviews
                {
                    txt.isUserInteractionEnabled = true
                }
                self.txtMobile.isUserInteractionEnabled = false
                self.tvAbout.isUserInteractionEnabled = true
            }
        }
    }
    @IBAction func btnEditCategory(_ sender: Any)
    {
        let obj: regCategoryClass = self.storyboard?.instantiateViewController(withIdentifier: "regCategoryClass") as! regCategoryClass
        obj.isFromMyProfile = true
        obj.arrOfMyProfileCategory = arrOfCategory
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnChangePwd(_ sender: Any)
    {
        let obj: changePwdClass = self.storyboard?.instantiateViewController(withIdentifier: "changePwdClass") as! changePwdClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnEditProfilePic(_ sender: Any)
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
    
    
    
    //MARK:- image Delegate
    func imageTapped(img: AnyObject)
    {
        if (dictUserData.object(forKey: "ProfilePic") as! String) != ""
        {
            let obj: zoomImageViewClass = self.storyboard?.instantiateViewController(withIdentifier: "zoomImageViewClass") as! zoomImageViewClass
            obj.strImageUrl = (dictUserData.object(forKey: "ProfilePic") as! String)
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.navigationController!.dismiss(animated: true, completion: { _ in })
        let image: UIImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        //imgBusinessPhoto.image = image
        //isImage = 1
        editProfilePic(stringEncode: API.encodeBase64FromData(UIImageJPEGRepresentation(image, 1.0)!),image: image)
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
    //MARK:- TagList Method
    func manageTag(arrTag: NSMutableArray)
    {
        for case let vv as CustomViewWithoutButton in self.viewCategory.subviews
        {
            vv.removeFromSuperview()
        }
        
        if arrTag.count == 0
        {
            return
        }
        for i in 0..<arrTag.count
        {
            let dd: NSDictionary = arrTag.object(at: i) as! NSDictionary
            let view1 : CustomViewWithoutButton = CustomViewWithoutButton.init(s: dd.object(forKey: "Name") as! String, viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
            print(view1.frame)
            // view1.viewBackColor = UIColor.lightGray
            // view1.frame = CGRect.init(x: 0, y: 20, width: view1.btnSecondOutlet.frame.origin.x + view1.btnSecondOutlet.frame.size.width + 3, height: view1.lblText.frame.size.height + 6)
            view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 6)
            view1.tag = 2000 + i
            view1.clipsToBounds = true
            //            view1.btnFirstOutlet.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            //            view1.btnSecondOutlet.setImage(UIImage.init(named: ""), for: UIControlState.normal)
            
            view1.backgroundColor = API.lightBlueColor()
            view1.layer.borderColor = API.themeColorBlue().cgColor
            view1.layer.borderWidth = 1
            view1.clipsToBounds = true
            viewCategory.addSubview(view1)
            self.view.layoutIfNeeded()
        }
        arrangeTags(viewCate: viewCategory)
    }
    func arrangeTags(viewCate: cView)
    {
        var prevViewWidth : CGFloat = 10
        var prevViewY : CGFloat = 10
        var lastViewFrame: CGFloat = 0
        
        for v in viewCate.subviews
        {
            if(v.tag >= 2000 && v.tag < 99999)
            {
                if(v is CustomViewWithoutButton)
                {
                    let cv : CustomViewWithoutButton = v as! CustomViewWithoutButton
                    
                    if(((prevViewWidth + cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 3) <= 280))
                    {
                        cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9, height: cv.lblText.frame.size.height + 6)
                    }
                    else
                    {
                        prevViewWidth = 20
                        cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 9, height: cv.lblText.frame.size.height + 6)
                    }
                    
                    if(self.view.viewWithTag(v.tag + 1) != nil)
                    {
                        let nextView : CustomViewWithoutButton = self.view.viewWithTag(v.tag + 1) as! CustomViewWithoutButton
                        
                        if(!((prevViewWidth + (cv.lblText.frame.origin.x + cv.lblText.frame.size.width + 3) + nextView.lblText.frame.origin.x + nextView.lblText.frame.size.width + 3) <= 280))
                        {
                            prevViewY = cv.frame.origin.y + cv.frame.size.height + 5
                        }
                    }
                    
                    lastViewFrame = cv.frame.size.height
                    //cv.layer.borderColor = UIColor.init(red: 20/255.0, green: 164/255.0, blue: 245/255.0, alpha: 1.0).cgColor
                    cv.layer.cornerRadius = 13//cv.frame.size.height / 2
                    //cv.layer.borderWidth = 0.5
                    cv.clipsToBounds = true
                    prevViewWidth = cv.frame.size.width + cv.frame.origin.x + 2
                }
            }
        }
        viewCategory.frame = CGRect.init(x: viewCategory.frame.origin.x, y: viewCategory.frame.origin.y, width: viewCategory.frame.size.width, height: prevViewY + lastViewFrame + 10)
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
    func saveProfile(parameter:NSMutableDictionary)
    {
        print(parameter)
        custObj.showSVHud("Loading")
        
        API.callApiPOST(strUrl: API_POSTER_EDIT,parameter: parameter, success: { (response) in
            
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
                
                self.btnEdit.setTitle("Edit", for: UIControlState.normal)
                for case let txt as UITextField in self.viewGenInfo.subviews
                {
                    txt.isUserInteractionEnabled = false
                }
                for case let txt as UITextField in self.viewAddInfo.subviews
                {
                    txt.isUserInteractionEnabled = false
                }
                self.tvAbout.isUserInteractionEnabled = false
                self.txtMobile.isUserInteractionEnabled = false
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                if self.strFromWhere == "postJob"
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCategoryPostJob"), object: nil)
                }
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
    func editProfilePic(stringEncode: String,image:UIImage)
    {
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(stringEncode, forKey: "ImageData")
        parameter.setValue(dictUserData.object(forKey: "RoleName"), forKey: "RoleName")
        print(parameter)
        custObj.showSVHud("Loading")
        
        API.callApiPOST(strUrl: API_ADD_PROFILE_PIC,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.imgBusinessPhoto.image = image
                self.lblUploadPic.isHidden = true
                let firstObj: NSArray = response.object(forKey: "Data") as! NSArray
                let result: NSDictionary = firstObj.object(at: 0) as! NSDictionary
                let dictData: NSMutableDictionary = NSMutableDictionary.init(dictionary: result)
                //let dictData: NSMutableDictionary = self.custObj.dictionaryByReplacingNulls(withStrings:result.mutableCopy() as! NSMutableDictionary)
                self.dictUserData = dictData
                API.setXMPPUSER(type: dictData.object(forKey: JID) as! String)
                API.setXMPPPWD(type: dictData.object(forKey: "JPassword") as! String)
                API.setLoggedUserData(dict: dictData)
                API.setUserId(user_id: dictData.object(forKey: "UserID") as! String)
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
    func checkExisting(dict: NSMutableDictionary)
    {
        let parameter: NSMutableDictionary = NSMutableDictionary()
        if dictUserData.object(forKey: "MobileNo") as? String == txtMobile.text && dictUserData.object(forKey: "EmailID") as? String == txtEmail.text
        {
            self.saveProfile(parameter: dict)
        }
        else
        {
            custObj.showSVHud("Loading")
            parameter.setValue(API.getToken(), forKey: "Token")
            if dictUserData.object(forKey: "MobileNo") as? String != txtMobile.text && dictUserData.object(forKey: "EmailID") as? String != txtEmail.text
            {
                parameter.setValue(txtEmail.text, forKey: "Email")
                parameter.setValue(txtMobile.text, forKey: "MobileNo")
            }
            else if dictUserData.object(forKey: "MobileNo") as? String != txtMobile.text
            {
                parameter.setValue("", forKey: "Email")
                parameter.setValue(txtMobile.text, forKey: "MobileNo")
            }
            else
            {
                parameter.setValue(txtEmail.text, forKey: "Email")
                parameter.setValue("", forKey: "MobileNo")
            }
            print(parameter)
            API.callApiPOST(strUrl: API_CheckDataExist,parameter: parameter, success: { (response) in
                
                self.custObj.hideSVHud()
                print(response)
                if response.object(forKey: "ReturnCode") as! String == "1"
                {
                    self.saveProfile(parameter: dict)
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
    //MARK:- Email Validation
    func validateEmail(enteredEmail:String) -> Bool
    {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    //MARK:- Validate URL
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
