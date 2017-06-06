//
//  landingClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/20/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class landingClass: UIViewController
{

    
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Action Zone
    @IBAction func btnPost(_ sender: Any)
    {
        API.setRole(role: "2")
        API.setRoleName(role: "Poster")
        let obj: loginClass = self.storyboard?.instantiateViewController(withIdentifier: "loginClass") as! loginClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnSeek(_ sender: Any)
    {
        API.setRole(role: "1")
        API.setRoleName(role: "Seeker")
        let obj: loginClass = self.storyboard?.instantiateViewController(withIdentifier: "loginClass") as! loginClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
}
