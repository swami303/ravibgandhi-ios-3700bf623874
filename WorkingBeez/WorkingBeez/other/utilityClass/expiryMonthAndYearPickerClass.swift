//
//  expiryMonthAndYearPickerClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/12/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class expiryMonthAndYearPickerClass: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource
{
    @IBOutlet weak var picker: UIPickerView!
    
    var fromWhere: String = ""
    var objAddCreditCard: addCreditCardClass!
    
    var arrOfMonthPicker: NSMutableArray = NSMutableArray()
    var arrOfYearPicker: NSMutableArray = NSMutableArray()
    var custObj : customClassViewController = customClassViewController()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        if fromWhere == "creditCard"
        {
            
        }

        self.setupMonthAndYear()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnDismissAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelPickerAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDonePickerAction(_ sender: Any)
    {
        if fromWhere == "creditCard"
        {
            objAddCreditCard.strMonth = (arrOfMonthPicker.object(at: picker.selectedRow(inComponent: 0)) as! String)
            objAddCreditCard.strYear = (arrOfYearPicker.object(at: picker.selectedRow(inComponent: 1)) as! String)
            
            objAddCreditCard.txtExpiryDate.text = String.init(format: "%@/%@", objAddCreditCard.strMonth, objAddCreditCard.strYear)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupMonthAndYear()
    {
        arrOfMonthPicker = NSMutableArray()
        
        arrOfMonthPicker.add("01")
        arrOfMonthPicker.add("02")
        arrOfMonthPicker.add("03")
        arrOfMonthPicker.add("04")
        arrOfMonthPicker.add("05")
        arrOfMonthPicker.add("06")
        arrOfMonthPicker.add("07")
        arrOfMonthPicker.add("08")
        arrOfMonthPicker.add("09")
        arrOfMonthPicker.add("10")
        arrOfMonthPicker.add("11")
        arrOfMonthPicker.add("12")
        
        
        arrOfYearPicker = NSMutableArray()
        
        let df : DateFormatter = DateFormatter()
        df.dateFormat = "yyyy"
        
        let str : String = df.string(from: Date())
        
        let startYear : Int = Int(str)!
        let endYear : Int = Int(str)! + 20
        
        for item in startYear..<endYear
        {
            arrOfYearPicker.add(String.init(format: "%d", item))
        }
        
        picker.reloadAllComponents()
    }
    
    //MARK:- Uipickerview Delegate
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 2
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(component == 0)
        {
            return arrOfMonthPicker.count
        }
        else if(component == 1)
        {
            return arrOfYearPicker.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(component == 0)
        {
            return (arrOfMonthPicker.object(at: row) as! String)
        }
        else if(component == 1)
        {
            return (arrOfYearPicker.object(at: row) as! String)
        }
    
        return ""
    }

}
