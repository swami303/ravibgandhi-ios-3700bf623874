//
//  API.swift
//  SnowSensei
//
//  Created by Brainstorm on 11/30/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import Foundation

open class API
{
    internal static var manager: AFHTTPRequestOperationManager?
    
    open static func setup()
    {
        UserDefaults.standard.setValue(API_MAIN_URL, forKey: "baseUrl")
        UserDefaults.standard.synchronize()
        manager = AFHTTPRequestOperationManager(baseURL: URL(string: API_MAIN_URL))
        manager?.securityPolicy.allowInvalidCertificates = true
        manager?.securityPolicy.validatesDomainName = false
        manager?.requestSerializer = AFJSONRequestSerializer()
        manager?.responseSerializer = AFJSONResponseSerializer()
    }
    
    open static func setToken(token: String)
    {
        UserDefaults.standard.setValue("123", forKey: "token_id")
        UserDefaults.standard.synchronize()
    }
    open static func getToken() -> String
    {
        return UserDefaults.standard.value(forKey: "token_id") as! String
    }
    open static func setDeviceToken(token: String)
    {
        UserDefaults.standard.setValue(token, forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    open static func getDeviceToken() -> String
    {
        return UserDefaults.standard.value(forKey: "device_token") as! String
    }
    open static func setUserId(user_id: String)
    {
        UserDefaults.standard.setValue(user_id, forKey: "user_id")
        UserDefaults.standard.synchronize()
    }
    open static func getUserId() -> String
    {
        return UserDefaults.standard.value(forKey: "user_id") as! String
    }
    open static func setPageIndex(page: Int)
    {
        UserDefaults.standard.setValue(page, forKey: "page_index")
        UserDefaults.standard.synchronize()
    }
    open static func getPageIndex() -> Int
    {
        return UserDefaults.standard.value(forKey: "page_index") as! Int
    }
    
    
    open static func setInitialValues()
    {
        //UserDefaults.standard.setValue("0", forKey: "user_id")
        //UserDefaults.standard.setValue("123", forKey: "token_id")
        //UserDefaults.standard.synchronize()
    }
    open static func setRole(role: String)
    {
        UserDefaults.standard.setValue(role, forKey: "Role")
        UserDefaults.standard.synchronize()
    }
    open static func getRole() -> String
    {
        return UserDefaults.standard.value(forKey: "Role") as! String
    }
    open static func setRoleName(role: String)
    {
        UserDefaults.standard.setValue(role, forKey: "RoleName")
        UserDefaults.standard.synchronize()
    }
    open static func getRoleName() -> String
    {
        return UserDefaults.standard.value(forKey: "RoleName") as! String
    }
    open static func setLoggedUserData(dict: NSMutableDictionary)
    {
        UserDefaults.standard.setValue(dict, forKey: "userData")
        UserDefaults.standard.synchronize()
    }
    open static func getLoggedUserData() -> NSMutableDictionary
    {
        let dd: NSDictionary = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
        let dictUser: NSMutableDictionary = NSMutableDictionary.init(dictionary: dd)
        return dictUser
    }
    
    open static func setRegType(type: String)
    {
        UserDefaults.standard.setValue(type, forKey: "regType")
        UserDefaults.standard.synchronize()
    }
    open static func getRegType() -> String
    {
        return UserDefaults.standard.value(forKey: "regType") as! String
    }
    open static func setLoginType(type: String)
    {
        UserDefaults.standard.setValue(type, forKey: "loginType")
        UserDefaults.standard.synchronize()
    }
    open static func getLoginType() -> String
    {
        return UserDefaults.standard.value(forKey: "loginType") as! String
    }
    open static func setXMPPUSER(type: String)
    {
        var str: String = ""
        str = String(format: "%@@%@",type,XMPP_HOST)
        UserDefaults.standard.setValue(str, forKey: "xmppUser")
        UserDefaults.standard.synchronize()
    }
    open static func getXMPPUSER() -> String
    {
        return UserDefaults.standard.value(forKey: "xmppUser") as! String
    }
    open static func setXMPPPWD(type: String)
    {
        UserDefaults.standard.setValue(type, forKey: "xmppPwd")
        UserDefaults.standard.synchronize()
    }
    open static func getXMPPPWD() -> String
    {
        return UserDefaults.standard.value(forKey: "xmppPwd") as! String
    }
    open static func setIsLogin(type: Bool)
    {
        UserDefaults.standard.setValue(type, forKey: "isLogin")
        UserDefaults.standard.synchronize()
    }
    open static func getIsLogin() -> Bool
    {
        let contents: Bool?
        do
        {
            contents = try UserDefaults.standard.object(forKey: "isLogin") as? Bool
            if contents == nil
            {
                setIsLogin(type: false)
            }
        }
        catch _ {
            setIsLogin(type: false)
        }
        return UserDefaults.standard.value(forKey: "isLogin") as! Bool
    }
    open static func isFromNotification() -> Bool
    {
        let contents: Bool?
        do
        {
            contents = try UserDefaults.standard.object(forKey: "isFromNotification") as? Bool
            if contents == nil
            {
                setIsFromNotification(type: false)
            }
        }
        catch _ {
            setIsFromNotification(type: false)
        }
        return UserDefaults.standard.value(forKey: "isFromNotification") as! Bool
    }
    open static func setIsFromNotification(type: Bool)
    {
        UserDefaults.standard.setValue(type, forKey: "isFromNotification")
        UserDefaults.standard.synchronize()
    }
    open static func setNotiDict(dict: NSDictionary)
    {
        UserDefaults.standard.setValue(dict, forKey: "setNotiDict")
        UserDefaults.standard.synchronize()
    }
    open static func getNotiDict() -> NSDictionary
    {
        let dd: NSDictionary = UserDefaults.standard.value(forKey: "setNotiDict") as! NSDictionary
        return dd
    }
    //MARK:- Encode
    open static func encodeBase64FromString (_ value: String) -> String
    {
        if let data: Data = value.data(using: String.Encoding.utf8)
        {
            let encoded = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            return encoded.replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ">", with: "")
        }
        return value
    }
    open static func encodeBase64FromData (_ value: Data) -> String
    {
            let encoded = value.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            return encoded.replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ">", with: "")
        return encoded
    }
    
    //MARK:- Color
    open static func themeColorBlue() -> UIColor
    {
        return UIColor.init(red: 82/255.0, green: 167/255.0, blue: 250/255.0, alpha: 1)
    }
    open static func themeColorPink() -> UIColor
    {
        return UIColor.init(red: 249/255.0, green: 82/255.0, blue: 136/255.0, alpha: 1)
    }
    open static func lightBlueColor() -> UIColor
    {
        return UIColor.init(red: 245/255.0, green: 250/255.0, blue: 255/255.0, alpha: 1)
    }
    open static func dividerColor() -> UIColor
    {
        return UIColor.init(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
    }
    open static func lightPinkColor() -> UIColor
    {
        return UIColor.init(red: 255/255.0, green: 245/255.0, blue: 248/255.0, alpha: 1)
    }
    open static func blackColor() -> UIColor
    {
        return UIColor.init(red: 16/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
    }
    open static func darkGray() -> UIColor
    {
        return UIColor.init(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1)
    }
    open static func lightGray() -> UIColor
    {
        return UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
    }
    open static func starRatingColor() -> UIColor
    {
        return UIColor.init(red: 66/255.0, green: 223/255.0, blue: 210/255.0, alpha: 1)
    }
    open static func onlineColor() -> UIColor
    {
        return UIColor.init(red: 135/255.0, green: 209/255.0, blue: 0/255.0, alpha: 1)
    }
    open static func offline() -> UIColor
    {
        return UIColor.init(red: 192/255.0, green: 192/255.0, blue: 192/255.0, alpha: 1)
    }
    open static func NavigationbarColor() -> UIColor
    {
        return UIColor.white
    }
    open static func counterBackColor() -> UIColor
    {
        return UIColor.init(red: 249/255.0, green: 82/255.0, blue: 136/255.0, alpha: 1)
    }
    open static func appBackgroundColor() -> UIColor
    {
        return UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
    }
    open static func trackerColor() -> UIColor
    {
        return UIColor.init(red: 135/255.0, green: 209/255.0, blue: 0/255.0, alpha: 1)
    }
    //MARK:- date
    
    open static func convertDateToString(strDate : String, fromFormat : String, toFormat : String) -> String
    {
        if strDate == ""
        {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = fromFormat
        
        let dateOriginal : Date = dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = toFormat
        let strConvertedDate : String = String.init(format: "%@", dateFormatter.string(from: dateOriginal))
        return strConvertedDate
    }
    
    //MARK:- Apple Map
    open static func openMapForPlace(lat: Double, longi: Double,dd: NSDictionary)
    {
        
        let latitude:CLLocationDegrees =  lat
        let longitude:CLLocationDegrees =  longi
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        if API.getRoleName().lowercased() == "Poster".lowercased()
        {
            mapItem.name = dd.object(forKey: "Name") as? String
        }
        else
        {
            mapItem.name = dd.object(forKey: "CompanyName") as? String
        }
        mapItem.openInMaps(launchOptions: options)
    }
    
   open static func HieghtForText(text: String, font: UIFont, maxSize: CGSize) -> Float
    {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return Float(rect.size.height)
    }
    open static func resetFilter()
    {
        var deleObj: AppDelegate!
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        deleObj.dictFilter.setValue("-1", forKey: "CategoryID")
        deleObj.dictFilter.setValue("-1", forKey: "TitleID")
        deleObj.dictFilter.setValue("-1", forKey: "RatingFrom")
        deleObj.dictFilter.setValue("-1", forKey: "RatingTo")
        deleObj.dictFilter.setValue("-1", forKey: "ExpFrom")
        deleObj.dictFilter.setValue("-1", forKey: "ExpTo")
        deleObj.dictFilter.setValue("-1", forKey: "IsVehicle")
        deleObj.dictFilter.setValue("-1", forKey: "DistanceFrom")
        deleObj.dictFilter.setValue("-1", forKey: "DistanceTo")
    }
    open static func resetFilterSeeker()
    {
        var deleObj: AppDelegate!
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        
        deleObj.dictFilter.setValue("-1", forKey: "CategoryID")
        deleObj.dictFilter.setValue("-1", forKey: "TitleID")
        deleObj.dictFilter.setValue("-1", forKey: "RatingFrom")
        deleObj.dictFilter.setValue("-1", forKey: "RatingTo")
        deleObj.dictFilter.setValue("-1", forKey: "PayRateFrom")
        deleObj.dictFilter.setValue("-1", forKey: "PayRateTo")
        deleObj.dictFilter.setValue("-1", forKey: "Applied")
        deleObj.dictFilter.setValue("-1", forKey: "DistanceFrom")
        deleObj.dictFilter.setValue("-1", forKey: "DistanceTo")
    }
    //MARK:- Get distance
    open static func getDistance(strToLate: String, strToLong: String, strFromLat: String,strFromLong: String) -> String
    {
        
//        let dd: NSDictionary = API.getLoggedUserData()
//        let strFromLat: String = dd.object(forKey: "Latitude") as! String
//        let strFromLong: String = dd.object(forKey: "Longitude") as! String
        
//        print(strFromLat)
//        print(strFromLong)
//        print(strToLate)
//        print(strToLong)
        
        
        let coordinateDesti = CLLocation(latitude: Double(strToLate)!, longitude: Double(strToLong)!)
        let coordinateSource = CLLocation(latitude: Double(strFromLat)!, longitude: Double(strFromLong)!)
        var distance: Double = coordinateDesti.distance(from: coordinateSource)
        if distance < 1000
        {
            return String(format: "%0.2f Mtr", distance)
        }
        else
        {
            distance = distance/1000
            return String(format: "%0.2f Km", distance)
        }
    }
    
}
