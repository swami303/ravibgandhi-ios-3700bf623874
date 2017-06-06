//
//  myProfileSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/3/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit

class myProfileSeeker: UIViewController,BSKeyboardControlsDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    //MARK:- Outlet
    @IBOutlet weak var scrlGeneralInfo: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrlAdditionalInfo: TPKeyboardAvoidingScrollView!
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var viewReferenceMain: UIView!
    @IBOutlet weak var viewWorkHistoryMain: UIView!
    @IBOutlet weak var btnAddReferenceViewOutlet: UIButton!
    @IBOutlet weak var lblWorkHistoryTitle: UILabel!
    @IBOutlet weak var btnAddWorkHistoryOutlet: UIButton!
    @IBOutlet weak var lblUploadPic: UILabel!
    
    @IBOutlet weak var lblSkillCategoryTitle: UILabel!
    @IBOutlet weak var btnAddSkillCategoryOutlet: UIButton!
    @IBOutlet weak var viewSkillCategoryMain: UIView!
    
    @IBOutlet weak var viewIdVerificationContainer: UIView!
    @IBOutlet weak var viewGenInfoInner: cView!
    @IBOutlet weak var viewAddInfoInner: cView!
    @IBOutlet weak var sgmtProfile: cSegment!
    
    @IBOutlet weak var imgUserPhoto: cImageView!
    @IBOutlet weak var viewGenInfoMain: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var txtABN: UITextField!
    @IBOutlet weak var txtLocation: paddingTextField!
    @IBOutlet weak var tvLocation: cTextView!
    @IBOutlet weak var txtWorkingRange: UITextField!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnChangePwd: cButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var tvAbout: cTextView!
    @IBOutlet weak var lblAboutCharLeft: UILabel!
    @IBOutlet weak var txtWorkingRights: paddingTextField!
    @IBOutlet weak var cvIDProof: UICollectionView!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    @IBOutlet weak var viewChooseCategoryPopup: UIView!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var txtSearch: paddingTextField!
    
    var arrOfWorkingRights: NSMutableArray = NSMutableArray()
    var arrOfAllCategory: NSMutableArray = NSMutableArray()
    var arrOfAllCategoryTemp: NSMutableArray = NSMutableArray()
    var arrOfSelectedCategory: NSMutableArray = NSMutableArray()
    var arrOFID: NSMutableArray = NSMutableArray()
    var arrOfReference: NSMutableArray = NSMutableArray()
    var arrOfWorkHistory: NSMutableArray = NSMutableArray()
    var dictABN: NSDictionary!
    var tempTextField: UITextField!
    
    var WorkingRightID: Int = 0
    var selectedCateID: Int = 0
    var mainManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    var strLat: String = ""
    var strLong: String = ""
    var arrOfLocation: NSMutableArray = NSMutableArray()
    var dictUserData: NSMutableDictionary = NSMutableDictionary()
    let custObj: customClassViewController = customClassViewController()
    var deleObj: AppDelegate!
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lblCompanyName.text = ""
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        self.navigationController?.navigationBar.isTranslucent = false
        let fields: [AnyObject] = [txtFirstName,txtLastName,txtEmail,txtDOB,txtABN,txtLocation]
        self.keyboardControls = BSKeyboardControls(fields: fields)
        self.keyboardControls.delegate = self
        
        scrlAdditionalInfo.isHidden = true
        scrlGeneralInfo.isHidden = false
        
        viewReferenceMain.frame = CGRect.init(x: 2000, y: 20, width: viewReferenceMain.frame.size.width, height: viewReferenceMain.frame.size.height)
        viewWorkHistoryMain.frame = CGRect.init(x: 2000, y: 20, width: viewWorkHistoryMain.frame.size.width, height: viewWorkHistoryMain.frame.size.height)
        
        scrlGeneralInfo.contentSizeToFit()
        scrlAdditionalInfo.contentSizeToFit()
        
        //        self.addNewReferenceView()
        //        self.addNewWorkHistoryView()
        
        self.arrangeDynamicViews()
        self.arrangeDynamicViewsGeneralTab()
        
        
        tvAbout.delegate = self
        tblLocation.delegate = self
        tblLocation.dataSource = self
        
        tblLocation.isHidden = true
        tblLocation.layer.cornerRadius = 15
        tblLocation.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        imgUserPhoto.isUserInteractionEnabled = true
        imgUserPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        
        setProfile()
        if API.getLoginType() != "4"
        {
            btnChangePwd.isHidden = true
        }
        
        tblCategory.delegate = self
        tblCategory.dataSource = self
        
        getAllCategories()
        GetAllWorkingRight()
        txtSearch.delegate = self
        
        cvIDProof.delegate = self
        cvIDProof.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        layout.itemSize = CGSize(width: 95, height: 110)
        layout.scrollDirection = .horizontal
        cvIDProof!.collectionViewLayout = layout
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCategory), name: NSNotification.Name(rawValue: "reloadCategoryProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadIDProof), name: NSNotification.Name(rawValue: "reloadIDProofProfile"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        deleObj.isForSeekerEdit = true
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func setUseInteraction(flag: Bool)
    {
        for case let txt as UITextField in viewGenInfoInner.subviews
        {
            txt.isUserInteractionEnabled = flag
            txt.delegate = self
        }
        for case let txt as UITextField in viewAddInfoInner.subviews
        {
            txt.isUserInteractionEnabled = flag
            txt.delegate = self
        }
        
        txtWorkingRights.isUserInteractionEnabled = flag
        txtWorkingRights.delegate = self
        tvAbout.isUserInteractionEnabled = flag
        btnMale.isUserInteractionEnabled = flag
        btnFemale.isUserInteractionEnabled = flag
        btnOther.isUserInteractionEnabled = flag
        btnYes.isUserInteractionEnabled = flag
        btnNo.isUserInteractionEnabled = flag
        
        txtMobile.isUserInteractionEnabled = false
        
        
        for item in scrlAdditionalInfo.subviews
        {
            if(item.tag >= 2000 && item.tag <= 3999)
            {
                let vv: UIView  = item
                for case let txt as UITextField in vv.subviews
                {
                    txt.isUserInteractionEnabled = flag
                }
            }
            
            if(item.tag >= 4000 && item.tag <= 5999)
            {
                let vv: UIView  = item
                for case let txt as UITextField in vv.subviews
                {
                    txt.isUserInteractionEnabled = flag
                }
            }
        }
    }
    //MARK:- Action Zone
    @IBAction func swtchAction(_ sender: Any)
    {
        let sgmt : UISegmentedControl = sender as! UISegmentedControl
        
        if(sgmt.selectedSegmentIndex == 0)
        {
            scrlAdditionalInfo.isHidden = true
            scrlGeneralInfo.isHidden = false
        }
        else
        {
            scrlGeneralInfo.isHidden = true
            scrlAdditionalInfo.isHidden = false
        }
        self.view.endEditing(true)
    }
    //MARK:- POST NOTIFICATION
    func reloadCategory(n: NSNotification)
    {
        setUseInteraction(flag: true)
        btnEdit.setTitle("Save", for: UIControlState.normal)
        let dd: NSDictionary = n.object as! NSDictionary
        let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        if deleObj.isForCatEdit == true
        {
            arrOfSelectedCategory.replaceObject(at: deleObj.arrIndexForCatEdit, with: dictMutable)
        }
        else
        {
            arrOfSelectedCategory.add(dictMutable)
        }
        addNewSkillCategoryView(dd: dd)
    }
    func reloadIDProof(n: NSNotification)
    {
        setUseInteraction(flag: true)
        btnEdit.setTitle("Save", for: UIControlState.normal)
        
        let aa: NSArray = n.object as! NSArray
        arrOFID = NSMutableArray.init(array: aa)
        cvIDProof.reloadData()
    }
    //MARK:- Action Zone
    @IBAction func btnAddSkillCategoryViewAction(_ sender: Any)
    {
        deleObj.isForCatEdit = false
        custObj.bounceView(in: true, view: viewChooseCategoryPopup)
        deleObj.dictOfCategories = NSMutableDictionary()
        selectedCateID = -1
        arrOfAllCategory = NSMutableArray.init(array: arrOfAllCategoryTemp)
        tblCategory.reloadData()
        //self.addNewSkillCategoryView()
    }
    
    func addNewSkillCategoryView(dd: NSDictionary)
    {
        var tagToAssign : Int = 6000
        var newY : CGFloat = btnAddSkillCategoryOutlet.frame.origin.y + btnAddSkillCategoryOutlet.frame.size.height
        
        for item in scrlGeneralInfo.subviews
        {
            if(item.tag >= 6000 && item.tag <= 7999)
            {
                item.removeFromSuperview()
                //tagToAssign = item.tag + 1
                
                //newY = item.frame.origin.y + item.frame.size.height + 8
            }
        }
        
        for item in arrOfSelectedCategory
        {
            let ddd: NSDictionary = item as! NSDictionary
            print(ddd)
            let archive = NSKeyedArchiver.archivedData(withRootObject: viewSkillCategoryMain)
            let viewSkillCategoryCopy = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
            viewSkillCategoryCopy.tag = tagToAssign
            viewSkillCategoryCopy.frame = CGRect.init(x: 8, y: newY, width: viewSkillCategoryCopy.frame.size.width, height: viewSkillCategoryCopy.frame.size.height)
            viewSkillCategoryCopy.layer.cornerRadius = 10.0
            viewSkillCategoryCopy.layer.borderColor = API.dividerColor().cgColor
            viewSkillCategoryCopy.layer.borderWidth = 1.0
            viewSkillCategoryCopy.clipsToBounds = true
            viewSkillCategoryCopy.backgroundColor = API.lightGray()
            print(tagToAssign)
            
            let btnDelete : UIButton = viewSkillCategoryCopy.viewWithTag(36) as! UIButton
            btnDelete.addTarget(self, action: #selector(self.btnDeleteSkillCategoryAction(_:)), for: UIControlEvents.touchUpInside)
            btnDelete.tag = viewSkillCategoryCopy.tag + (1000) + 36
            
            for case let txt as paddingTextField in viewSkillCategoryCopy.subviews
            {
                if txt.tag == 31
                {
                    txt.tag = tagToAssign + 2
                    txt.text = ddd.object(forKey: "CategoryName") as? String
                }
                if txt.tag == 32
                {
                    txt.tag = tagToAssign + 3
                }
                if txt.tag == 33
                {
                    txt.tag = tagToAssign + 4
                }
                if txt.tag == 34
                {
                    txt.tag = tagToAssign + 5
                }
                if txt.tag == 35
                {
                    txt.tag = tagToAssign + 6
                }
                print(txt.tag)
                txt.paddingLeft = 10
                txt.paddingRight = 16
                txt.borderWidth = 1
                txt.cornerRadius = 15
                txt.borderColor = API.dividerColor()
                txt.placeHolderColor = API.blackColor()
                txt.textColor = API.blackColor()
                txt.delegate = self
            }
            tagToAssign = tagToAssign + 1
            scrlGeneralInfo.addSubview(viewSkillCategoryCopy)
            newY = viewSkillCategoryCopy.frame.origin.y + viewSkillCategoryCopy.frame.size.height + 8
        }
        
        /*
         let ddd: NSDictionary = item as! NSDictionary
         let archive = NSKeyedArchiver.archivedData(withRootObject: viewSkillCategoryMain)
         let viewSkillCategoryCopy = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
         viewSkillCategoryCopy.tag = tagToAssign
         viewSkillCategoryCopy.frame = CGRect.init(x: 8, y: newY, width: viewSkillCategoryCopy.frame.size.width, height: viewSkillCategoryCopy.frame.size.height)
         viewSkillCategoryCopy.layer.cornerRadius = 10.0
         viewSkillCategoryCopy.layer.borderColor = API.dividerColor().cgColor
         viewSkillCategoryCopy.layer.borderWidth = 1.0
         viewSkillCategoryCopy.clipsToBounds = true
         viewSkillCategoryCopy.backgroundColor = API.lightGray()
         print(tagToAssign)
         tagToAssign = tagToAssign + 1
         let btnDelete : UIButton = viewSkillCategoryCopy.viewWithTag(36) as! UIButton
         btnDelete.addTarget(self, action: #selector(self.btnDeleteSkillCategoryAction(_:)), for: UIControlEvents.touchUpInside)
         btnDelete.tag = viewSkillCategoryCopy.tag + (1000) + 36
         
         for case let txt as paddingTextField in viewSkillCategoryCopy.subviews
         {
         if txt.tag == 31
         {
         txt.tag = tagToAssign + 2
         txt.text = ddd.object(forKey: "CategoryName") as? String
         }
         if txt.tag == 32
         {
         txt.tag = tagToAssign + 3
         }
         if txt.tag == 33
         {
         txt.tag = tagToAssign + 4
         }
         if txt.tag == 34
         {
         txt.tag = tagToAssign + 5
         }
         if txt.tag == 35
         {
         txt.tag = tagToAssign + 6
         }
         print(txt.tag)
         txt.paddingLeft = 10
         txt.paddingRight = 16
         txt.borderWidth = 1
         txt.cornerRadius = 15
         txt.borderColor = API.dividerColor()
         txt.placeHolderColor = API.blackColor()
         txt.textColor = API.blackColor()
         txt.delegate = self
         }
         scrlGeneralInfo.addSubview(viewSkillCategoryCopy)
         */
        
        self.arrangeDynamicViewsGeneralTab()
    }
    
    @IBAction func btnDeleteSkillCategoryAction(_ sender: Any)
    {
        print((sender as! UIButton).tag)
        print(((sender as! UIButton).superview)! .tag)
        
        ((sender as! UIButton).superview)!.removeFromSuperview()
        //let tag: Int = ((sender as! UIButton).superview)! .tag)
        self.arrangeDynamicViewsGeneralTab()
        arrOfSelectedCategory.removeObject(at: (((sender as! UIButton).superview)! .tag) - 6000)
        setUseInteraction(flag: true)
        btnEdit.setTitle("Save", for: UIControlState.normal)
        
        for item in arrOfSelectedCategory
        {
            let dd: NSDictionary = item as! NSDictionary
            addNewSkillCategoryView(dd: dd)
        }
    }
    
    
    @IBAction func btnAddReferenceViewAction(_ sender: Any)
    {
        var counter : Int = 0
        
        for item in scrlAdditionalInfo.subviews
        {
            if(item.tag >= 2000 && item.tag <= 3999)
            {
                counter = counter + 1
            }
        }
        
        if(counter >= 2)
        {
            custObj.alertMessage("You can not add more than Two References")
            return
        }
        let ddd: NSMutableDictionary = NSMutableDictionary()
        self.addNewReferenceView(dd: ddd)
        btnEdit.setTitle("Save", for: UIControlState.normal)
        setUseInteraction(flag: true)
    }
    
    @IBAction func btnEdit(_ sender: Any)
    {
        view.endEditing(true)
        custObj.bounceViewOut(true, view: viewChooseCategoryPopup)
        if btnEdit.currentTitle == "Edit"
        {
            setUseInteraction(flag: true)
            btnEdit.setTitle("Save", for: UIControlState.normal)
            
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
//            if tvAbout.text == ""
//            {
//                custObj.alertMessage("Please enter about you or your business")
//                return
//            }
//            if txtABN.text != "" && lblCompanyName.text == ""
//            {
//                custObj.alertMessage("Please enter valid ABN number")
//                return
//            }
            if tvLocation.text == "" || strLat == "" || strLong == ""
            {
                custObj.alertMessage("Please select your location")
                return
            }
            if arrOfSelectedCategory.count == 0
            {
                custObj.alertMessage("Please add atleast one category")
                return
            }
            if txtWorkingRights.text == ""
            {
                sgmtProfile.selectedSegmentIndex = 1
                scrlGeneralInfo.isHidden = true
                scrlAdditionalInfo.isHidden = false
                custObj.alertMessage("Please select your working rights")
                return
            }
            let parameter: NSMutableDictionary = NSMutableDictionary()
            
            parameter.setValue(API.getToken(), forKey: "Token")
            parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
            parameter.setValue(API.getUserId(), forKey: "UserID")
            parameter.setValue(txtFirstName.text, forKey: "FirstName")
            parameter.setValue(txtLastName.text, forKey: "LastName")
            parameter.setValue(txtDOB.text, forKey: "DOB")
            //parameter.setValue(API.convertDateToString(strDate: txtDOB.text!, fromFormat: "dd-MM-yyyy", toFormat: "dd/MM/yyyy"), forKey: "DOB")
            parameter.setValue(txtEmail.text, forKey: "EmailID")
            parameter.setValue(txtMobile.text, forKey: "MobileNo")
            parameter.setValue(txtABN.text, forKey: "ABN")
            parameter.setValue(strLat, forKey: "Latitude")
            parameter.setValue(strLong, forKey: "Longitude")
            parameter.setValue(tvLocation.text, forKey: "LocationName")
            
            parameter.setValue(tvAbout.text, forKey: "AboutYou")
            parameter.setValue(WorkingRightID, forKey: "WorkingRightID")
            parameter.setValue(txtWorkingRights.text, forKey: "WorkingRight")
            
            parameter.setValue(txtWorkingRange.text, forKey: "WorkingRang")
            parameter.setValue(txtMobile.text, forKey: "MobileNo")
            parameter.setValue(API.getRegType(), forKey: "RegistrationType")
            parameter.setValue("1", forKey: "DeviceType")
            
            parameter.setValue(arrOFID, forKey: "IDProof")
            parameter.setValue(arrOfSelectedCategory, forKey: "SeekerCategory")
            parameter.setValue(lblCompanyName.text, forKey: "NameOfBusiness")
            
            if btnMale.isSelected == true
            {
                parameter.setValue(btnMale.currentTitle, forKey: "Gender")
            }
            else if btnFemale.isSelected == true
            {
                parameter.setValue(btnFemale.currentTitle, forKey: "Gender")
            }
            else
            {
                parameter.setValue(btnOther.currentTitle, forKey: "Gender")
            }
            if btnYes.isSelected == true
            {
                parameter.setValue(true, forKey: "DoYouHaveVehicle")
            }
            else
            {
                parameter.setValue(false, forKey: "DoYouHaveVehicle")
            }
            arrOfReference = NSMutableArray()
            arrOfWorkHistory = NSMutableArray()
            for item in scrlAdditionalInfo.subviews
            {
                if(item.tag >= 2000 && item.tag <= 3999)
                {
                    let vv: UIView  = item
                    let dictRef: NSMutableDictionary = NSMutableDictionary()
                    for case let txt as UITextField in vv.subviews
                    {
                        if txt.tag == 1
                        {
                            if txt.text == ""
                            {
                                custObj.alertMessage(String(format: "Please enter %@", txt.placeholder!))
                                return
                            }
                            dictRef.setValue(txt.text, forKey: "Name")
                        }
                        else if txt.tag == 2
                        {
                            dictRef.setValue(txt.text, forKey: "ContactNo")
                        }
                        else  if txt.tag == 3
                        {
                            dictRef.setValue(txt.text, forKey: "Email")
                        }
                        else  if txt.tag == 4
                        {
                            dictRef.setValue(txt.text, forKey: "NameOfOrg")
                        }
                    }
                    if dictRef.object(forKey: "ContactNo") as! String == "" && dictRef.object(forKey: "Email") as! String == ""
                    {
                        custObj.alertMessage("Please enter Mobile or Email")
                        return
                    }
                    arrOfReference.add(dictRef)
                }
                
                if(item.tag >= 4000 && item.tag <= 5999)
                {
                    let vv: UIView  = item
                    let dictRef: NSMutableDictionary = NSMutableDictionary()
                    for case let txt as UITextField in vv.subviews
                    {
                        print(txt)
                        if txt.text == ""
                        {
                            custObj.alertMessage(String(format: "Please enter %@", txt.placeholder!))
                            return
                        }
                        if txt.tag == 1
                        {
                            dictRef.setValue(txt.text, forKey: "JobTitle")
                        }
                        else if txt.tag == 2
                        {
                            dictRef.setValue(txt.text, forKey: "NameOfCompany")
                        }
                        else  if txt.tag == 3
                        {
                            dictRef.setValue(txt.text, forKey: "StartDate")
                        }
                        else  if txt.tag == 4
                        {
                            dictRef.setValue(txt.text, forKey: "EndDate")
                        }
                        else  if txt.tag == 5
                        {
                            dictRef.setValue(txt.text, forKey: "KeyRole")
                        }
                    }
                    arrOfWorkHistory.add(dictRef)
                }
                
            }
            parameter.setValue(arrOfReference, forKey: "Reference")
            parameter.setValue(arrOfWorkHistory, forKey: "WorkHistory")
            checkExisting(dict: parameter)
        }
    }
    @IBAction func btnChangePwd(_ sender: Any)
    {
        let obj: changePwdClass = self.storyboard?.instantiateViewController(withIdentifier: "changePwdClass") as! changePwdClass
        self.navigationController!.pushViewController(obj, animated: true)
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
                self.setUseInteraction(flag: true)
                self.btnEdit.setTitle("Save", for: UIControlState.normal)
            }
        }
    }
    @IBAction func btnWorkingRangeInfo(_ sender: Any)
    {
        custObj.alertMessage(withTitle: "How far you want to go for work?", with: "Working Range Info")
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
    @IBAction func btnEditIDProof(_ sender: Any)
    {
        let obj: regIDProof = self.storyboard?.instantiateViewController(withIdentifier: "regIDProof") as! regIDProof
        obj.arrOFIDFromEditProfile = arrOFID
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnCheckedCate(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        
        let dd: NSDictionary = arrOfAllCategory.object(at: tag) as! NSDictionary
        let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        if dictMutable.object(forKey: "isSelected") as! String == "1"
        {
            dictMutable.setValue("0", forKey: "isSelected")
            arrOfAllCategory.replaceObject(at: tag, with: dictMutable)
            selectedCateID = -1
        }
        else
        {
            let arr: NSMutableArray = NSMutableArray.init(array: arrOfAllCategory)
            var i: Int = 0
            arrOfAllCategory = NSMutableArray()
            for item in arr
            {
                let dd: NSDictionary = item as! NSDictionary
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                dictMutable.setValue("0", forKey: "isSelected")
                arrOfAllCategory.add(dictMutable)
                i = i + 1
            }
            selectedCateID = dictMutable.object(forKey: "ID") as! Int
            self.deleObj.dictOfCategories.setValue(selectedCateID, forKey: "CategoryID")
            if selectedCateID == 0
            {
                if let val = deleObj.dictOfCategories["SkillNames"]
                {
                }
                else
                {
                    self.deleObj.dictOfCategories.setValue("", forKey: "SkillNames")
                    self.deleObj.dictOfCategories.setValue("", forKey: "TitleNames")
                    self.deleObj.dictOfCategories.setValue([], forKey: "CerficateFile")
                    self.deleObj.dictOfCategories.setValue("", forKey: "ExperienceMonth")
                    self.deleObj.dictOfCategories.setValue("", forKey: "ExperienceYear")
                    self.deleObj.dictOfCategories.setValue(true, forKey: "HaveExperience")
                }
            }
            dictMutable.setValue("1", forKey: "isSelected")
            arrOfAllCategory.replaceObject(at: tag, with: dictMutable)
        }
        tblCategory.reloadData()
    }
    @IBAction func btnCancelCatePopup(_ sender: Any)
    {
        view.endEditing(true)
        custObj.bounceViewOut(true, view: viewChooseCategoryPopup)
    }
    @IBAction func btnGo(_ sender: Any)
    {
        let arr: NSMutableArray = NSMutableArray.init(array: arrOfAllCategory)
        var flagIsSelect: Bool = false
        var dd: NSDictionary!
        for item in arr
        {
            dd = item as! NSDictionary
            if dd.object(forKey: "isSelected") as! String == "1"
            {
                flagIsSelect = true
                break
            }
        }
        if flagIsSelect == false
        {
            custObj.alertMessage("Please select category")
        }
        else
        {
            for item in arrOfSelectedCategory
            {
                let dd1: NSDictionary = item as! NSDictionary
                if dd1.object(forKey: "CategoryID") as! Int == selectedCateID// && selectedCateID != 0
                {
                    custObj.alertMessage("You have already added this category")
                    return
                }
            }
            deleObj.dictOfCategories.setValue(dd.object(forKey: "ID"), forKey: "CategoryID")
            deleObj.dictOfCategories.setValue(dd.object(forKey: "Name"), forKey: "CategoryName")
            custObj.bounceViewOut(true, view: viewChooseCategoryPopup)
            let obj: chooseJobTitle = self.storyboard?.instantiateViewController(withIdentifier: "chooseJobTitle") as! chooseJobTitle
            self.navigationController!.pushViewController(obj, animated: true)
//            if selectedCateID == 0
//            {
//                let alertController = UIAlertController(title: ALERT_TITLE, message: "Please enter your category name", preferredStyle: .alert)
//                
//                let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
//                    if let field = alertController.textFields?[0] {
//                        // store your data
//                        if field.text == ""
//                        {
//                            self.custObj.alertMessage("Please enter category name")
//                            return
//                        }
//                        if (field.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
//                        {
//                            self.custObj.alertMessage("Please enter category name")
//                            return
//                        }
//                        if self.deleObj.dictOfCategories.object(forKey: "CategoryID") as! Int != 0
//                        {
//                            self.deleObj.dictOfCategories.setValue("", forKey: "SkillNames")
//                            self.deleObj.dictOfCategories.setValue("", forKey: "TitleNames")
//                            self.deleObj.dictOfCategories.setValue([], forKey: "CerficateFile")
//                            self.deleObj.dictOfCategories.setValue("", forKey: "ExperienceMonth")
//                            self.deleObj.dictOfCategories.setValue("", forKey: "ExperienceYear")
//                            self.deleObj.dictOfCategories.setValue(true, forKey: "HaveExperience")
//                        }
//                        self.deleObj.dictOfCategories.setValue(0, forKey: "CategoryID")
//                        self.deleObj.dictOfCategories.setValue(field.text, forKey: "CategoryName")
//                        self.custObj.bounceViewOut(true, view: self.viewChooseCategoryPopup)
//                        let obj: chooseJobTitle = self.storyboard?.instantiateViewController(withIdentifier: "chooseJobTitle") as! chooseJobTitle
//                        self.navigationController!.pushViewController(obj, animated: true)
//                    } else {
//                        // user did not fill field
//                    }
//                }
//                
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//                
//                alertController.addTextField { (textField) in
//                    textField.placeholder = "Category Name"
//                }
//                
//                alertController.addAction(confirmAction)
//                alertController.addAction(cancelAction)
//                
//                self.present(alertController, animated: true, completion: nil)
//            }
//            else
//            {
//                deleObj.dictOfCategories.setValue(dd.object(forKey: "ID"), forKey: "CategoryID")
//                deleObj.dictOfCategories.setValue(dd.object(forKey: "Name"), forKey: "CategoryName")
//                custObj.bounceViewOut(true, view: viewChooseCategoryPopup)
//                let obj: chooseJobTitle = self.storyboard?.instantiateViewController(withIdentifier: "chooseJobTitle") as! chooseJobTitle
//                self.navigationController!.pushViewController(obj, animated: true)
//            }
        }
    }
    
    //MARK:- Custome View
    //MARK:- Refrence View
    func addNewReferenceView(dd: NSDictionary)
    {
        var tagToAssign : Int = 2000
        var newY : CGFloat = btnAddReferenceViewOutlet.frame.origin.y + btnAddReferenceViewOutlet.frame.size.height
        
        
        
        for item in scrlAdditionalInfo.subviews
        {
            if(item.tag >= 2000 && item.tag <= 3999)
            {
                //item.removeFromSuperview()
                tagToAssign = tagToAssign + 1
                newY = item.frame.origin.y + item.frame.size.height + 8
            }
        }
        let archive = NSKeyedArchiver.archivedData(withRootObject: viewReferenceMain)
        let viewReferenceCopy = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
        viewReferenceCopy.tag = tagToAssign
        viewReferenceCopy.frame = CGRect.init(x: 8, y: newY, width: viewReferenceCopy.frame.size.width, height: viewReferenceCopy.frame.size.height)
        viewReferenceCopy.layer.cornerRadius = 10.0
        viewReferenceCopy.layer.borderColor = API.dividerColor().cgColor
        viewReferenceCopy.layer.borderWidth = 1.0
        viewReferenceCopy.clipsToBounds = true
        viewReferenceCopy.backgroundColor = UIColor.clear
        scrlAdditionalInfo.addSubview(viewReferenceCopy)
        print(tagToAssign)
        
        let btnDelete : UIButton = viewReferenceCopy.viewWithTag(15) as! UIButton
        btnDelete.addTarget(self, action: #selector(self.btnDeleteReferenceAction(_:)), for: UIControlEvents.touchUpInside)
        btnDelete.tag = viewReferenceCopy.tag + (1000) + 15
        for case let txt as UITextField in viewReferenceCopy.subviews
        {
            txt.delegate = self
            if txt.tag == 11
            {
                txt.tag = 1//tagToAssign + 1
                txt.text = dd.object(forKey: "Name") as? String
            }
            if txt.tag == 12
            {
                txt.tag = 2//tagToAssign + 2
                txt.text = dd.object(forKey: "ContactNo") as? String
            }
            if txt.tag == 13
            {
                txt.tag = 3//tagToAssign + 3
                txt.text = dd.object(forKey: "Email") as? String
            }
            if txt.tag == 14
            {
                txt.tag = 4//tagToAssign + 4
                txt.text = dd.object(forKey: "NameOfOrg") as? String
            }
        }
//        for item in viewReferenceCopy.subviews
//        {
//            if(item is UITextField)
//            {
//                (item as! UITextField).delegate = self
//                (item as! UITextField).keyboardType = UIKeyboardType.default
//            }
//        }
        self.arrangeDynamicViews()
    }
    
    @IBAction func btnDeleteReferenceAction(_ sender: Any)
    {
        print((sender as! UIButton).tag)
        print(((sender as! UIButton).superview)! .tag)
        
        ((sender as! UIButton).superview)!.removeFromSuperview()
        self.arrangeDynamicViews()
        setUseInteraction(flag: true)
        btnEdit.setTitle("Save", for: UIControlState.normal)
    }
    //MARK:- Work History
    @IBAction func btnAddNewWorkHistoryAction(_ sender: Any)
    {
        var counter : Int = 0
        
        for item in scrlAdditionalInfo.subviews
        {
            if(item.tag >= 4000 && item.tag <= 5999)
            {
                counter = counter + 1
            }
        }
        
        if(counter >= 5)
        {
            custObj.alertMessage("You can not add more than Five Works of your past")
            return
        }
        
        let ddd: NSMutableDictionary = NSMutableDictionary()
        self.addNewWorkHistoryView(dd:ddd)
        btnEdit.setTitle("Save", for: UIControlState.normal)
        setUseInteraction(flag: true)
    }
    
    func addNewWorkHistoryView(dd: NSDictionary)
    {
        var tagToAssign : Int = 4000
        var newY : CGFloat = btnAddWorkHistoryOutlet.frame.origin.y + btnAddWorkHistoryOutlet.frame.size.height
        
        for item in scrlAdditionalInfo.subviews
        {
            if(item.tag >= 4000 && item.tag <= 5999)
            {
                //item.removeFromSuperview()
                tagToAssign = item.tag + 1
                
                newY = item.frame.origin.y + item.frame.size.height + 8
            }
        }
        
        
        let archive = NSKeyedArchiver.archivedData(withRootObject: viewWorkHistoryMain)
        let viewWorkHistoryCopy = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
        viewWorkHistoryCopy.tag = tagToAssign
        viewWorkHistoryCopy.frame = CGRect.init(x: 8, y: newY, width: viewWorkHistoryCopy.frame.size.width, height: viewWorkHistoryCopy.frame.size.height)
        viewWorkHistoryCopy.layer.cornerRadius = 10.0
        viewWorkHistoryCopy.layer.borderColor = API.dividerColor().cgColor
        viewWorkHistoryCopy.layer.borderWidth = 1.0
        viewWorkHistoryCopy.clipsToBounds = true
        viewWorkHistoryCopy.backgroundColor = API.lightGray()
        scrlAdditionalInfo.addSubview(viewWorkHistoryCopy)
        print(tagToAssign)
        let btnDelete : UIButton = viewWorkHistoryCopy.viewWithTag(26) as! UIButton
        btnDelete.addTarget(self, action: #selector(self.btnDeleteHistoryWorkAction(_:)), for: UIControlEvents.touchUpInside)
        btnDelete.tag = viewWorkHistoryCopy.tag + (1000) + 26
        
        
        for case let txt as UITextField in viewWorkHistoryCopy.subviews
        {
            txt.delegate = self
            if txt.tag == 21
            {
                txt.tag = 1//tagToAssign + 1
                txt.text = dd.object(forKey: "JobTitle") as? String
            }
            if txt.tag == 22
            {
                txt.tag = 2//tagToAssign + 2
                txt.text = dd.object(forKey: "NameOfCompany") as? String
            }
            if txt.tag == 23
            {
                txt.tag = 3//tagToAssign + 3
                txt.text = dd.object(forKey: "StartDate") as? String
            }
            if txt.tag == 24
            {
                txt.tag = 4//tagToAssign + 4
                txt.text = dd.object(forKey: "EndDate") as? String
            }
            if txt.tag == 25
            {
                txt.tag = 5//tagToAssign + 5
                txt.text = dd.object(forKey: "KeyRole") as? String
            }
        }
        
//        for item in viewWorkHistoryCopy.subviews
//        {
//            if(item is UITextField)
//            {
//                (item as! UITextField).delegate = self
//                (item as! UITextField).keyboardType = UIKeyboardType.default
//            }
//        }
        // let txtRVName : UITextField = viewWorkHistoryCopy.viewWithTag(26) as! UITextField
        
        self.arrangeDynamicViews()
    }
    
    @IBAction func btnDeleteHistoryWorkAction(_ sender: Any)
    {
        print((sender as! UIButton).tag)
        print(((sender as! UIButton).superview)! .tag)
        
        ((sender as! UIButton).superview)!.removeFromSuperview()
        
        self.arrangeDynamicViews()
        setUseInteraction(flag: true)
        btnEdit.setTitle("Save", for: UIControlState.normal)
    }
    
    func arrangeDynamicViews()
    {
        //        var tagToAssign : Int = 2000
        
        var newY : CGFloat = btnAddReferenceViewOutlet.frame.origin.y + btnAddReferenceViewOutlet.frame.size.height
        
        for item in scrlAdditionalInfo.subviews
        {
            if(item.tag >= 2000 && item.tag <= 3999)
            {
                item.frame = CGRect.init(x: 8, y: newY, width: item.frame.size.width, height: item.frame.size.height)
                //                item.tag = tagToAssign
                //                tagToAssign = item.tag + 1
                newY = item.frame.origin.y + item.frame.size.height + 8
            }
        }
        
        newY = newY + 5
        lblWorkHistoryTitle.frame = CGRect.init(x: lblWorkHistoryTitle.frame.origin.x, y: newY, width: lblWorkHistoryTitle.frame.size.width, height: lblWorkHistoryTitle.frame.size.height)
        btnAddWorkHistoryOutlet.frame = CGRect.init(x: btnAddWorkHistoryOutlet.frame.origin.x, y: newY - 6, width: btnAddWorkHistoryOutlet.frame.size.width, height: btnAddWorkHistoryOutlet.frame.size.height)
        
        newY = btnAddWorkHistoryOutlet.frame.origin.y + btnAddWorkHistoryOutlet.frame.size.height
        
        //        tagToAssign = 4000
        for item in scrlAdditionalInfo.subviews
        {
            if(item.tag >= 4000 && item.tag <= 5999)
            {
                item.frame = CGRect.init(x: 8, y: newY, width: item.frame.size.width, height: item.frame.size.height)
                //                item.tag = tagToAssign
                //                tagToAssign = item.tag + 1
                newY = item.frame.origin.y + item.frame.size.height + 8
            }
        }
        
        scrlAdditionalInfo.contentSizeToFit()
    }
    
    func arrangeDynamicViewsGeneralTab()
    {
        var newY : CGFloat = btnAddSkillCategoryOutlet.frame.origin.y + btnAddSkillCategoryOutlet.frame.size.height
        for item in scrlGeneralInfo.subviews
        {
            if(item.tag >= 6000 && item.tag <= 7999)
            {
                item.frame = CGRect.init(x: 8, y: newY, width: item.frame.size.width, height: item.frame.size.height)
                //                item.tag = tagToAssign
                //                tagToAssign = item.tag + 1
                newY = item.frame.origin.y + item.frame.size.height + 8
            }
        }
        
        newY = newY + 5
        viewIdVerificationContainer.frame = CGRect.init(x: viewIdVerificationContainer.frame.origin.x, y: newY, width: viewIdVerificationContainer.frame.size.width, height: viewIdVerificationContainer.frame.size.height)
        
        scrlGeneralInfo.contentSizeToFit()
    }
    //MARK:- collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrOFID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "certificateCell", for: indexPath as IndexPath) as! certificateCell
        
        let dd: NSDictionary = arrOFID.object(at: indexPath.row) as! NSDictionary
        cell.lblCertificateName.text = dd.object(forKey: "ProofName") as? String
        
        if dd.object(forKey: "hasPathImage") as! Bool == false
        {
            cell.imgCertificate.image = dd.object(forKey: "OriImage") as? UIImage
        }
        else
        {
            cell.imgCertificate.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "Path") as? String)!) as URL!, placeholderImage: nil)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dd: NSDictionary = arrOFID.object(at: indexPath.row) as! NSDictionary
        if (dd.object(forKey: "Path") as! String) != ""
        {
            let obj: zoomImageViewClass = self.storyboard?.instantiateViewController(withIdentifier: "zoomImageViewClass") as! zoomImageViewClass
            obj.strImageUrl = (dd.object(forKey: "Path") as! String)
            self.navigationController!.pushViewController(obj, animated: true)
        }
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if txtDOB == textField
        {
            view.endEditing(true)
            let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
            obj.objSeekerProfile = self
            obj.fromWhere = "seekerProfile"
            obj.strForDateOrTime = "date"
            self.present(obj, animated: true, completion: nil)
            return false
        }
        if textField == txtWorkingRights
        {
            view.endEditing(true)
//            let obj: pickerClass = self.storyboard?.instantiateViewController(withIdentifier: "pickerClass") as! pickerClass
//            obj.objSeekerProfile = self
//            obj.fromWhere = "seekerProfile"
//            obj.arrOfPicker = arrOfWorkingRights
//            self.present(obj, animated: true, completion: nil)
            let obj: abortJobClass = self.storyboard?.instantiateViewController(withIdentifier: "abortJobClass") as! abortJobClass
            obj.objSeekerProfile = self
            obj.fromWhere = "profile"
            self.present(obj, animated: true, completion: nil)
            return false
        }
        let tagSuperView: Int = (textField.superview?.tag)! // decrease 1000 from tagSuperView to get array index
        var tagTextField: Int = textField.tag
        
        print(tagSuperView)
        print(tagTextField)
//        if tagTextField != 0
//        {
//            
//        }
        if tagSuperView >= 2000 && tagSuperView <= 3999
        {
            
        }
        else if tagSuperView >= 4000 && tagSuperView <= 5999
        {
            if tagTextField == 3
            {
                tempTextField = textField
                view.endEditing(true)
                let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
                obj.objSeekerProfile = self
                obj.fromWhere = "seekerProfileHistroy"
                obj.strForDateOrTime = "date"
                self.present(obj, animated: true, completion: nil)
                return false
                // start date
            }
            if tagTextField == 4
            {
                tempTextField = textField
                view.endEditing(true)
                let obj: datePickerClass = self.storyboard?.instantiateViewController(withIdentifier: "datePickerClass") as! datePickerClass
                obj.objSeekerProfile = self
                obj.fromWhere = "seekerProfileHistroy"
                obj.strForDateOrTime = "date"
                self.present(obj, animated: true, completion: nil)
                return false
                //end date
            }
        }
        else if tagSuperView >= 6000
        {
            tagTextField = tagTextField - tagSuperView
            if arrOfSelectedCategory.count == 0
            {
                deleObj.isForCatEdit = false
                deleObj.dictOfCategories = NSMutableDictionary()
            }
            else
            {
                deleObj.isForCatEdit = true
                deleObj.arrIndexForCatEdit =  tagSuperView - 6000 //(tagSuperView / 6000) - 1
                print(deleObj.arrIndexForCatEdit)
                let dd: NSDictionary = arrOfSelectedCategory.object(at: deleObj.arrIndexForCatEdit) as! NSDictionary
                deleObj.dictOfCategories = NSMutableDictionary.init(dictionary: dd)
                selectedCateID = deleObj.dictOfCategories.object(forKey: "CategoryID") as! Int
                print(deleObj.dictOfCategories)
            }
            
            if tagTextField == 2
            {
                //category - Open Popup
                custObj.bounceView(in: true, view: viewChooseCategoryPopup)
                arrOfAllCategory = NSMutableArray.init(array: arrOfAllCategoryTemp)
                tblCategory.reloadData()
                txtSearch.text = ""
                return false
            }
            else if tagTextField == 3
            {
                //job title
                let obj: chooseJobTitle = self.storyboard?.instantiateViewController(withIdentifier: "chooseJobTitle") as! chooseJobTitle
                self.navigationController!.pushViewController(obj, animated: true)
                return false
            }
            else if tagTextField == 4
            {
                //certification
                let obj: chooseCertification = self.storyboard?.instantiateViewController(withIdentifier: "chooseCertification") as! chooseCertification
                self.navigationController!.pushViewController(obj, animated: true)
                return false
            }
            else if tagTextField == 5
            {
                //core skill
                let obj: chooseCoreSkill = self.storyboard?.instantiateViewController(withIdentifier: "chooseCoreSkill") as! chooseCoreSkill
                self.navigationController!.pushViewController(obj, animated: true)
                return false
            }
            else if tagTextField == 6
            {
                //experience
                let obj: setExpSeeker = self.storyboard?.instantiateViewController(withIdentifier: "setExpSeeker") as! setExpSeeker
                self.navigationController!.pushViewController(obj, animated: true)
                return false
            }
        }
        
        
        
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if txtSearch == textField
        {
            view.endEditing(true)
        }
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
        else if textField == txtLocation
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
        else if textField == txtSearch
        {
            var serachText = ""
            if txtSearch.text?.characters.count == 0
            {
                serachText = string
            }
            else if range.location > 0 && range.length == 1 && string.characters.count == 0 {
                serachText = (txtSearch.text?.substring(to: (txtSearch.text?.index((txtSearch.text?.startIndex)!, offsetBy: (txtSearch.text?.characters.count)! - 1))!))!
            }
            else if string.characters.count == 0 && txtSearch.text?.characters.count == 1 {
                serachText = ""
            }
            else if string.characters.count == 0 && (txtSearch.text?.characters.count)! > 1
            {
                serachText = ""
            }
            else
            {
                serachText = (txtSearch.text?.appending(string))!
            }
            if serachText == ""
            {
                arrOfAllCategory = NSMutableArray.init(array: arrOfAllCategoryTemp)
                tblCategory.reloadData()
            }
            else
            {
                arrOfAllCategory = NSMutableArray()
                for item in arrOfAllCategoryTemp
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    let str: String = dd.object(forKey: "Name") as! String
                    if str.lowercased().contains(serachText.lowercased())
                    {
                        arrOfAllCategory.add(dictMutable)
                    }
                }
                tblCategory.reloadData()
            }
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
        if tableView == tblLocation
        {
            return arrOfLocation.count
        }
        return arrOfAllCategory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblLocation
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
            cell.imgLocatiobIcon.tintColor = API.blackColor()
            
            let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
            cell.lblLocationName?.text = dd.object(forKey: "description") as? String
            //cell.lblLocationName?.text = (dd.object(forKey: "structured_formatting") as AnyObject).object(forKey:"main_text") as? String
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let dd: NSDictionary = arrOfAllCategory.object(at: indexPath.row) as! NSDictionary
            cell.lblCategoryName.text = dd.object(forKey: "Name") as? String
            if dd.object(forKey: "isSelected") as! String == "0"
            {
                cell.btnCheckedCate.isSelected = false
            }
            else
            {
                cell.btnCheckedCate.isSelected = true
            }
            cell.btnCheckedCate.tag = indexPath.row
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblLocation
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
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblLocation
        {
            return 36
        }
        return 44
    }
    //MARK:- Set Profile
    func setProfile()
    {
        print(API.getLoggedUserData())
        let dd: NSDictionary = API.getLoggedUserData()
        dictUserData = NSMutableDictionary.init(dictionary: dd)
        imgUserPhoto.sd_setImage(with: NSURL.init(string: (dictUserData.object(forKey: "ProfilePic") as? String)!) as URL!, placeholderImage: UIImage.init(named: "userPlaceholder"))
        
        
        if dictUserData.object(forKey: "ProfilePic") as! String != ""
        {
            lblUploadPic.isHidden = true
        }
        
        lblCompanyName.text = dictUserData.object(forKey: "NameOfBusiness") as? String
        txtFirstName.text = dictUserData.object(forKey: "FirstName") as? String
        txtLastName.text = dictUserData.object(forKey: "LastName") as? String
        txtEmail.text = dictUserData.object(forKey: "EmailID") as? String
        txtMobile.text = dictUserData.object(forKey: "MobileNo") as? String
        txtABN.text = dictUserData.object(forKey: "ABN") as? String
        txtWorkingRange.text = dictUserData.object(forKey: "WorkingRange") as? String
        txtDOB.text = dictUserData.object(forKey: "DOB") as? String
        tvAbout.text = dictUserData.object(forKey: "AboutYou") as? String
        tvLocation.text = dictUserData.object(forKey: "LocationName") as? String
        lblAboutCharLeft.text = String(format: "%d Left", 300 - tvAbout.text.length)
        strLat = dictUserData.object(forKey: "Latitude") as! String
        strLong = dictUserData.object(forKey: "Longitude") as! String
        WorkingRightID = dictUserData.object(forKey: "WorkingRightID") as! Int
        let strGender: String = dictUserData.object(forKey: "Gender") as! String
        if strGender.lowercased() == "Male".lowercased()
        {
            btnMale.isSelected = true
            btnFemale.isSelected = false
            btnOther.isSelected = false
        }
        else if strGender.lowercased() == "Female".lowercased()
        {
            btnMale.isSelected = false
            btnFemale.isSelected = true
            btnOther.isSelected = false
        }
        else
        {
            btnMale.isSelected = false
            btnFemale.isSelected = false
            btnOther.isSelected = true
        }
        
        let isVehivle: Bool = dictUserData.object(forKey: "IsVehicle") as! Bool
        if isVehivle == true
        {
            btnYes.isSelected = true
            btnNo.isSelected = false
        }
        else
        {
            btnYes.isSelected = false
            btnNo.isSelected = true
        }
        
        txtWorkingRights.text = dictUserData.object(forKey: "WorkingRightName") as? String
        
        
        //Arrange category
        
        let arr: NSArray = dictUserData.object(forKey: "SeekerCategory") as! NSArray
        arrOfSelectedCategory = NSMutableArray.init(array: arr)
        for item in arrOfSelectedCategory
        {
            let dd: NSDictionary = item as! NSDictionary
            addNewSkillCategoryView(dd: dd)
        }
        
        //ID PROOF
        arrOFID = NSMutableArray()
        let arrIDProof: NSArray = dictUserData.object(forKey: "SeekerIDProof") as! NSArray
        for item in arrIDProof
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            dictMutable.setValue(true, forKey: "hasImage")
            dictMutable.setValue(true, forKey: "hasPathImage")
            dictMutable.setValue(UIImage(), forKey: "OriImage")
            if dd.object(forKey: "ID") as! Int == 0
            {
                dictMutable.setValue(true, forKey: "isExtra")
            }
            else
            {
                dictMutable.setValue(false, forKey: "isExtra")
            }
            if dd.object(forKey: "Path") as! String == ""
            {
                dictMutable.setValue(false, forKey: "hasImage")
            }
            else
            {
                dictMutable.setValue(true, forKey: "hasImage")
            }
            arrOFID.add(dictMutable)
        }
        cvIDProof.reloadData()
        
        
        //Refrence
        
        let aa: NSArray = dictUserData.object(forKey: "SeekerRef") as! NSArray
        arrOfReference = NSMutableArray.init(array: aa)

        for item in arrOfReference
        {
            let dd: NSDictionary = item as! NSDictionary
            addNewReferenceView(dd: dd)
        }
        
          
        //WorkHistory
        let aaW: NSArray = dictUserData.object(forKey: "SeekerWorkHistory") as! NSArray
        arrOfWorkHistory = NSMutableArray.init(array: aaW)
        
//        var dictHis: NSMutableDictionary = NSMutableDictionary()
//        dictHis.setValue("child care", forKey: "JobTitle")
//        dictHis.setValue("brains", forKey: "NameOfCompany")
//        dictHis.setValue("02/20/2017", forKey: "StartDate")
//        dictHis.setValue("02/032017", forKey: "EndDate")
//        dictHis.setValue("brainstorm", forKey: "KeyRole")
//        arrOfWorkHistory.add(dictHis)
//        
//        dictHis = NSMutableDictionary()
//        dictHis.setValue("child caref dff", forKey: "JobTitle")
//        dictHis.setValue("brains dsf", forKey: "NameOfCompany")
//        dictHis.setValue("02/20/2016", forKey: "StartDate")
//        dictHis.setValue("02/032016", forKey: "EndDate")
//        dictHis.setValue("brainstormfjkhgjh", forKey: "KeyRole")
//        arrOfWorkHistory.add(dictHis)
        
        for item in arrOfWorkHistory
        {
            let dd: NSDictionary = item as! NSDictionary
            addNewWorkHistoryView(dd: dd)
        }
        
        setUseInteraction(flag: false)
    }
    //MARK:- API CALL
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
        
        
        let dictTemp: NSMutableDictionary = NSMutableDictionary.init(dictionary: parameter)
        
        let arrID: NSArray = dictTemp.object(forKey: "IDProof") as! NSArray
        let arrIDMutable: NSMutableArray = NSMutableArray()
        for item in arrID
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            dictMutable.removeObjects(forKeys: ["OriImage","hasImage","isExtra"])
            arrIDMutable.add(dictMutable)
        }
        dictTemp.setValue(arrIDMutable, forKey: "IDProof")
        print(dictTemp)
        
        let arrCate: NSArray = dictTemp.object(forKey: "SeekerCategory") as! NSArray
        let arrCateMutable: NSMutableArray = NSMutableArray()
        for item in arrCate
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            let arrCert: NSArray = dictMutable.object(forKey: "CerficateFile") as! NSArray
            let arrCertTemp: NSMutableArray = NSMutableArray()
            for cert in arrCert
            {
                let ddCert: NSDictionary = cert as! NSDictionary
                let ddCertMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: ddCert)
                ddCertMutable.removeObjects(forKeys: ["OriImage","hasImage","isExtra"])
                arrCertTemp.add(ddCertMutable)
            }
            dictMutable.setValue(arrCertTemp, forKey: "CerficateFile")
            arrCateMutable.add(dictMutable)
        }
        dictTemp.setValue(arrCateMutable, forKey: "SeekerCategory")
        print(dictTemp)
        
        
        
        custObj.showSVHud("Loading")
        
        API.callApiPOST(strUrl: API_SEEKER_EDIT,parameter: dictTemp, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let firstObj: NSArray = response.object(forKey: "Data") as! NSArray
                let result: NSDictionary = firstObj.object(at: 0) as! NSDictionary
                let dictData: NSMutableDictionary = NSMutableDictionary.init(dictionary: result)
                //let dictData: NSMutableDictionary = self.custObj.dictionaryByReplacingNulls(withStrings:result.mutableCopy() as! NSMutableDictionary)
                self.dictUserData = dictData
                API.setXMPPUSER(type: dictData.object(forKey: JID) as! String)
                API.setXMPPPWD(type: dictData.object(forKey: "JPassword") as! String)
                API.setLoggedUserData(dict: dictData)
                API.setUserId(user_id: dictData.object(forKey: "UserID") as! String)
                
                self.btnEdit.setTitle("Edit", for: UIControlState.normal)
                self.setUseInteraction(flag: false)
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
                self.imgUserPhoto.image = image
                self.lblUploadPic.isHidden = true
                let firstObj: NSArray = response.object(forKey: "Data") as! NSArray
                let result: NSDictionary = firstObj.object(at: 0) as! NSDictionary
                let dictData: NSMutableDictionary = NSMutableDictionary.init(dictionary: result)
                //let dictData: NSMutableDictionary = self.custObj.dictionaryByReplacingNulls(withStrings:result.mutableCopy() as! NSMutableDictionary)
                
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
    func getAllCategories()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        print(parameter)
        API.callApiPOST(strUrl: API_GET_ALL_CATEGPRY,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                var i: Int = 0
                self.arrOfAllCategory = NSMutableArray()
                self.arrOfAllCategoryTemp = NSMutableArray()
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    dictMutable.setValue(i, forKey: "arrIndex")
                    dictMutable.setValue("0", forKey: "isSelected")
                    self.arrOfAllCategory.add(dictMutable)
                    self.arrOfAllCategoryTemp.add(dictMutable)
                    i = i + 1
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblCategory.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func GetAllWorkingRight()
    {
        //custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        print(parameter)
        API.callApiPOST(strUrl: API_GetAllWorkingRight,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfWorkingRights = NSMutableArray.init(array: arr)
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblCategory.reloadData()
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
