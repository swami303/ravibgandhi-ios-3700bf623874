//
//  abortJobClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/5/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class abortJobClass: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK:- Outlet
    @IBOutlet weak var tvOther: placeholderTextView!
    @IBOutlet weak var tblReason: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblReason: UILabel!
    
    var dictFromRunning: NSMutableDictionary = NSMutableDictionary()
    var isOther: Bool = false
    var selectedReasonID: Int = 0
    var lastIndex: Int = 0
    var arrOfReason: NSMutableArray = NSMutableArray()
    var objRunning: allJobStatusPoster!
    var objRunningSeeker: allJobStatusSeeker!
    var objAccepted: acceptedDetailSeeker!
    var objCalAccepted: calendarSeekerClass!
    var objAcceptedInner: acceptedDetailInnerSeeker!
    var objSeekerProfile: myProfileSeeker!
    var fromWhere: String = ""
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tvOther.layer.borderWidth = 1
        tvOther.layer.borderColor = API.dividerColor().cgColor
        
        tvOther.layer.cornerRadius = 10
        tvOther.clipsToBounds = true
        
        
        if fromWhere == "profile"
        {
            lblReason.text = "Choose your woking rights"
            var i: Int = 0
            var flag:Bool = false
            for item in objSeekerProfile.arrOfWorkingRights
            {
                let dd: NSDictionary = item as! NSDictionary
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                
                if objSeekerProfile.WorkingRightID == dictMutable.object(forKey: "ID") as! Int
                {
                    lastIndex = i
                    flag = true
                    self.selectedReasonID = dictMutable.object(forKey: "ID") as! Int
                }
                dictMutable.setValue(flag, forKey: "isSelected")
                self.arrOfReason.add(dictMutable)
                flag = false
                i = i + 1
            }
            tvOther.placeholder = "Enter other woking rights"
            if objSeekerProfile.WorkingRightID == 0
            {
                isOther = true
                tvOther.text = objSeekerProfile.txtWorkingRights.text
                setTextViewFrame(hide: false)
                //tvOther.text = objSeekerProfile.txtWorkingRights.text
            }
            else
            {
                isOther = false
                setTextViewFrame(hide: true)
            }
        }
        else
        {
            if fromWhere == "Accepted" || fromWhere == "AcceptedInner"
            {
                lblReason.text = "Choose the reason to cancel the work"
            }
            else
            {
                lblReason.text = "Choose the reason to terminate the work"
            }
            getAllCancelReason()
            setTextViewFrame(hide: true)
        }
        tblReason.delegate = self
        tblReason.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Action Zone
    
    @IBAction func btnDone(_ sender: Any)
    {
        if fromWhere == "profile"
        {
            if isOther == true && tvOther.text == ""
            {
                custObj.alertMessage("Please enter other working rights")
                return
            }
            else
            {
                objSeekerProfile.txtWorkingRights.text = tvOther.text
            }
            if isOther == true
            {
                objSeekerProfile.WorkingRightID = selectedReasonID
                objSeekerProfile.txtWorkingRights.text = tvOther.text
            }
            else
            {
                objSeekerProfile.WorkingRightID = selectedReasonID
                let dd: NSDictionary = arrOfReason.object(at: lastIndex) as! NSDictionary
                objSeekerProfile.txtWorkingRights.text = dd.object(forKey: "Name") as? String
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            if arrOfReason.count == 0
            {
                getAllCancelReason()
                return
            }
            if selectedReasonID == 0
            {
                custObj.alertMessage("Please choose reason")
                return
            }
            if isOther == true && tvOther.text == ""
            {
                custObj.alertMessage("Please enter other reason")
                return
            }
            let dict: NSMutableDictionary = NSMutableDictionary()
            
            if fromWhere == "runningPoster"
            {
                let obj: feedbackClass = self.storyboard?.instantiateViewController(withIdentifier: "feedbackClass") as! feedbackClass
                obj.objAbort = self
                obj.fromWhere = "abortPoster"
                self.present(obj, animated: true, completion: nil)
            }
            else if fromWhere == "runningSeeker"
            {
                let obj: feedbackClass = self.storyboard?.instantiateViewController(withIdentifier: "feedbackClass") as! feedbackClass
                obj.objAbort = self
                obj.fromWhere = "abortSeeker"
                self.present(obj, animated: true, completion: nil)
            }
            else if fromWhere == "Accepted"
            {
                let obj: feedbackClass = self.storyboard?.instantiateViewController(withIdentifier: "feedbackClass") as! feedbackClass
                obj.objAbort = self
                obj.fromWhere = "cancelJob"
                self.present(obj, animated: true, completion: nil)
//                dict.setValue(objAccepted.dictFrom.object(forKey: "ID"), forKey: "AcceptedID")
//                dict.setValue(objAccepted.dictStartJob.object(forKey: "RosterDateID"), forKey: "RosterDateID")
//                abortJob(dd: dict)
            }
            else if fromWhere == "AcceptedInner"
            {
                let obj: feedbackClass = self.storyboard?.instantiateViewController(withIdentifier: "feedbackClass") as! feedbackClass
                obj.objAbort = self
                obj.fromWhere = "cancelJob"
                self.present(obj, animated: true, completion: nil)
//                dict.setValue(objAcceptedInner.dictFromMain.object(forKey: "ID"), forKey: "AcceptedID")
//                dict.setValue(objAcceptedInner.dictStartJob.object(forKey: "ID"), forKey: "RosterDateID")
//                abortJob(dd: dict)
            }
        }
    }
    @IBAction func btnCancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func dismiss()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- tableView delegate
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfReason.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
        let dd: NSDictionary = arrOfReason.object(at: indexPath.row) as! NSDictionary
        cell.lblAbortReason.text = dd.object(forKey: "Name") as? String
        
        if dd.object(forKey: "isSelected") as! Bool == true
        {
            cell.lblAbortReason.textColor = API.themeColorBlue()
            cell.btnReasonSelected.isSelected = true
        }
        else
        {
            cell.lblAbortReason.textColor = API.blackColor()
            cell.btnReasonSelected.isSelected = false
        }
        cell.btnReasonSelected.isUserInteractionEnabled = false
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var dd: NSDictionary = arrOfReason.object(at: lastIndex) as! NSDictionary
        var dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        dictMutable.setValue(false, forKey: "isSelected")
        arrOfReason.replaceObject(at: lastIndex, with: dictMutable)
        
        dd = arrOfReason.object(at: indexPath.row) as! NSDictionary
        dictMutable = NSMutableDictionary.init(dictionary: dd)
        dictMutable.setValue(true, forKey: "isSelected")
        selectedReasonID = dictMutable.object(forKey: "ID") as! Int
        arrOfReason.replaceObject(at: indexPath.row, with: dictMutable)
        lastIndex = indexPath.row
        tblReason.reloadData()
        
        if dictMutable.object(forKey: "Name") as! String == "Others" || dictMutable.object(forKey: "Name") as! String == "Other"
        {
            setTextViewFrame(hide: false)
            isOther = true
        }
        else
        {
            setTextViewFrame(hide: true)
            isOther = false
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 30
    }
    
    //MARK:- setTextViewFrame
    func setTextViewFrame(hide:Bool)
    {
        if hide == true
        {
            tvOther.isHidden = hide
            viewContainer.frame = CGRect.init(x: viewContainer.frame.origin.x, y: viewContainer.frame.origin.y, width: viewContainer.frame.size.width, height: 274)
        }
        else
        {
            tvOther.isHidden = hide
            viewContainer.frame = CGRect.init(x: viewContainer.frame.origin.x, y: viewContainer.frame.origin.y, width: viewContainer.frame.size.width, height: 362)
        }
    }
    
    //MARK:- API CALL
    func getAllCancelReason()
    {
        arrOfReason = NSMutableArray()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GetAllCancelReason,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                var flag: Bool = true
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    dictMutable.setValue(flag, forKey: "isSelected")
                    if flag == true
                    {
                        self.selectedReasonID = dictMutable.object(forKey: "ID") as! Int
                    }
                    self.arrOfReason.add(dictMutable)
                    flag = false
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblReason.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func abortJob(dd: NSMutableDictionary)
    {
        custObj.showSVHud("Loading")
        dd.setValue(API.getToken(), forKey: "Token")
        dd.setValue(API.getDeviceToken(), forKey: "DeviceID")
        dd.setValue(API.getRoleName(), forKey: "RoleName")
        dd.setValue(API.getUserId(), forKey: "UserID")
        dd.setValue(selectedReasonID, forKey: "CancelReasonID")
        dd.setValue(tvOther.text, forKey: "CancelReason")
        print(dd)
        API.callApiPOST(strUrl: API_CancelJob,parameter: dd, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                if self.fromWhere == "runningPoster"
                {
                }
                else if self.fromWhere == "runningSeeker"
                {
                }
                else if self.fromWhere == "Accepted"
                {
                    self.objAccepted.arrOfRoster.remove(self.objAccepted.dictStartJob)
                    if self.objAccepted.arrOfRoster.count == 0
                    {
                        self.objAccepted.contentMsg.isHidden = false
                    }
                    self.objAccepted.tblAcceoted.reloadData()
                }
                else if self.fromWhere == "AcceptedInner"
                {
                    self.objAcceptedInner.arrOfRoster.remove(self.objAccepted.dictStartJob)
                    if self.objAcceptedInner.arrOfRoster.count == 0
                    {
                        self.objAcceptedInner.contentMsg.isHidden = false
                    }
                    self.objAcceptedInner.tblAcceoted.reloadData()
                }
                self.dismiss(animated: true, completion: nil)
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
