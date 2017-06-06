//
//  regChooseCategory.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/21/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class regChooseCategory: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource
{

    //MARK:- Outelt
    @IBOutlet weak var scrCategory: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var viewCategory: cView!
    @IBOutlet weak var btnAddMoreCategory: cButton!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var viewChooseCategoryPopup: UIView!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var txtSearch: paddingTextField!
    
    var arrOfAllCategory: NSMutableArray = NSMutableArray()
    var arrOfAllCategoryTemp: NSMutableArray = NSMutableArray()
    var arrOfSelectedCategory: NSMutableArray = NSMutableArray()
    var yOffset: CGFloat = 0
    var tagContanerView: Int = 0
    var selectedCateID: Int = 0
    var tagRemoveButton: Int = 10000
    let custObj: customClassViewController = customClassViewController()
    var deleObj: AppDelegate!
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewCategory.isHidden = true
        yOffset = viewCategory.frame.origin.y
        
        arrangeCategoryView()
        self.navigationController?.navigationBar.isTranslucent = false
        tblCategory.delegate = self
        tblCategory.dataSource = self
        getAllCategories()
        txtSearch.delegate = self
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCategory), name: NSNotification.Name(rawValue: "reloadCategory"), object: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- POST NOTIFICATION
    func reloadCategory(n: NSNotification)
    {
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
        arrangeCategoryView()
    }
    //MARK:- Action Zone
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
//                        self.deleObj.dictOfCategories.setValue(dd.object(forKey: "ID"), forKey: "CategoryID")
//                        self.deleObj.dictOfCategories.setValue(field.text, forKey: "CategoryName")
//                        self.deleObj.dictOfCategories.setValue("", forKey: "SkillNames")
//                        self.deleObj.dictOfCategories.setValue("", forKey: "TitleNames")
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
    @IBAction func btnCancelCatePopup(_ sender: Any)
    {
        view.endEditing(true)
        custObj.bounceViewOut(true, view: viewChooseCategoryPopup)
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
            dictMutable.setValue("1", forKey: "isSelected")
            arrOfAllCategory.replaceObject(at: tag, with: dictMutable)
        }
        tblCategory.reloadData()
    }
    @IBAction func btnAddMoreCategory(_ sender: Any)
    {
        deleObj.isForCatEdit = false
        custObj.bounceView(in: true, view: viewChooseCategoryPopup)
        deleObj.dictOfCategories = NSMutableDictionary()
        selectedCateID = -1
        arrOfAllCategory = NSMutableArray.init(array: arrOfAllCategoryTemp)
        tblCategory.reloadData()
    }
    @IBAction func btnNext(_ sender: Any)
    {
//        let obj: regIDProof = self.storyboard?.instantiateViewController(withIdentifier: "regIDProof") as! regIDProof
//        self.navigationController!.pushViewController(obj, animated: true)
//        return
        if arrOfSelectedCategory.count == 0
        {
            custObj.alertMessage("Please add atleast one category")
            return
        }
        deleObj.dictSeekerReg.setValue(arrOfSelectedCategory, forKey: "SeekerCategory")
        let obj: regIDProof = self.storyboard?.instantiateViewController(withIdentifier: "regIDProof") as! regIDProof
        self.navigationController!.pushViewController(obj, animated: true)
    }
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfAllCategory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    //MARK:- Arrange CategoryView
    func arrangeCategoryView()
    {
        yOffset = viewCategory.frame.origin.y
        tagContanerView = 0
        tagRemoveButton = 10000
        for case let vieww in scrCategory.subviews
        {
            if vieww != viewStep && vieww != btnAddMoreCategory && vieww != viewCategory
            {
                vieww.removeFromSuperview()
            }
        }
        if arrOfSelectedCategory.count == 0
        {
            viewCategory.layer.borderWidth = 0
            tagContanerView = tagContanerView + 1000
            let archive = NSKeyedArchiver.archivedData(withRootObject: viewCategory)
            let newCateView = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
            newCateView.frame = CGRect.init(x: newCateView.frame.origin.x, y: yOffset, width: newCateView.frame.size.width, height: 52)
            yOffset = newCateView.frame.size.height + newCateView.frame.origin.y
            scrCategory.addSubview(newCateView)
            newCateView.tag = tagContanerView
            newCateView.isHidden = false
            for case let btnRemove as UIButton in newCateView.subviews
            {
                btnRemove.isHidden = true
            }
            
            for case let txt as paddingTextField in newCateView.subviews
            {
                if txt.tag == 2
                {
                    txt.tag = tagContanerView + 2
                }
                if txt.tag == 3
                {
                    txt.tag = tagContanerView + 3
                }
                if txt.tag == 4
                {
                    txt.tag = tagContanerView + 4
                }
                if txt.tag == 5
                {
                    txt.tag = tagContanerView + 5
                }
                if txt.tag == 6
                {
                    txt.tag = tagContanerView + 6
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
            btnAddMoreCategory.isHidden = true
        }
        else
        {
            for i in 0...arrOfSelectedCategory.count-1
            {
                //print(i)
                let dd: NSDictionary = arrOfSelectedCategory.object(at: i) as! NSDictionary
                tagContanerView = tagContanerView + 1000
                let archive = NSKeyedArchiver.archivedData(withRootObject: viewCategory)
                let newCateView = NSKeyedUnarchiver.unarchiveObject(with: archive) as! UIView
                newCateView.frame = CGRect.init(x: newCateView.frame.origin.x, y: yOffset, width: newCateView.frame.size.width, height: viewCategory.frame.size.height)
                yOffset = newCateView.frame.size.height + newCateView.frame.origin.y + 8
                scrCategory.addSubview(newCateView)
                newCateView.tag = tagContanerView
                
                newCateView.layer.borderWidth = 1
                newCateView.layer.borderColor = API.dividerColor().cgColor
                newCateView.layer.cornerRadius = 10
                newCateView.clipsToBounds = true
                
                newCateView.isHidden = false
                for case let btnRemove as UIButton in newCateView.subviews
                {
                    btnRemove.tag = tagRemoveButton
                    print(btnRemove.tag)
                    btnRemove.isHidden = false
                    btnRemove.addTarget(self, action:#selector(removeCategory(sender:)), for: .touchUpInside)
                }
                tagRemoveButton = tagRemoveButton + 1
                for case let txt as paddingTextField in newCateView.subviews
                {
                    if txt.tag == 2
                    {
                        txt.tag = tagContanerView + 2
                        txt.text = dd.object(forKey: "CategoryName") as? String
                    }
                    if txt.tag == 3
                    {
                        txt.tag = tagContanerView + 3
                    }
                    if txt.tag == 4
                    {
                        txt.tag = tagContanerView + 4
                    }
                    if txt.tag == 5
                    {
                        txt.tag = tagContanerView + 5
                    }
                    if txt.tag == 6
                    {
                        txt.tag = tagContanerView + 6
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
            }
            btnAddMoreCategory.isHidden = false
        }
    
        btnAddMoreCategory.frame = CGRect.init(x: btnAddMoreCategory.frame.origin.x, y: yOffset, width: btnAddMoreCategory.frame.size.width, height: btnAddMoreCategory.frame.size.height)
        scrCategory.contentSizeToFit()
    }
    func removeCategory(sender: UIButton)
    {
        var removeTag: Int = (sender as AnyObject).tag
        removeTag = removeTag - 10000
        arrOfSelectedCategory.removeObject(at: removeTag)
        arrangeCategoryView()
    }
    
    
    //MARK:- textfield delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txtSearch
        {
            return true
        }
        let tagSuperView: Int = (textField.superview?.tag)! // decrease 1000 from tagSuperView to get array index
        var tagTextField: Int = textField.tag
        tagTextField = tagTextField - tagSuperView
        print(tagSuperView)
        print(tagTextField)
        
        if arrOfSelectedCategory.count == 0
        {
            deleObj.isForCatEdit = false
            deleObj.dictOfCategories = NSMutableDictionary()
        }
        else
        {
            deleObj.isForCatEdit = true
            deleObj.arrIndexForCatEdit = (tagSuperView / 1000) - 1
            let dd: NSDictionary = arrOfSelectedCategory.object(at: (tagSuperView / 1000) - 1) as! NSDictionary
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
        }
        else if tagTextField == 3
        {
            //job title
            let obj: chooseJobTitle = self.storyboard?.instantiateViewController(withIdentifier: "chooseJobTitle") as! chooseJobTitle
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if tagTextField == 4
        {
            //certification
            let obj: chooseCertification = self.storyboard?.instantiateViewController(withIdentifier: "chooseCertification") as! chooseCertification
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if tagTextField == 5
        {
            //core skill
            let obj: chooseCoreSkill = self.storyboard?.instantiateViewController(withIdentifier: "chooseCoreSkill") as! chooseCoreSkill
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else if tagTextField == 6
        {
            //experience
            let obj: setExpSeeker = self.storyboard?.instantiateViewController(withIdentifier: "setExpSeeker") as! setExpSeeker
            self.navigationController!.pushViewController(obj, animated: true)
        }
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtSearch
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
    //MARK:- Call API
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
}
