//
//  chooseCateToPost.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class chooseCateToPost: UIViewController,UITextFieldDelegate
{
    
    //MARK:- Outlet
    @IBOutlet weak var lblStep1: cLable!
    @IBOutlet weak var lblStep2: cLable!
    @IBOutlet weak var lblStep3: cLable!
    @IBOutlet weak var lblStep4: cLable!
    @IBOutlet weak var lblStep5: cLable!
    @IBOutlet weak var lblSelectedStep: cLable!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    
    
    @IBOutlet weak var txtSearch: paddingTextField!
    
    @IBOutlet weak var scrTop: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrBottom: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var lblCateHowManyText: cLable!
    
    var selectedCateId: Int = -1
    var strSelectedCateName: String = ""
    var arrTemp: NSArray!
    var arrSearch: NSMutableArray = NSMutableArray()
    var arrOfCategory: NSMutableArray = NSMutableArray()
    var strWhichStep: String = "1"
    var deleObj: AppDelegate!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        txtSearch.delegate = self
        txtSearch.returnKeyType = UIReturnKeyType.done
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCategory), name: NSNotification.Name(rawValue: "reloadCategoryPostJob"), object: nil)
        reloadCategory()
        txtSearch.placeholder = "Search &/or click tap on '+' to add"
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func reloadCategory()
    {
        arrOfCategory = NSMutableArray()
        selectedCateId = -1
        strSelectedCateName = ""
        var i: Int = 0
        let dd: NSDictionary!
        dd = API.getLoggedUserData()
        arrTemp = dd.object(forKey: "PosterCategory") as! NSArray
        for item in arrTemp
        {
            let dd: NSDictionary = item as! NSDictionary
            let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
            dictMutable.setValue("0", forKey: "isSelected")
            dictMutable.setValue(i, forKey: "index")
            arrOfCategory.add(dictMutable)
            i = i + 1
        }
        manageTagCate(arrTag: arrOfCategory)
    }
    //MARK:- Action Zone
    @IBAction func btnNext(_ sender: Any)
    {
        if selectedCateId == -1
        {
            custObj.alertMessage("Please select any one category")
            return
        }
        deleObj.dictPosJob.setValue(selectedCateId, forKey: "CategoryID")
        deleObj.dictPosJob.setValue(strSelectedCateName, forKey: "CategoryName")
        
        let obj: chooseJobTitleToPost = self.storyboard?.instantiateViewController(withIdentifier: "chooseJobTitleToPost") as! chooseJobTitleToPost
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnAddNewCate(_ sender: Any)
    {
        let obj: myProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "myProfileClass") as! myProfileClass
        obj.strFromWhere = "postJob"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- TagList Method
    func manageTagCate(arrTag: NSMutableArray)
    {
        for case let vv as CustomViewSingleButton in self.scrTop.subviews
        {
            vv.removeFromSuperview()
        }
        if arrTag.count == 0
        {
            return
        }
        for case let vv as CustomViewSingleButton in self.scrBottom.subviews
        {
            vv.removeFromSuperview()
        }
        var i: Int = 0
        for item in arrTag
        {
            let dd: NSDictionary = item as! NSDictionary
            if dd.object(forKey: "isSelected") as! String == "0"
            {
                let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "Path") as! String, image1name: "", image2name: "add", viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
                
                view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
                view1.tag = 2000 + i
                
                
                view1.backgroundColor = API.lightBlueColor()
                view1.layer.borderColor = API.themeColorBlue().cgColor
                view1.layer.borderWidth = 1
                view1.clipsToBounds = true
                
                view1.btnSecondOutlet.tag = i
                
                view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnAddTagToSelected(_:)), for: UIControlEvents.touchUpInside)
                scrTop.addSubview(view1)
                self.view.layoutIfNeeded()
            }
            if dd.object(forKey: "isSelected") as! String == "2"
            {
                let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "Path") as! String, image1name: "", image2name: "add", viewBorderColor: API.themeColorBlue(), viewBackColor: API.lightBlueColor())
                
                view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
                view1.tag = 2000 + i
                
                
                view1.backgroundColor = API.lightBlueColor()
                view1.layer.borderColor = API.themeColorBlue().cgColor
                view1.layer.borderWidth = 1
                view1.clipsToBounds = true
                
                view1.btnSecondOutlet.tag = i
                
                view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnAddTagToSelected(_:)), for: UIControlEvents.touchUpInside)
                scrTop.addSubview(view1)
                self.view.layoutIfNeeded()
            }
            if dd.object(forKey: "isSelected") as! String == "1"
            {
                //let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "tag") as! String, image1name: "", image2name: "remove")
                let view1 : CustomViewSingleButton = CustomViewSingleButton.init(s: dd.object(forKey: "Path") as! String, image1name: "", image2name: "remove", viewBorderColor: API.lightPinkColor(), viewBackColor: API.lightPinkColor())
                
                view1.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width - 40, height: view1.lblText.frame.size.height + 5)
                view1.tag = 2000 + i
                
                view1.backgroundColor = API.lightPinkColor()
                view1.layer.borderColor = API.themeColorPink().cgColor
                view1.layer.borderWidth = 1
                view1.clipsToBounds = true
                
                view1.btnSecondOutlet.tag = i
                
                view1.btnSecondOutlet.addTarget(self, action: #selector(self.btnRemoveTagFromSelected(_:)), for: UIControlEvents.touchUpInside)
                scrBottom.addSubview(view1)
                self.view.layoutIfNeeded()
            }
            i = i + 1
        }
        
        arrangeTags(scr: scrBottom)
        arrangeTags(scr: scrTop)
    }
    func arrangeTags(scr: TPKeyboardAvoidingScrollView)
    {
        var prevViewWidth : CGFloat = 10
        var prevViewY : CGFloat = 10
        for v in scr.subviews
        {
            
            if(v.tag >= 2000 && v.tag < 99999)
            {
                if(v is CustomViewSingleButton)
                {
                    let cv : CustomViewSingleButton = v as! CustomViewSingleButton
                    print(cv.tag)
                    if(scr.subviews.contains(cv))
                    {
                        if(((prevViewWidth + (cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2)) <= scr.frame.size.width - 20))
                        {
                            cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2, height: cv.lblText.frame.size.height + 5)
                        }
                        else
                        {
                            prevViewWidth = 10
                            
                            cv.frame = CGRect.init(x: prevViewWidth, y: prevViewY, width: cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2, height: cv.lblText.frame.size.height + 5)
                        }
                        
                        let start : Int = (v.tag - 2000) + 1
                        var nextTag : Int = 2000+start
                        //print(arrOfCategory)
                        for j in start..<arrOfCategory.count
                        {
                            let dd: NSDictionary = (arrOfCategory.object(at: j) as! NSDictionary)
                            
                            if(scr == self.scrTop)
                            {
                                if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "2"
                                {
                                    nextTag = 2000 + j
                                    break
                                }
                            }
                            else if(scr == self.scrBottom)
                            {
                                if dd.object(forKey: "isSelected") as! String == "1"
                                {
                                    nextTag = 2000 + j
                                    break
                                }
                            }
                        }
                        
                        
                        if(self.view.viewWithTag(nextTag) != nil)
                        {
                            let nextView : CustomViewSingleButton = self.view.viewWithTag(nextTag) as! CustomViewSingleButton
                            
                            if(!((prevViewWidth + (cv.btnSecondOutlet.frame.origin.x + cv.btnSecondOutlet.frame.size.width + 2) + (nextView.btnSecondOutlet.frame.origin.x + nextView.btnSecondOutlet.frame.size.width + 2)) <= scr.frame.size.width - 20))
                            {
                                prevViewY = cv.frame.origin.y + cv.frame.size.height + 5
                            }
                        }
                        
                        cv.layer.cornerRadius = 13//cv.frame.size.height / 2
                        cv.clipsToBounds = true
                        prevViewWidth = cv.frame.size.width + cv.frame.origin.x + 2
                    }
                }
            }
        }
        scr.contentSizeToFit()
    }
    @IBAction func btnAddTagToSelected(_ sender: Any)
    {
        if selectedCateId == -1
        {
            let tag: Int = (sender as AnyObject).tag
            let dd: NSDictionary!
            dd = arrOfCategory.object(at: tag) as! NSDictionary
            if dd.object(forKey: "ID") as! Int == 0
            {
                let alertController = UIAlertController(title: ALERT_TITLE, message: "Please enter your category name", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
                    if let field = alertController.textFields?[0] {
                        // store your data
                        if field.text == ""
                        {
                            self.custObj.alertMessage("Please enter category name")
                            return
                        }
                        if (field.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)!
                        {
                            self.custObj.alertMessage("Please enter category name")
                            return
                        }
                        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                        dictTag.setValue("1", forKey: "isSelected")
                        self.arrOfCategory.replaceObject(at: tag, with: dictTag)
                        self.manageTagCate(arrTag: self.arrOfCategory)
                        self.selectedCateId = 0
                        self.strSelectedCateName = field.text!
                        self.btnNext(self)
                    } else {
                        // user did not fill field
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                
                alertController.addTextField { (textField) in
                    textField.placeholder = "Category Name"
                }
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                dictTag.setValue("1", forKey: "isSelected")
                arrOfCategory.replaceObject(at: tag, with: dictTag)
                print(arrOfCategory)
                manageTagCate(arrTag: arrOfCategory)
                selectedCateId = dictTag.object(forKey: "ID") as! Int
                strSelectedCateName = dictTag.object(forKey: "Path") as! String
            }
        }
        else
        {
            custObj.alertMessage("You can select only one category in order to post job")
        }
    }
    @IBAction func btnRemoveTagFromSelected(_ sender: Any)
    {
        let tag: Int = (sender as AnyObject).tag
        let dd: NSDictionary!
        dd = arrOfCategory.object(at: tag) as! NSDictionary
        let dictTag: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictTag.setValue("0", forKey: "isSelected")
        arrOfCategory.replaceObject(at: tag, with: dictTag)
        manageTagCate(arrTag: arrOfCategory)
        selectedCateId = -1
        strSelectedCateName = ""
    }
    
    //MARK:- textField Delegate
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
            if serachText.length == 0
            {
                txtSearch.text = ""
                arrSearch = NSMutableArray()
                for item in arrOfCategory
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3" || dd.object(forKey: "isSelected") as! String == "2"
                    {
                        dictMutable.setValue("0", forKey: "isSelected")
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfCategory = NSMutableArray.init(array: arrSearch)
                manageTagCate(arrTag: arrOfCategory)
            }
            else
            {
                
                arrSearch = NSMutableArray()
                for item in arrOfCategory
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3" || dd.object(forKey: "isSelected") as! String == "2"
                    {
                        dictMutable.setValue("0", forKey: "isSelected")
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfCategory = NSMutableArray.init(array: arrSearch)
                arrSearch = NSMutableArray()
                for item in arrOfCategory
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    if dd.object(forKey: "isSelected") as! String == "0" || dd.object(forKey: "isSelected") as! String == "3"
                    {
                        let str: String = dd.object(forKey: "Path") as! String
                        if str.lowercased().contains(serachText.lowercased())
                        {
                            //arrSearch.add(dd)
                            dictMutable.setValue("2", forKey: "isSelected")
                        }
                        else
                        {
                            dictMutable.setValue("3", forKey: "isSelected")
                        }
                    }
                    arrSearch.add(dictMutable)
                }
                arrOfCategory = NSMutableArray.init(array: arrSearch)
                
                manageTagCate(arrTag: arrOfCategory)
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return true
    }
}
