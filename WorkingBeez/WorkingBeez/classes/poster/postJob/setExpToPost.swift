//
//  setExpToPost.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/26/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class setExpToPost: UIViewController,UITextFieldDelegate
{
    
    //MARK:- Outlet
    @IBOutlet weak var lblStep1: cLable!
    @IBOutlet weak var lblStep2: cLable!
    @IBOutlet weak var lblStep3: cLable!
    @IBOutlet weak var lblStep4: cLable!
    @IBOutlet weak var lblStep5: cLable!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    
    @IBOutlet weak var viewExperience: UIView!
    @IBOutlet weak var lblWorkExp: UILabel!
    
    @IBOutlet weak var txtYear: paddingTextField!
    @IBOutlet weak var txtMonth: paddingTextField!
    @IBOutlet weak var viewStep: UIView!
    @IBOutlet weak var viewBottomStep: UIView!
    
    
    var strWhichStep: String = "1"
    var deleObj: AppDelegate!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        txtYear.delegate = self
        txtMonth.delegate = self
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Action Zone
    
    @IBAction func btnNext(_ sender: Any)
    {
        deleObj.dictPosJob.setValue(txtYear.text, forKey: "ExperienceYear")
        deleObj.dictPosJob.setValue(txtMonth.text, forKey: "ExperienceMonth")
        let obj: setRosterClass = self.storyboard?.instantiateViewController(withIdentifier: "setRosterClass") as! setRosterClass
        self.navigationController!.pushViewController(obj, animated: true)
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
