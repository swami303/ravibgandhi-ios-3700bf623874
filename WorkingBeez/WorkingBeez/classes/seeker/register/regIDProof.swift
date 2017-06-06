//
//  regIDProof.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/22/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class regIDProof: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var cvIdProof: UICollectionView!
    @IBOutlet weak var viewStep: UIView!
    
    
    var deleObj: AppDelegate!
    var arrOFID: NSMutableArray = NSMutableArray()
    var arrOFIDFromEditProfile: NSMutableArray = NSMutableArray()
    var selectedIndex: Int = 0
    var maxImageCounter: Int = 0
    var remianMaxCnt: Int = 2
    var removeID: Int = 0
    
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        if deleObj.isForSeekerEdit == true
        {
            viewStep.isHidden = true
            cvIdProof.frame = CGRect.init(x: cvIdProof.frame.origin.x, y: cvIdProof.frame.origin.y - 20, width: cvIdProof.frame.size.width, height: cvIdProof.frame.size.height + 20)
        }
        cvIdProof.delegate = self
        cvIdProof.dataSource = self
        self.navigationController?.navigationBar.isTranslucent = false 
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        layout.itemSize = CGSize(width: (95*width)/320, height: (110*height)/568)
        cvIdProof!.collectionViewLayout = layout
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        if deleObj.isForSeekerEdit == true
        {
            for item in arrOFIDFromEditProfile
            {
                let dd: NSDictionary = item as! NSDictionary
                if dd.object(forKey: "isExtra") as! Bool == true
                {
                    remianMaxCnt = remianMaxCnt - 1
                }
            }
            if remianMaxCnt == 0
            {
                maxImageCounter = arrOFIDFromEditProfile.count
            }
            else if remianMaxCnt == 1
            {
                maxImageCounter = arrOFIDFromEditProfile.count + 1
            }
            else
            {
                maxImageCounter = arrOFIDFromEditProfile.count + 2
            }
            arrOFID = NSMutableArray.init(array: arrOFIDFromEditProfile)
            cvIdProof.reloadData()
        }
        else
        {
            getAllIDPROOF()
        }
        print(self.arrOFID)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnFinish(_ sender: Any)
    {
        var flagAll: Bool = true
        for item in arrOFID
        {
            let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "hasImage") as! Bool == true
            {
                flagAll = false
                break
            }
        }
        
        if flagAll == true
        {
            custObj.alertMessage("Please upload atleast one ID proof")
            return
        }
        
        if deleObj.isForSeekerEdit == true
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadIDProofProfile"), object: arrOFID)
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            deleObj.dictSeekerReg.setValue(arrOFID, forKey: "IDProof")
            seekerRegister()
        }
    }
    @IBAction func btnRemoveID(_ sender: Any)
    {
        removeID = (sender as AnyObject).tag
        if deleObj.isForSeekerEdit == true
        {
            let dd: NSDictionary = self.arrOFID.object(at: self.removeID) as! NSDictionary
            if dd.object(forKey: "hasPathImage") as! Bool == false
            {
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                dictMutable.setValue(UIImage(), forKey: "OriImage")
                dictMutable.setValue(false, forKey: "hasImage")
                dictMutable.setValue("", forKey: "Path")
                arrOFID.replaceObject(at: (sender as AnyObject).tag, with: dictMutable)
            }
            else
            {
                removeIDProof()
            }
        }
        else
        {
            let dd: NSDictionary = arrOFID.object(at: (sender as AnyObject).tag) as! NSDictionary
            if dd.object(forKey: "isExtra") as! Bool == true
            {
                arrOFID.removeObject(at: (sender as AnyObject).tag)
                self.remianMaxCnt = self.remianMaxCnt + 1
            }
            else
            {
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                dictMutable.setValue(UIImage(), forKey: "OriImage")
                dictMutable.setValue(false, forKey: "hasImage")
                dictMutable.setValue("", forKey: "Path")
                print(dictMutable)
                arrOFID.replaceObject(at: (sender as AnyObject).tag, with: dictMutable)
            }
        }
        cvIdProof.reloadData()
    }
    @IBAction func btnAddMore(_ sender: Any)
    {
        if arrOFID.count == maxImageCounter
        {
            return
        }
        let alertController = UIAlertController(title: ALERT_TITLE, message: "Please enter ID proof name", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Done", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                if field.text == ""
                {
                    self.custObj.alertMessage("Please enter ID proof name")
                    return
                }
                if (field.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
                {
                    self.custObj.alertMessage("Please enter ID proof name")
                    return
                }
                let dictMutable: NSMutableDictionary = NSMutableDictionary()
                dictMutable.setValue(UIImage(), forKey: "OriImage")
                dictMutable.setValue(false, forKey: "hasImage")
                dictMutable.setValue(true, forKey: "isExtra")
                dictMutable.setValue(false, forKey: "hasPathImage")
                dictMutable.setValue(0, forKey: "ID")
                dictMutable.setValue("", forKey: "Path")
                dictMutable.setValue(field.text, forKey: "ProofName")
                self.remianMaxCnt = self.remianMaxCnt - 1
                self.arrOFID.add(dictMutable)
                print(self.arrOFID)
                self.cvIdProof.reloadData()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "ID Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if arrOFID.count == maxImageCounter
        {
            return arrOFID.count
        }
        return arrOFID.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.row == arrOFID.count
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addMoreCell", for: indexPath as IndexPath) as! certificateCell
            cell.lblMaxCounter.text = String(format: "Max %d", remianMaxCnt)
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "certificateCell", for: indexPath as IndexPath) as! certificateCell
            
            let dd: NSDictionary = arrOFID.object(at: indexPath.row) as! NSDictionary
            cell.lblCertificateName.text = dd.object(forKey: "ProofName") as? String
            if dd.object(forKey: "hasPathImage") as! Bool == true
            {
                cell.imgCertificate.sd_setImage(with: NSURL.init(string: (dd.object(forKey: "Path") as? String)!) as URL!, placeholderImage: nil)
            }
            else
            {
                cell.imgCertificate.image = dd.object(forKey: "OriImage") as? UIImage
            }
            cell.btnRemoveCertificate.tag = indexPath.row
            if dd.object(forKey: "hasImage") as! Bool == true || dd.object(forKey: "isExtra") as! Bool == true
            {
                cell.btnRemoveCertificate.isHidden = false
            }
            else
            {
                cell.btnRemoveCertificate.isHidden = true
            }
            if dd.object(forKey: "hasImage") as! Bool == true
            {
                cell.lblTapToChoose.isHidden = true
            }
            else
            {
                cell.lblTapToChoose.isHidden = false
            }
            
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedIndex = indexPath.row
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.navigationController!.dismiss(animated: true, completion: { _ in })
        let image: UIImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        
        uploadCerti(image: image)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.navigationController!.dismiss(animated: true, completion: { _ in })
    }
    
    //MARK:- Call API
    func uploadCerti(image:UIImage)
    {
        let imageString: String = API.encodeBase64FromData(UIImageJPEGRepresentation(image, 0.7)!)
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(imageString, forKey: "Data")
        print(parameter)
        API.callApiPOST(strUrl: AddTempImage,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let dd: NSDictionary = self.arrOFID.object(at: self.selectedIndex) as! NSDictionary
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                dictMutable.setValue(response.object(forKey: "ReturnValue") as! String, forKey: "Path")
                self.arrOFID.replaceObject(at: self.selectedIndex, with: dictMutable)
                dictMutable.setValue(image, forKey: "OriImage")
                dictMutable.setValue(true, forKey: "hasImage")
                dictMutable.setValue(false, forKey: "hasPathImage")
                self.arrOFID.replaceObject(at: self.selectedIndex, with: dictMutable)
                self.cvIdProof.reloadData()
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
    func getAllIDPROOF()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        print(parameter)
        API.callApiPOST(strUrl: API_GET_ALL_ID_PROOF,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                var i: Int = 0
                self.arrOFID = NSMutableArray()
                
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    var dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    dictMutable.setValue(UIImage(), forKey: "OriImage")
                    dictMutable.setValue(false, forKey: "hasImage")
                    dictMutable.setValue(false, forKey: "isExtra")
                    dictMutable.setValue(false, forKey: "hasPathImage")
                    dictMutable.setValue("", forKey: "Path")
                    self.arrOFID.add(dictMutable)
                    i = i + 1
                }
                self.maxImageCounter = self.arrOFID.count
                self.maxImageCounter = self.maxImageCounter + 2
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.cvIdProof.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func removeIDProof()
    {
        let dd: NSDictionary = self.arrOFID.object(at: self.removeID) as! NSDictionary
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dd.object(forKey: "SeekerProofID"), forKey: "SeekerProofID")
        print(parameter)
        API.callApiPOST(strUrl: API_DeleteIDProofs,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                
                if dd.object(forKey: "isExtra") as! Bool == true
                {
                    self.arrOFID.removeObject(at: self.removeID)
                    self.remianMaxCnt = self.remianMaxCnt + 1
                }
                else
                {
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    dictMutable.setValue(UIImage(), forKey: "OriImage")
                    dictMutable.setValue(false, forKey: "hasImage")
                    dictMutable.setValue("", forKey: "Path")
                    print(dictMutable)
                    self.arrOFID.replaceObject(at: self.removeID, with: dictMutable)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadIDProofProfile"), object: self.arrOFID)
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.cvIdProof.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    
    //MARK:- Call API
    func seekerRegister()
    {
        let dictTemp: NSMutableDictionary = NSMutableDictionary.init(dictionary: deleObj.dictSeekerReg)
        
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
        
        API.callApiPOST(strUrl: API_SEEKER_REGISTER,parameter: dictTemp, success: { (response) in
            
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
                let dashboard: dashboardSeeker = self.storyboard!.instantiateViewController(withIdentifier: "dashboardSeeker") as! dashboardSeeker
                let homeNavigation = UINavigationController(rootViewController: dashboard)
                let window = UIApplication.shared.delegate!.window!!
                window.rootViewController = homeNavigation
                UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve], animations: nil, completion: nil)
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
