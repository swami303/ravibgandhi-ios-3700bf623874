//
//  calendarNotesClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/13/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class calendarNotesClass: UIViewController,UITableViewDelegate,UITableViewDataSource,BSKeyboardControlsDelegate
{
    @IBOutlet var keyboardControls: BSKeyboardControls!
    @IBOutlet weak var txtNoteMessage: UITextView!
    @IBOutlet weak var tblCalendarNote: UITableView!
    
    var rosterID: Int = 0
    var noteID: Int = 0
    var dictFrom: NSDictionary!
    var objSeeker: calendarSeekerClass!
    var objPoster: calendarPosterClass!
    var arrOfNotes: NSMutableArray = NSMutableArray()
    
    let custObj: customClassViewController = customClassViewController()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //view.backgroundColor = API.appBackgroundColor()

        rosterID = dictFrom.object(forKey: "RosterID") as! Int
        tblCalendarNote.delegate = self
        tblCalendarNote.dataSource = self
        tblCalendarNote.tableFooterView = UIView.init(frame: CGRect.zero)
        
        tblCalendarNote.register(UINib(nibName: "calendarNoteCell", bundle: nil), forCellReuseIdentifier: "calendarNoteCell")
        
        self.tblCalendarNote.rowHeight = UITableViewAutomaticDimension
        self.tblCalendarNote.estimatedRowHeight = 60
        
        self.tblCalendarNote.layoutSubviews()
        
        txtNoteMessage.layer.cornerRadius = 10.0
        txtNoteMessage.layer.borderColor = API.themeColorBlue().cgColor
        txtNoteMessage.layer.borderWidth = 0.5
        txtNoteMessage.clipsToBounds = true
        
        let fields: [AnyObject]
        fields = [txtNoteMessage]
        self.keyboardControls = BSKeyboardControls(fields: fields)
        self.keyboardControls.delegate = self
        
        getAllNotes(show: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Action Zone
    @IBAction func btnCancelNoteAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSaveNoteAction(_ sender: Any)
    {
        if(txtNoteMessage.text == "")
        {
            custObj.alertMessage("Please enter notes")
            return
        }
        createNote()
    }
    
    // MARK: - BSKeyboardControls Delegate Methods
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls)
    {
        self.dismissKeyboard()
    }

    
    //MARK:- tableView delegate
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfNotes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarNoteCell", for: indexPath as IndexPath) as! calendarNoteCell
        let dd: NSDictionary = arrOfNotes.object(at: indexPath.row) as! NSDictionary
        cell.lblNote.text = (dd.object(forKey: "Notes") as! String)
        cell.lblNoteDate.text = (dd.object(forKey: "CreatedDate") as! String)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dd: NSDictionary = arrOfNotes.object(at: indexPath.row) as! NSDictionary
        txtNoteMessage.text = (dd.object(forKey: "Notes") as! String)
        noteID = dd.object(forKey: "NoteID") as! Int
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let dd: NSDictionary = arrOfNotes.object(at: indexPath.row) as! NSDictionary
            deleteNote(dd: dd)
        }
    }
    
    //MARK:- Call API
    func getAllNotes(show:Bool)
    {
        arrOfNotes = NSMutableArray()
        if show == true
        {
            custObj.showSVHud("Loading")
        }
        let dd: NSMutableDictionary = NSMutableDictionary()
        dd.setValue(API.getToken(), forKey: "Token")
        dd.setValue(API.getDeviceToken(), forKey: "DeviceID")
        dd.setValue(API.getPageIndex(), forKey: "PageIndex")
        dd.setValue(API.getRoleName(), forKey: "RoleName")
        dd.setValue(rosterID, forKey: "RosterID")
        dd.setValue(API.getUserId(), forKey: "UserID")
        print(dd)
        API.callApiPOST(strUrl: API_GetNotes,parameter: dd, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                for item in arr
                {
                    let dd: NSDictionary = item as! NSDictionary
                    let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
                    self.arrOfNotes.add(dictMutable)
                }
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblCalendarNote.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func createNote()
    {
        custObj.showSVHud("Loading")
        let dd: NSMutableDictionary = NSMutableDictionary()
        dd.setValue(API.getToken(), forKey: "Token")
        dd.setValue(API.getDeviceToken(), forKey: "DeviceID")
        dd.setValue(API.getRoleName(), forKey: "RoleName")
        dd.setValue(rosterID, forKey: "RosterID")
        dd.setValue(API.getUserId(), forKey: "UserID")
        dd.setValue(txtNoteMessage.text, forKey: "Notes")
        dd.setValue(noteID, forKey: "NoteID")
        print(dd)
        API.callApiPOST(strUrl: API_CreateNote,parameter: dd, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.txtNoteMessage.text = ""
                self.noteID = 0
                self.getAllNotes(show: false)
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblCalendarNote.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
    func deleteNote(dd:NSDictionary)
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(dd.object(forKey: "NoteID"), forKey: "NoteID")
        print(parameter)
        API.callApiPOST(strUrl: API_DeleteNote,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.arrOfNotes.remove(dd)
            }
            else
            {
                self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
            }
            self.tblCalendarNote.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
        })
    }
}
