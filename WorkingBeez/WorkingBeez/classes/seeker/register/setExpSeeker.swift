//
//  setExpSeeker.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class setExpSeeker: UIViewController,UITextFieldDelegate
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
    
    @IBOutlet weak var viewExperience: UIView!
    @IBOutlet weak var lblWorkExp: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var txtYear: paddingTextField!
    @IBOutlet weak var txtMonth: paddingTextField!
    
    var deleObj: AppDelegate!
    
    var strWhichStep: String = "1"
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        self.navigationController?.navigationBar.isTranslucent = false
        txtYear.isHidden = false
        txtMonth.isHidden = false
        btnYes.isSelected = true
        btnNo.isSelected = false
        lblWorkExp.text = String(format: "Have you previously worked in '%@'", deleObj.dictOfCategories.object(forKey: "CategoryName") as! String)
        if deleObj.isForSeekerEdit == true
        {
            viewStep.isHidden = true
        }
        txtMonth.delegate = self
        txtYear.delegate = self
    
        if deleObj.isForCatEdit == true
        {
            if deleObj.dictOfCategories.object(forKey: "HaveExperience") as! Bool == false
            {
                txtYear.isHidden = true
                txtMonth.isHidden = true
                btnYes.isSelected = false
                btnNo.isSelected = true
            }
            else
            {
                txtYear.isHidden = false
                txtMonth.isHidden = false
                btnYes.isSelected = true
                btnNo.isSelected = false
                txtYear.text = String(format: "%@", deleObj.dictOfCategories.object(forKey: "ExperienceYear") as! String)
                txtMonth.text = String(format: "%@", deleObj.dictOfCategories.object(forKey: "ExperienceMonth") as! String)
                print(deleObj.dictOfCategories)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnNext(_ sender: Any)
    {
        if btnYes.isSelected == true
        {
            if txtYear.text == ""
            {
                var str: String = ""
                str = String(format: "Have you previously worked in %@?", deleObj.dictOfCategories.object(forKey: "CategoryName") as! String)
                var str1: String = ""
                str1 = String(format: "Please add your experience for %@", deleObj.dictOfCategories.object(forKey: "CategoryName") as! String)
                custObj.alertMessage(withTitle: str1, with: str)
                return
            }
            deleObj.dictOfCategories.setValue(true, forKey: "HaveExperience")
            deleObj.dictOfCategories.setValue(txtYear.text, forKey: "ExperienceYear")
            deleObj.dictOfCategories.setValue(txtMonth.text, forKey: "ExperienceMonth")
        }
        else
        {
            deleObj.dictOfCategories.setValue(false, forKey: "HaveExperience")
            deleObj.dictOfCategories.setValue("", forKey: "ExperienceYear")
            deleObj.dictOfCategories.setValue("", forKey: "ExperienceMonth")
        }
        print(deleObj.dictOfCategories)
        if deleObj.isForSeekerEdit == true
        {
            for controller in self.navigationController!.viewControllers as Array
            {
                if controller is myProfileSeeker
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCategoryProfile"), object: deleObj.dictOfCategories)
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        else
        {
            for controller in self.navigationController!.viewControllers as Array
            {
                if controller is regChooseCategory
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCategory"), object: deleObj.dictOfCategories)
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        
    }
    
    @IBAction func btnYes(_ sender: Any)
    {
        txtYear.isHidden = false
        txtMonth.isHidden = false
        btnYes.isSelected = true
        btnNo.isSelected = false
    }
    @IBAction func btnNo(_ sender: Any)
    {
        txtYear.isHidden = true
        txtMonth.isHidden = true
        btnYes.isSelected = false
        btnNo.isSelected = true
    }
    
    
    //MARK:- Tetfile delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.length != 0
        {
            if !"0123456789".contains(string)
            {
                return false
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

extension String
{
    var length: Int { return characters.count} // Swift 2.0
}
