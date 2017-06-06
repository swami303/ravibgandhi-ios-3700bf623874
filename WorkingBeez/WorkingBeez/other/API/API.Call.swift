//
//  API.Call.swift
//  SnowSensei
//
//  Created by Brainstorm on 12/6/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import Foundation

extension API
{
    public static func callApiPOST(strUrl: String, parameter: NSDictionary, success: ((NSDictionary) -> Void)?, error: ((NSError) -> Void)?)
    {
        let custObj: customClassViewController = customClassViewController()
        
        manager?.post(strUrl, parameters: parameter,
                      success: { (op, response) -> Void in
                        
                        let dict: NSDictionary!
                        dict = response as! NSDictionary
                        success? (dict)
        },failure: { (op, fault) -> Void in
            print(fault ?? 0)
            custObj.hideSVHud()
            if custObj.checkInternet() == false
            {
                
            }
            else
            {
                custObj.alertMessage(ERROR_MESSAGE)
            }
        })
    }
    public static func callApiGET(strUrl: String, parameter: NSDictionary, success: ((NSDictionary) -> Void)?, error: ((NSError) -> Void)?)
    {
        let custObj: customClassViewController = customClassViewController()
        
        manager?.get(strUrl, parameters: parameter,
                      success: { (op, response) -> Void in
                        
                        let dict: NSDictionary!
                        dict = response as! NSDictionary
                        success? (dict)
        },failure: { (op, fault) -> Void in
            print(fault ?? 0)
            custObj.hideSVHud()
            if custObj.checkInternet() == false
            {
                
            }
            else
            {
                custObj.alertMessage(ERROR_MESSAGE)
            }
        })
    }
    public static func callApiWithArray(strUrl: String, parameter: NSMutableArray, success: ((NSDictionary) -> Void)?, error: ((NSError) -> Void)?)
    {
        let custObj: customClassViewController = customClassViewController()
        
        manager?.post(strUrl, parameters: parameter,
                      success: { (op, response) -> Void in
                        
                        let dict: NSDictionary!
                        dict = response as! NSDictionary
                        success? (dict)
        },failure: { (op, fault) -> Void in
            print(fault ?? 0)
            custObj.hideSVHud()
            if custObj.checkInternet() == false
            {
                
            }
            else
            {
                custObj.alertMessage(ERROR_MESSAGE)
            }
        })
    }
    
    public static func verifyABN(strUrl: String, parameter: NSDictionary, success: ((NSDictionary) -> Void)?, error: ((NSError) -> Void)?)
    {
        let custObj: customClassViewController = customClassViewController()
        
        let managerABN: AFHTTPRequestOperationManager!
        managerABN = AFHTTPRequestOperationManager(baseURL: URL(string: "https://abr.business.gov.au/json/"))
        //managerABN?.securityPolicy.allowInvalidCertificates = true
        //managerABN?.securityPolicy.validatesDomainName = false
        //managerABN?.requestSerializer = AFJSONRequestSerializer()
        //managerABN?.responseSerializer = AFJSONResponseSerializer()
        manager?.responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments)
        managerABN?.get(strUrl, parameters: parameter,
                     success: { (op, response) -> Void in
                        
                        let dict: NSDictionary!
                        dict = response as! NSDictionary
                        success? (dict)
        },failure: { (op, fault) -> Void in
            print(fault ?? 0)
            //SVProgressHUD.dismiss()
            custObj.hideSVHud()
            if custObj.checkInternet() == false
            {
                
            }
            else
            {
                custObj.alertMessage(ERROR_MESSAGE)
            }
        })
    }
}
