//
//  feedbackClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/10/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class feedbackClass: UIViewController,UITextViewDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var txtReview: placeholderTextView!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var lblLeftChar: cLable!
    @IBOutlet weak var lblGiveYourFeedback: UILabel!
    
    var dictFromPT: NSMutableDictionary = NSMutableDictionary()
    var dictFromMP: NSMutableDictionary = NSMutableDictionary()
    var dictFromPC: NSMutableDictionary = NSMutableDictionary()
    var dictFromSC: NSMutableDictionary = NSMutableDictionary()
    
    
    var objPoster: makePaymentClass!
    var objSeeker: fillTimeSheetClass!
    var objAbort: abortJobClass!
    var objDashbordPoster: dashboardPoster!
    var objDashbordSeeker: dashboardSeeker!
    var objPosterCompleted: completedJobPoster!
    var objCompletedSeeker: completedJobSeeker!
    
    var fromWhere: String = ""
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        txtReview.layer.borderWidth = 1
        txtReview.layer.borderColor = API.dividerColor().cgColor
        
        txtReview.layer.cornerRadius = 10
        txtReview.clipsToBounds = true
        txtReview.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Action Zone
    @IBAction func btnCancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        if fromWhere == "abortSeeker" || fromWhere == "abortPoster"
        {
            self.objAbort.dismiss()
        }
        else if fromWhere == "submitPT"
        {
            self.objSeeker.dismiss()
        }
        else if fromWhere == "posterCompleted" || fromWhere == "seekerCompleted"
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func btnSubmit(_ sender: Any)
    {
//        if txtReview.text == ""
//        {
//            custObj.alertMessage("Please enter feedback")
//            return
//        }
        if viewRating.value == 0
        {
            custObj.alertMessage("Please help in rating to keep the best.")
            return
        }
        if fromWhere == "abortSeeker" || fromWhere == "abortPoster"
        {
            abortJob()
        }
        else if fromWhere == "submitPT"
        {
            let dd: NSMutableDictionary = NSMutableDictionary()
            dd.setValue(dictFromPT.object(forKey: "AcceptedID"), forKey: "AcceptedID")
            dd.setValue(dictFromPT.object(forKey: "RosterDateID"), forKey: "RosterDateID")
            dd.setValue(viewRating.value, forKey: "Rating")
            dd.setValue(txtReview.text, forKey: "Review")
            giveFeedback(dd: dd)
        }
        else if fromWhere == "posterPayment"
        {
            let dd: NSMutableDictionary = NSMutableDictionary()
            dd.setValue(dictFromMP.object(forKey: "AcceptedID"), forKey: "AcceptedID")
            dd.setValue(dictFromMP.object(forKey: "RosterDateID"), forKey: "RosterDateID")
            dd.setValue(viewRating.value, forKey: "Rating")
            dd.setValue(txtReview.text, forKey: "Review")
            giveFeedback(dd: dd)
        }
        else if fromWhere == "posterCompleted"
        {
            let dd: NSMutableDictionary = NSMutableDictionary()
            dd.setValue(dictFromPC.object(forKey: "AcceptedID"), forKey: "AcceptedID")
            dd.setValue(dictFromPC.object(forKey: "RosterDateID"), forKey: "RosterDateID")
            dd.setValue(viewRating.value, forKey: "Rating")
            dd.setValue(txtReview.text, forKey: "Review")
            giveFeedback(dd: dd)
        }
        else if fromWhere == "seekerCompleted"
        {
            let dd: NSMutableDictionary = NSMutableDictionary()
            dd.setValue(dictFromSC.object(forKey: "AcceptedID"), forKey: "AcceptedID")
            dd.setValue(dictFromSC.object(forKey: "RosterDateID"), forKey: "RosterDateID")
            dd.setValue(viewRating.value, forKey: "Rating")
            dd.setValue(txtReview.text, forKey: "Review")
            giveFeedback(dd: dd)
        }
        else if fromWhere == "cancelJob"
        {
            cancelJob()
        }
    }
    
    //MARK:- TextView delegate
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView == txtReview
        {
            var serachText = ""
            if txtReview.text?.characters.count == 0
            {
                serachText = text
            }
            else if range.location > 0 && range.length == 1 && text.characters.count == 0 {
                serachText = (txtReview.text?.substring(to: (txtReview.text?.index((txtReview.text?.startIndex)!, offsetBy: (txtReview.text?.characters.count)! - 1))!))!
            }
            else if text.characters.count == 0 && txtReview.text?.characters.count == 1 {
                serachText = ""
            }
            else if text.characters.count == 0 && (txtReview.text?.characters.count)! > 1
            {
                serachText = ""
            }
            else
            {
                serachText = (txtReview.text?.appending(text))!
            }
            if serachText.length >= 71
            {
                return false
            }
            
            //print(serachText.length)
        }
        return true
    }
    func textViewDidChangeSelection(_ textView: UITextView)
    {
        lblLeftChar.text = String(format: "%d Left", 70 - textView.text.length)
    }
    //MARK:- Call API
    func abortJob()
    {
        custObj.showSVHud("Loading")
        let dd: NSMutableDictionary = NSMutableDictionary()
        dd.setValue(API.getToken(), forKey: "Token")
        dd.setValue(API.getDeviceToken(), forKey: "DeviceID")
        dd.setValue(API.getRoleName(), forKey: "RoleName")
        dd.setValue(API.getUserId(), forKey: "UserID")
        dd.setValue(objAbort.dictFromRunning.object(forKey: "AcceptedID"), forKey: "AcceptedID")
        dd.setValue(objAbort.dictFromRunning.object(forKey: "RosterDateID"), forKey: "RosterDateID")
        dd.setValue(objAbort.selectedReasonID, forKey: "CancelReasonID")
        dd.setValue(objAbort.tvOther.text, forKey: "CancelReason")
        dd.setValue(viewRating.value, forKey: "Rating")
        dd.setValue(txtReview.text, forKey: "Review")
        print(dd)
        API.callApiPOST(strUrl: API_AbortJob,parameter: dd, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.dismiss(animated: true, completion: nil)
                if self.fromWhere == "abortPoster"
                {
                    self.objAbort.objRunning.getRunning(show: true)
                }
                else
                {
                    self.objAbort.objRunningSeeker.getRunning(show: true)
                }
                self.objAbort.dismiss()
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.dismiss(animated: true, completion: nil)
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.dismiss(animated: true, completion: nil)
        })
    }
    func giveFeedback(dd: NSMutableDictionary)
    {
        custObj.showSVHud("Loading")
        dd.setValue(API.getToken(), forKey: "Token")
        dd.setValue(API.getDeviceToken(), forKey: "DeviceID")
        dd.setValue(API.getRoleName(), forKey: "RoleName")
        dd.setValue(API.getUserId(), forKey: "UserID")
        
        print(dd)
        API.callApiPOST(strUrl: API_RateAndReviewJob,parameter: dd, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.dismiss(animated: true, completion: nil)
                if self.fromWhere == "posterPayment"
                {
                    self.objPoster.back()
                }
                else if self.fromWhere == "submitPT"
                {
                    self.objSeeker.objPTSeeker.getAllPT()
                    self.objSeeker.dismiss()
                }
                else if self.fromWhere == "posterCompleted"
                {
                    self.objPosterCompleted.getAllCompletedPost()
                    self.dismiss(animated: true, completion: nil)
                }
                else if  self.fromWhere == "seekerCompleted"
                {
                    self.objCompletedSeeker.getAllCompletedPost()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.dismiss(animated: true, completion: nil)
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.dismiss(animated: true, completion: nil)
        })
    }
    func cancelJob()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(objAbort.selectedReasonID, forKey: "CancelReasonID")
        parameter.setValue(objAbort.tvOther.text, forKey: "CancelReason")
        if objAbort.fromWhere == "Accepted"
        {
            parameter.setValue(objAbort.objAccepted.dictStartJob.object(forKey: "AcceptedID"), forKey: "AcceptedID")
            parameter.setValue(objAbort.objAccepted.dictStartJob.object(forKey: "RosterDateID"), forKey: "RosterDateID")
        }
        else if objAbort.fromWhere == "AcceptedInner"
        {
            parameter.setValue(objAbort.objAcceptedInner.dictStartJob.object(forKey: "AcceptedID"), forKey: "AcceptedID")
            parameter.setValue(objAbort.objAcceptedInner.dictStartJob.object(forKey: "ID"), forKey: "RosterDateID")
        }
        parameter.setValue(viewRating.value, forKey: "Rating")
        parameter.setValue(txtReview.text, forKey: "Review")
        print(parameter)
        API.callApiPOST(strUrl: API_CancelJob,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.dismiss(animated: true, completion: nil)
                if self.objAbort.fromWhere == "Accepted"
                {
                    self.objAbort.objAccepted.arrOfRoster.remove(self.objAbort.objAccepted.dictStartJob)
                    if self.objAbort.objAccepted.arrOfRoster.count == 0
                    {
                        self.objAbort.objAccepted.contentMsg.isHidden = false
                    }
                    self.objAbort.objAccepted.tblAcceoted.reloadData()
                }
                else if self.objAbort.fromWhere == "AcceptedInner"
                {
                    self.objAbort.objAcceptedInner.arrOfRoster.remove(self.objAbort.objAcceptedInner.dictStartJob)
                    if self.objAbort.objAcceptedInner.arrOfRoster.count == 0
                    {
                        self.objAbort.objAcceptedInner.contentMsg.isHidden = false
                    }
                    self.objAbort.objAcceptedInner.tblAcceoted.reloadData()
                }
                self.objAbort.dismiss()
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.dismiss(animated: true, completion: nil)
            }
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.dismiss(animated: true, completion: nil)
        })
    }
}
