//
//  uploadCertiClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class uploadCertiClass: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    //MARK:- Outlet
    @IBOutlet weak var lblStep1: cLable!
    @IBOutlet weak var lblStep2: cLable!
    @IBOutlet weak var lblStep3: cLable!
    @IBOutlet weak var lblStep4: cLable!
    @IBOutlet weak var lblStep5: cLable!
    @IBOutlet weak var viewStep: UIView!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    
    @IBOutlet weak var cvCertificate: UICollectionView!
    @IBOutlet weak var viewAddCertificate: UIView!
    
    var arrOfCertiToUpload: NSMutableArray = NSMutableArray()
    var deleObj: AppDelegate!
    var selectedIndex: Int = 0
    var maxImageCounter: Int = 0
    var remianMaxCnt: Int = 2
    var strWhichStep: String = "1"
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        if deleObj.isForSeekerEdit == true
        {
            viewStep.isHidden = true
            viewAddCertificate.frame = CGRect.init(x: viewAddCertificate.frame.origin.x, y: viewAddCertificate.frame.origin.y - 20, width: viewAddCertificate.frame.size.width, height: viewAddCertificate.frame.size.height + 20)
            let arrTemp: NSArray = deleObj.dictOfCategories.value(forKey: "CerficateFile") as! NSArray
            for item in arrTemp
            {
                let dd: NSDictionary = item as! NSDictionary
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                dictMutable.setValue("", forKey: "CertificateImage")
                dictMutable.setValue(UIImage(), forKey: "OriImage")
                dictMutable.setValue(false, forKey: "hasImage")
                dictMutable.setValue(false, forKey: "isExtra")
                arrOfCertiToUpload.add(dictMutable)
            }
            print(arrOfCertiToUpload)
            maxImageCounter = arrOfCertiToUpload.count
            maxImageCounter = maxImageCounter + 2
        }
        else
        {
            let arrTemp: NSArray = deleObj.dictOfCategories.value(forKey: "CerficateFile") as! NSArray
            for item in arrTemp
            {
                let dd: NSDictionary = item as! NSDictionary
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                dictMutable.setValue("", forKey: "CertificateImage")
                dictMutable.setValue(UIImage(), forKey: "OriImage")
                dictMutable.setValue(false, forKey: "hasImage")
                dictMutable.setValue(false, forKey: "isExtra")
                arrOfCertiToUpload.add(dictMutable)
            }
            print(arrOfCertiToUpload)
            maxImageCounter = arrOfCertiToUpload.count
            maxImageCounter = maxImageCounter + 2
        }
        cvCertificate.delegate = self
        cvCertificate.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (95*width)/320, height: (110*height)/568)
        cvCertificate!.collectionViewLayout = layout
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Action Zone
    
    @IBAction func btnNext(_ sender: Any)
    {
//        var flagChoosedAllCerti: Bool = true
//        for item in arrOfCertiToUpload
//        {
//            let dd: NSDictionary = item as! NSDictionary
//            if dd.object(forKey: "hasImage") as! Bool == false
//            {
//                flagChoosedAllCerti = false
//            }
//        }
//        if flagChoosedAllCerti == false
//        {
//            custObj.alertMessage("Please upload all selected certificates")
//            return
//        }
        var flag: Bool = false
        for item in arrOfCertiToUpload
        {
            let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "IsRequired") as! Bool == true && dd.object(forKey: "hasImage") as! Bool == false
            {
                flag = true
                break
            }
        }
        if flag == true
        {
            custObj.alertMessage("Please upload all mandatory certificates")
            return
        }
        deleObj.dictOfCategories.setValue(arrOfCertiToUpload, forKey: "CerficateFile")
        print(deleObj.dictOfCategories)
        let obj: chooseCoreSkill = self.storyboard?.instantiateViewController(withIdentifier: "chooseCoreSkill") as! chooseCoreSkill
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnAddMoreCerti(_ sender: Any)
    {
        if arrOfCertiToUpload.count == maxImageCounter
        {
            return
        }
        
        let alertController = UIAlertController(title: ALERT_TITLE, message: "Please enter certificate name", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Done", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                if field.text == ""
                {
                    self.custObj.alertMessage("Please enter certificate name")
                    return
                }
                if (field.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
                {
                    self.custObj.alertMessage("Please enter certificate name")
                    return
                }
                let dictMutable: NSMutableDictionary = NSMutableDictionary()
                dictMutable.setValue("", forKey: "CertificateImage")
                dictMutable.setValue(UIImage(), forKey: "OriImage")
                dictMutable.setValue(false, forKey: "hasImage")
                dictMutable.setValue(true, forKey: "isExtra")
                dictMutable.setValue(true, forKey: "IsRequired")
                dictMutable.setValue(0, forKey: "CertificateID")
                dictMutable.setValue(field.text, forKey: "CertificateName")
                self.remianMaxCnt = self.remianMaxCnt - 1
                self.arrOfCertiToUpload.add(dictMutable)
                print(self.arrOfCertiToUpload)
                self.cvCertificate.reloadData()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Certificate Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func btnRemoveCerti(_ sender: Any)
    {
        let dd: NSDictionary = arrOfCertiToUpload.object(at: (sender as AnyObject).tag) as! NSDictionary
        if dd.object(forKey: "isExtra") as! Bool == true
        {
            arrOfCertiToUpload.removeObject(at: (sender as AnyObject).tag)
            self.remianMaxCnt = self.remianMaxCnt + 1
        }
        else
        {
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            dictMutable.setValue(UIImage(), forKey: "OriImage")
            dictMutable.setValue(false, forKey: "hasImage")
            dictMutable.setValue("", forKey: "CertificateImage")
            print(dictMutable)
            arrOfCertiToUpload.replaceObject(at: (sender as AnyObject).tag, with: dictMutable)
        }
        print(arrOfCertiToUpload)
        cvCertificate.reloadData()
    }
    //MARK:- collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if arrOfCertiToUpload.count == maxImageCounter
        {
            return arrOfCertiToUpload.count
        }
        return arrOfCertiToUpload.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if indexPath.row == arrOfCertiToUpload.count
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addMoreCell", for: indexPath as IndexPath) as! certificateCell
            cell.lblMaxCounter.text = String(format: "Max %d", remianMaxCnt)
            return cell
        }
        else
        {
            let dd: NSDictionary = arrOfCertiToUpload.object(at: indexPath.row) as! NSDictionary
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "certificateCell", for: indexPath as IndexPath) as! certificateCell
            cell.lblCertificateName.text = dd.object(forKey: "CertificateName") as? String
            cell.imgCertificate.image = dd.object(forKey: "OriImage") as? UIImage
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
            
            if dd.object(forKey: "IsRequired") as! Bool == true
            {
                cell.lblCertiStatus.isHidden = false
            }
            else
            {
                cell.lblCertiStatus.isHidden = true
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
                let dd: NSDictionary = self.arrOfCertiToUpload.object(at: self.selectedIndex) as! NSDictionary
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                dictMutable.setValue(response.object(forKey: "ReturnValue") as! String, forKey: "CertificateImage")
                self.arrOfCertiToUpload.replaceObject(at: self.selectedIndex, with: dictMutable)
                dictMutable.setValue(image, forKey: "OriImage")
                dictMutable.setValue(true, forKey: "hasImage")
                self.arrOfCertiToUpload.replaceObject(at: self.selectedIndex, with: dictMutable)
                self.cvCertificate.reloadData()
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
