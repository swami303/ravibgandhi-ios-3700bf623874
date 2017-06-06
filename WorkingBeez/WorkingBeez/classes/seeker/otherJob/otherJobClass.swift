//
//  otherJobClass.swift
//  WorkingBeez
//
//  Created by Swami on 3/8/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class otherJobClass: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate
{
    @IBOutlet weak var cvOtherJob: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrOfOtherJob: NSMutableArray = NSMutableArray()
    var arrOfOtherJobTemp: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    var contentMsg: ContentMessageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        contentMsg = ContentMessageView.CreateView(self.view, strMessage: "No records found", strImageName: "WB_Font", color: UIColor.lightGray)
        contentMsg.isHidden = true
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        layout.itemSize = CGSize(width: 95, height: 95)
        cvOtherJob.collectionViewLayout = layout
        
        cvOtherJob.delegate = self
        cvOtherJob.dataSource = self
        
        view.backgroundColor = API.appBackgroundColor()
        
        cvOtherJob.layer.cornerRadius = 10.0
        cvOtherJob.clipsToBounds = true
        getJobHub()
        
        searchBar.placeholder = "Search here"
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrOfOtherJob.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "otherJobCollectionCell", for: indexPath as IndexPath) as! otherJobCollectionCell
        let dd: NSDictionary = arrOfOtherJob.object(at: indexPath.row) as! NSDictionary
        cell.lblOtherJobCategoryTitle.layer.cornerRadius = cell.lblOtherJobCategoryTitle.frame.size.width / 2
        cell.lblOtherJobCategoryTitle.clipsToBounds = true
        
        cell.lblOtherJobCategoryTitle.text = dd.object(forKey: "Name") as? String
        cell.lblOtherJobCounter.text = String(format: "%d",dd.object(forKey: "Counter") as! Int)
        
        cell.lblOtherJobCounter.layer.cornerRadius = cell.lblOtherJobCounter.frame.size.width / 2
        cell.lblOtherJobCounter.clipsToBounds = true
        cell.lblOtherJobCounter.backgroundColor = API.counterBackColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let obj : otherJobListClass = self.storyboard?.instantiateViewController(withIdentifier: "otherJobListClass") as! otherJobListClass
        obj.dictFrom = arrOfOtherJob.object(at: indexPath.row) as! NSDictionary
        self.navigationController?.pushViewController(obj, animated: true)
    }
    //MARK:- Searchbar delegate
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.showsCancelButton = true
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.view.endEditing(true)
        self.arrOfOtherJob = NSMutableArray()
        if searchBar.text?.length == 0
        {
            self.arrOfOtherJob = NSMutableArray.init(array: self.arrOfOtherJobTemp)
            self.cvOtherJob.reloadData()
            if self.arrOfOtherJob.count == 0
            {
                self.contentMsg.isHidden = false
            }
            else
            {
                self.contentMsg.isHidden = true
            }
        }
        else
        {
            self.arrOfOtherJob = NSMutableArray()
            for dd in self.arrOfOtherJobTemp
            {
                let obj = dd as! NSDictionary
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: obj)
                let str: String = dictMutable.object(forKey: "Name") as! String
                if str.lowercased().contains((searchBar.text?.lowercased())!)
                {
                    self.arrOfOtherJob.add(obj)
                }
            }
            self.cvOtherJob.reloadData()
            if self.arrOfOtherJob.count == 0
            {
                self.contentMsg.isHidden = false
            }
            else
            {
                self.contentMsg.isHidden = true
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.length == 0
        {
            self.arrOfOtherJob = NSMutableArray.init(array: self.arrOfOtherJobTemp)
            self.cvOtherJob.reloadData()
            if self.arrOfOtherJob.count == 0
            {
                self.contentMsg.isHidden = false
            }
            else
            {
                self.contentMsg.isHidden = true
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        var serachText = ""
        if searchBar.text?.characters.count == 0
        {
            serachText = text
        }
        else if range.location > 0 && range.length == 1 && text.characters.count == 0 {
            serachText = (searchBar.text?.substring(to: (searchBar.text?.index((searchBar.text?.startIndex)!, offsetBy: (searchBar.text?.characters.count)! - 1))!))!
        }
        else if text.characters.count == 0 && searchBar.text?.characters.count == 1 {
            serachText = ""
        }
        else if text.characters.count == 0 && (searchBar.text?.characters.count)! > 1
        {
            serachText = ""
        }
        else
        {
            serachText = (searchBar.text?.appending(text))!
        }
        if serachText.length == 0
        {
            self.arrOfOtherJob = NSMutableArray.init(array: self.arrOfOtherJobTemp)
            self.cvOtherJob.reloadData()
            if self.arrOfOtherJob.count == 0
            {
                self.contentMsg.isHidden = false
            }
            else
            {
                self.contentMsg.isHidden = true
            }
        }
        else
        {
            self.arrOfOtherJob = NSMutableArray()
            for dd in self.arrOfOtherJobTemp
            {
                let obj = dd as! NSDictionary
                let dictMutable: NSMutableDictionary = NSMutableDictionary.init(dictionary: obj)
                let str: String = dictMutable.object(forKey: "Name") as! String
                if str.lowercased().contains(serachText.lowercased())
                {
                    self.arrOfOtherJob.add(obj)
                }
            }
            self.cvOtherJob.reloadData()
            if self.arrOfOtherJob.count == 0
            {
                self.contentMsg.isHidden = false
            }
            else
            {
                self.contentMsg.isHidden = true
            }
        }
        return true
    }
    //MARK:- API CALL
    func getJobHub()
    {
        arrOfOtherJob = NSMutableArray()
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getPageIndex(), forKey: "PageIndex")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "SeekerID")
        print(parameter)
        API.callApiPOST(strUrl: API_GetOtherJobs,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arr: NSArray = response.object(forKey: "Data") as! NSArray
                self.arrOfOtherJob = NSMutableArray.init(array: arr)
                self.arrOfOtherJobTemp = NSMutableArray.init(array: arr)
                self.contentMsg.isHidden = true
            }
            else
            {
                //self.custObj.alertMessage(response.object(forKey: "ReturnMsg") as! String)
                self.contentMsg.isHidden = false
            }
            self.cvOtherJob.reloadData()
        }, error: { (error) in
            print(error)
            self.custObj.hideSVHud()
            self.custObj.alertMessage(ERROR_MESSAGE)
            self.contentMsg.isHidden = false
        })
    }
}
