//
//  timePeriodClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/12/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class timePeriodClass: UIViewController
{

    //MARK:- Outlet
    @IBOutlet weak var FromDatePicker: UIDatePicker!
    @IBOutlet weak var ToDatePicker: UIDatePicker!
    
    var fromWhere: String = ""
    var objCompletedJobPoster: completedJobPoster!
    var objPostHistory: postHistoryClass!
    var objCompletedJobSeeker: completedJobSeeker!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- View Cycle
    @IBAction func btnCancel(_ sender: Any)
    {
        if fromWhere == "postHistory"
        {
            if objPostHistory.strFromDate != "" || objPostHistory.strToDate != ""
            {
                objPostHistory.strFromDate = ""
                objPostHistory.strToDate = ""
                objPostHistory.getAllPost()
            }
        }
        else if fromWhere == "completedJobSeeker"
        {
            if objCompletedJobSeeker.strFromDate != "" || objCompletedJobSeeker.strToDate != ""
            {
                objCompletedJobSeeker.strFromDate = ""
                objCompletedJobSeeker.strToDate = ""
                objCompletedJobSeeker.getAllCompletedPost()
            }
        }
        else if fromWhere == "completedJobPoster"
        {
            if objCompletedJobPoster.strFromDate != "" || objCompletedJobPoster.strToDate != ""
            {
                objCompletedJobPoster.strFromDate = ""
                objCompletedJobPoster.strToDate = ""
                objCompletedJobPoster.getAllCompletedPost()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnSubmit(_ sender: Any)
    {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        if fromWhere == "postHistory"
        {
            objPostHistory.strFromDate = df.string(from: FromDatePicker.date)
            objPostHistory.strToDate = df.string(from: ToDatePicker.date)
            objPostHistory.getAllPost()
        }
        else if fromWhere == "completedJobSeeker"
        {
            objCompletedJobSeeker.strFromDate = df.string(from: FromDatePicker.date)
            objCompletedJobSeeker.strToDate = df.string(from: ToDatePicker.date)
            objCompletedJobSeeker.getAllCompletedPost()
        }
        else if fromWhere == "completedJobPoster"
        {
            objCompletedJobPoster.strFromDate = df.string(from: FromDatePicker.date)
            objCompletedJobPoster.strToDate = df.string(from: ToDatePicker.date)
            objCompletedJobPoster.getAllCompletedPost()
        }
        self.dismiss(animated: true, completion: nil)
    }
}
