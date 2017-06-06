//
//  aboutUsClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/22/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class aboutUsClass: UIViewController,UITableViewDataSource, UITableViewDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var tblAbout: STCollapseTableView!
    
    var arrOfAboutHeader: NSMutableArray = NSMutableArray()
    var arrOfAboutHeaderInner: NSMutableArray = NSMutableArray()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.openAbout), name: NSNotification.Name(rawValue: "openAbout"), object: nil)
        
        view.backgroundColor = API.appBackgroundColor()
        tblAbout.backgroundColor = UIColor.white
        //arrOfAboutHeaderInner.add("User Agreement")
        //arrOfAboutHeaderInner.add("Licenses")
    }
    override func viewWillAppear(_ animated: Bool)
    {
        tblAbout.delegate = self
        tblAbout.dataSource = self
        
        //tblAbout.openSection(0, animated:false)
        tblAbout.layer.cornerRadius = 10
        tblAbout.clipsToBounds = true
        
        arrOfAboutHeader = NSMutableArray()
        arrOfAboutHeaderInner = NSMutableArray()
        
        arrOfAboutHeader.add("About")
        arrOfAboutHeader.add("Legal")
        
        arrOfAboutHeaderInner.add("Privacy Policy")
        arrOfAboutHeaderInner.add("Terms")
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        tblAbout.delegate = nil
        tblAbout.dataSource = nil
        //tblAbout = nil
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    func openAbout()
    {
        let obj: webViewClass = self.storyboard?.instantiateViewController(withIdentifier: "webViewClass") as! webViewClass
        obj.strNavTitle = "About"
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- tableView delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrOfAboutHeader.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 0
        }

        return arrOfAboutHeaderInner.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
        cell.backgroundColor = API.lightGray()
        cell.lblAboutUsOptionName.text = arrOfAboutHeaderInner.object(at: indexPath.row) as? String
        cell.backgroundColor = UIColor.white
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let obj: webViewClass = self.storyboard?.instantiateViewController(withIdentifier: "webViewClass") as! webViewClass
            obj.strNavTitle = (arrOfAboutHeaderInner.object(at: indexPath.row) as! String)
            self.navigationController!.pushViewController(obj, animated: true)
        }
        else
        {
            let obj: webViewClass = self.storyboard?.instantiateViewController(withIdentifier: "webViewClass") as! webViewClass
            obj.strNavTitle = (arrOfAboutHeaderInner.object(at: indexPath.row) as! String)
            self.navigationController!.pushViewController(obj, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var headerView: UIView = UIView()
        headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tblAbout.frame.size.width, height: 44))
        
        var lbl: UILabel = UILabel()
        lbl = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 200, height: 44))
        lbl.textColor = API.blackColor()
        lbl.text = arrOfAboutHeader.object(at: section) as? String
        lbl.font = UIFont.init(name: font_openSans_regular, size: 14)
        var lblDivider: UILabel = UILabel()
        lblDivider = UILabel.init(frame: CGRect.init(x: 4, y: 43, width: tblAbout.frame.size.width-8, height: 1))
        lblDivider.backgroundColor = API.dividerColor()
        
        var imgArrow: UIImageView = UIImageView()
        imgArrow = UIImageView.init(frame: CGRect.init(x: tblAbout.frame.size.width - 20, y: 16, width: 8, height: 16))
        imgArrow.image = UIImage.init(named: "next")
        
        headerView.addSubview(imgArrow)
        
        headerView.addSubview(lbl)
        headerView.addSubview(lblDivider)
        headerView.backgroundColor = UIColor.white
        
        return headerView
    }
}
