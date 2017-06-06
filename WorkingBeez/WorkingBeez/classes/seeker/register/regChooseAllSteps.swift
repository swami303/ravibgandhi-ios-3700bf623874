//
//  regChooseAllSteps.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/21/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class regChooseAllSteps: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{

    //MARK:- Outlet
    @IBOutlet weak var btnPrev: UIButton!
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
    
    @IBOutlet weak var cvCertificate: UICollectionView!
    @IBOutlet weak var viewAddCertificate: UIView!
    @IBOutlet weak var viewExperience: UIView!
    @IBOutlet weak var lblWorkExp: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYear: cButton!
    @IBOutlet weak var btnMonth: cButton!
    @IBOutlet weak var txtSearch: paddingTextField!
    
    @IBOutlet weak var scrTop: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrBottom: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var scrMain: TPKeyboardAvoidingScrollView!
    
    var strWhichStep: String = "1"
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        btnPrev.isHidden = true
        setProgress()
        
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
        btnPrev.isHidden = false
        if strWhichStep == "1"
        {
            strWhichStep = "2"
        }
        else if strWhichStep == "2"
        {
            strWhichStep = "3"
        }
        else if strWhichStep == "3"
        {
            strWhichStep = "4"
        }
        else if strWhichStep == "4"
        {
            strWhichStep = "5"
        }
        else
        {
            strWhichStep = "6"
        }
        setProgress()
    }
    @IBAction func btnPrev(_ sender: Any)
    {
        if strWhichStep == "6"
        {
            strWhichStep = "4"
        }
        else if strWhichStep == "5"
        {
            strWhichStep = "4"
        }
        else if strWhichStep == "4"
        {
            strWhichStep = "3"
        }
        else if strWhichStep == "3"
        {
            strWhichStep = "2"
        }
        else
        {
            strWhichStep = "1"
            btnPrev.isHidden = true
        }
        setProgress()
    }
    @IBAction func btnYes(_ sender: Any)
    {
        btnYear.isHidden = false
        btnMonth.isHidden = false
        btnYes.isSelected = true
        btnNo.isSelected = false
    }
    @IBAction func btnNo(_ sender: Any)
    {
        btnYear.isHidden = true
        btnMonth.isHidden = true
        btnYes.isSelected = false
        btnNo.isSelected = true
    }
    @IBAction func btnYear(_ sender: Any)
    {
    }
    @IBAction func btnMonth(_ sender: Any)
    {
    }
    
    //MARK:- Private Method
    func setProgress()
    {
        viewAddCertificate.isHidden = true
        viewExperience.isHidden = true
        if strWhichStep == "1"
        {
            self.navigationItem.title = "JOB TITLE"
            lblSelectedStep.text = "Selected Job Title"
            lblStep1.borderColor = API.themeColorPink()
            lblStep1.textColor = API.themeColorPink()
            
            
            lblStep2.borderColor = API.darkGray()
            lblStep2.textColor = API.darkGray()
            
            lblStep3.borderColor = API.darkGray()
            lblStep3.textColor = API.darkGray()
            
            
            lblStep4.borderColor = API.darkGray()
            lblStep4.textColor = API.darkGray()
            
            
            lblStep5.borderColor = API.darkGray()
            lblStep5.textColor = API.darkGray()
            
            
            lblLine1.backgroundColor = API.darkGray()
            lblLine2.backgroundColor = API.darkGray()
            lblLine3.backgroundColor = API.darkGray()
            lblLine4.backgroundColor = API.darkGray()
            
        }
        else if strWhichStep == "2"
        {
            self.navigationItem.title = "CERTIFICATION"
            lblSelectedStep.text = "Selected Certifications 3/8"
            lblStep1.borderColor = API.themeColorPink()
            lblStep1.textColor = API.themeColorPink()
            
            lblStep2.borderColor = API.themeColorPink()
            lblStep2.textColor = API.themeColorPink()
            
            lblStep3.borderColor = API.darkGray()
            lblStep3.textColor = API.darkGray()
            
            lblStep4.borderColor = API.darkGray()
            lblStep4.textColor = API.darkGray()
            
            lblStep5.borderColor = API.darkGray()
            lblStep5.textColor = API.darkGray()
            
            lblLine1.backgroundColor = API.themeColorPink()
            lblLine2.backgroundColor = API.darkGray()
            lblLine3.backgroundColor = API.darkGray()
            lblLine4.backgroundColor = API.darkGray()
        }
        else if strWhichStep == "3"
        {
            self.navigationItem.title = "UPLOAD CERTIFICATION"
            
            lblStep1.borderColor = API.themeColorPink()
            lblStep1.textColor = API.themeColorPink()
            
            lblStep2.borderColor = API.themeColorPink()
            lblStep2.textColor = API.themeColorPink()
            
            lblStep3.borderColor = API.themeColorPink()
            lblStep3.textColor = API.themeColorPink()
            
            lblStep4.borderColor = API.darkGray()
            lblStep4.textColor = API.darkGray()
            
            lblStep5.borderColor = API.darkGray()
            lblStep5.textColor = API.darkGray()
            
            lblLine1.backgroundColor = API.themeColorPink()
            lblLine2.backgroundColor = API.themeColorPink()
            lblLine3.backgroundColor = API.darkGray()
            lblLine4.backgroundColor = API.darkGray()
            
            viewAddCertificate.isHidden = false
        }
        else if strWhichStep == "4"
        {
            self.navigationItem.title = "CORE SKILL"
            lblSelectedStep.text = "Selected Core Skills 3/8"
            
            lblStep1.borderColor = API.themeColorPink()
            lblStep1.textColor = API.themeColorPink()
            
            lblStep2.borderColor = API.themeColorPink()
            lblStep2.textColor = API.themeColorPink()
            
            lblStep3.borderColor = API.themeColorPink()
            lblStep3.textColor = API.themeColorPink()
            
            lblStep4.borderColor = API.themeColorPink()
            lblStep4.textColor = API.themeColorPink()
            
            lblStep5.borderColor = API.darkGray()
            lblStep5.textColor = API.darkGray()
            
            lblLine1.backgroundColor = API.themeColorPink()
            lblLine2.backgroundColor = API.themeColorPink()
            lblLine3.backgroundColor = API.themeColorPink()
            lblLine4.backgroundColor = API.darkGray()
        }
        else if strWhichStep == "5"
        {
            self.navigationItem.title = "EXPERIENCE"
            
            lblStep1.borderColor = API.themeColorPink()
            lblStep1.textColor = API.themeColorPink()
            
            lblStep2.borderColor = API.themeColorPink()
            lblStep2.textColor = API.themeColorPink()
            
            lblStep3.borderColor = API.themeColorPink()
            lblStep3.textColor = API.themeColorPink()
            
            lblStep4.borderColor = API.themeColorPink()
            lblStep4.textColor = API.themeColorPink()
            
            lblStep5.borderColor = API.themeColorPink()
            lblStep5.textColor = API.themeColorPink()
            
            lblLine1.backgroundColor = API.themeColorPink()
            lblLine2.backgroundColor = API.themeColorPink()
            lblLine3.backgroundColor = API.themeColorPink()
            lblLine4.backgroundColor = API.themeColorPink()
            viewExperience.isHidden = false
        }
        else
        {
            viewExperience.isHidden = false
            let obj: regIDProof = self.storyboard?.instantiateViewController(withIdentifier: "regIDProof") as! regIDProof
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    
    //MARK:- collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if indexPath.row == 3
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addMoreCell", for: indexPath as IndexPath) as! certificateCell
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "certificateCell", for: indexPath as IndexPath) as! certificateCell
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
}
