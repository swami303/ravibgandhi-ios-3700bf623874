//
//  chooseLocationToPost.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/23/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class chooseLocationToPost: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,UIAlertViewDelegate,CLLocationManagerDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var lblCompletedJobCnt: cLable!
    @IBOutlet weak var lblCompletedJobBack: cLable!
    @IBOutlet weak var lblSavedProfileCnt: cLable!
    @IBOutlet weak var lblSavedProfileBack: cLable!
    @IBOutlet weak var lblPostHistoryCnt: cLable!
    @IBOutlet weak var lblPostHistoryBack: cLable!
    @IBOutlet weak var txtWhere: paddingTextField!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var imgDropDownArraow: UIImageView!
    
    var onlyOnce: Int = 0
    var firstTime: Int = 0
    var locationManager: CLLocationManager!
    var dd: NSDictionary!
    var strLat: String = ""
    var strLong: String = ""
    var arrOfLocation: NSMutableArray = NSMutableArray()
    var arrOfHomeLocation: NSMutableArray = NSMutableArray()
    var mainManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    var deleObj: AppDelegate!
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        map.delegate = self
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        super.viewDidLoad()
        lblPostHistoryBack.layer.cornerRadius = (40*UIScreen.main.bounds.size.width)/320
        lblPostHistoryBack.clipsToBounds = true
        
        lblSavedProfileBack.layer.cornerRadius = (40*UIScreen.main.bounds.size.width)/320
        lblSavedProfileBack.clipsToBounds = true
        
        lblCompletedJobBack.layer.cornerRadius = (40*UIScreen.main.bounds.size.width)/320
        lblCompletedJobBack.clipsToBounds = true
        
        lblPostHistoryCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblPostHistoryCnt.clipsToBounds = true
        
        lblSavedProfileCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblSavedProfileCnt.clipsToBounds = true
        
        lblCompletedJobCnt.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        lblCompletedJobCnt.clipsToBounds = true
        
        lblCompletedJobCnt.backgroundColor = API.counterBackColor()
        lblSavedProfileCnt.backgroundColor = API.counterBackColor()
        lblPostHistoryCnt.backgroundColor = API.counterBackColor()
        
        map.layer.cornerRadius = (10*UIScreen.main.bounds.size.width)/320
        map.clipsToBounds = true
        
        tblLocation.layer.cornerRadius = (15*UIScreen.main.bounds.size.width)/320
        tblLocation.clipsToBounds = true
        
        tblLocation.delegate = self
        tblLocation.dataSource = self
        
        tblLocation.isHidden = true
        
        txtWhere.delegate = self
        
        imgDropDownArraow.tintColor = UIColor.white

        self.getUSerSetting()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        dd = API.getLoggedUserData()
        
        lblPostHistoryCnt.text = String(format: "%d", dd.object(forKey: "TotalPostHistory") as! Int)
        lblCompletedJobCnt.text = String(format: "%d", dd.object(forKey: "TotalCompletedJob") as! Int)
        lblSavedProfileCnt.text = String(format: "%d", dd.object(forKey: "TotalSavedProfile") as! Int)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnCompletedJob(_ sender: Any)
    {
        let obj: completedJobPoster = self.storyboard?.instantiateViewController(withIdentifier: "completedJobPoster") as! completedJobPoster
        self.navigationController!.pushViewController(obj, animated: true)
//        let obj: setRosterClass = self.storyboard?.instantiateViewController(withIdentifier: "setRosterClass") as! setRosterClass
//        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnSavedProfile(_ sender: Any)
    {
        let obj: savedProfileClass = self.storyboard?.instantiateViewController(withIdentifier: "savedProfileClass") as! savedProfileClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnPostHistory(_ sender: Any)
    {
        let obj: postHistoryClass = self.storyboard?.instantiateViewController(withIdentifier: "postHistoryClass") as! postHistoryClass
        self.navigationController!.pushViewController(obj, animated: true)
    }
    @IBAction func btnNext(_ sender: Any)
    {
        if txtWhere.text == "" || strLat == "" || strLong == ""
        {
            custObj.alertMessage("Please set location")
            return
        }
        deleObj.dictPosJob.setValue(strLat, forKey: "Latitude")
        deleObj.dictPosJob.setValue(strLong, forKey: "Longitude")
        deleObj.dictPosJob.setValue(txtWhere.text, forKey: "LocationName")
        deleObj.dictPosJob.setValue(API.getToken(), forKey: "Token")
        deleObj.dictPosJob.setValue(API.getDeviceToken(), forKey: "DeviceID")
        deleObj.dictPosJob.setValue(API.getUserId(), forKey: "UserID")
        
        let obj: chooseCateToPost = self.storyboard?.instantiateViewController(withIdentifier: "chooseCateToPost") as! chooseCateToPost
        self.navigationController!.pushViewController(obj, animated: true)
    }
    
    //MARK:- UITableviewDelegatde
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if txtWhere.text == ""
        {
            return arrOfHomeLocation.count
        }
        return arrOfLocation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
        cell.imgLocatiobIcon.tintColor = API.blackColor()
        if txtWhere.text == ""
        {
            let dd: NSDictionary = arrOfHomeLocation.object(at: indexPath.row) as! NSDictionary
            cell.lblLocationName.text = dd.object(forKey: "BaseName") as? String
        }
        else
        {
            let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
            cell.lblLocationName?.text = dd.object(forKey: "description") as? String
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if txtWhere.text == ""
        {
            let dd: NSDictionary = arrOfHomeLocation.object(at: indexPath.row) as! NSDictionary
            if dd.object(forKey: "BaseName") as! String == "Current Location"
            {
                getCurrentLocation()
                tblLocation.isHidden = true
                self.view.endEditing(true)
            }
            else
            {
                txtWhere.text = dd.object(forKey: "LocationName") as? String
                strLat = dd.object(forKey: "Latitude") as! String
                strLong = dd.object(forKey: "Longitude") as! String
                tblLocation.isHidden = true
                let coordinateDesti = CLLocation(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!)
                let coordinateSource = CLLocation(latitude: -27.4698, longitude: 153.0251)
                let distance: Double = coordinateDesti.distance(from: coordinateSource)
                
                if distance/1000 < deleObj.distanceToPostJob || deleObj.distanceToPostJob == -1
                {
                    self.view.endEditing(true)
                    self.map.removeAnnotations(self.map.annotations)
                    let newYorkLocation = CLLocationCoordinate2DMake(Double(self.strLat)!, Double(self.strLong)!)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = newYorkLocation
                    dropPin.title = "Your Location"
                    self.map.addAnnotation(dropPin)
                    self.zoomPin()
                }
                else
                {
                    txtWhere.text = ""
                    strLat = ""
                    strLong = ""
                    self.custObj.alertMessage(SEVERING_MESSAGE)
                }
            }
        }
        else
        {
            let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
            txtWhere.text = dd.object(forKey: "description") as? String
            tblLocation.isHidden = true
            self.view.endEditing(true)
            getLatLong(str: dd.object(forKey: "description") as! String)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 36
    }
    //MARK:- Get Current Location
    func getCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        NSLog("didUpdateToLocation: %@", locations)
        
        let currentLocation: CLLocation = locations[0]
        locationManager.stopUpdatingLocation()
        strLat = String(format: "%.8f", currentLocation.coordinate.latitude)
        strLong = String(format: "%.8f", currentLocation.coordinate.longitude)
        let coordinateDesti = CLLocation(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!)
        let coordinateSource = CLLocation(latitude: -27.4698, longitude: 153.0251)
        let distance: Double = coordinateDesti.distance(from: coordinateSource)
        
        if distance/1000 < deleObj.distanceToPostJob || deleObj.distanceToPostJob == -1
        {
            self.view.endEditing(true)
            self.map.removeAnnotations(self.map.annotations)
            let newYorkLocation = CLLocationCoordinate2DMake(Double(self.strLat)!, Double(self.strLong)!)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = newYorkLocation
            dropPin.title = "Your Location"
            self.map.addAnnotation(dropPin)
            self.zoomPin()
            setUsersClosestCity()
        }
        else
        {
            txtWhere.text = ""
            strLat = ""
            strLong = ""
            self.custObj.alertMessage(SEVERING_MESSAGE)
        }
       
        locationManager.stopUpdatingLocation()
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        if onlyOnce == 0
        {
            if CLLocationManager.locationServicesEnabled()
            {
                switch(CLLocationManager.authorizationStatus())
                {
                case .notDetermined, .restricted, .denied:
                    let errorAlert: UIAlertView = UIAlertView(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Your location service is disable, We need your location", comment: ""), delegate: self, cancelButtonTitle: NSLocalizedString("Settings", comment: ""), otherButtonTitles: NSLocalizedString("No", comment: ""))
                    errorAlert.show()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                }
            }
            else
            {
                let errorAlert: UIAlertView = UIAlertView(title: NSLocalizedString("Error" ,comment: ""), message: NSLocalizedString("Failed to Get Your Location", comment: ""), delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: ""), otherButtonTitles: "")
                errorAlert.show()
            }
            onlyOnce = onlyOnce + 1
        }
    }
    
    //MARK:- Alert Delegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        //UIApplicationLaunchOptionsLocationKey
        if buttonIndex == 0
        {
            if UIApplication.shared.canOpenURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            {
                UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            }
            else
            {
                NSLog("Cant open")
            }
        }
        else
        {
        }
    }
    //MARK:- UITextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if txtWhere.text != ""
        {
            getLocation(str: txtWhere.text!)
        }
        tblLocation.isHidden = false
        tblLocation.reloadData()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtWhere
        {
            var serachText = ""
            if txtWhere.text?.characters.count == 0
            {
                serachText = string
            }
            else if range.location > 0 && range.length == 1 && string.characters.count == 0 {
                serachText = (txtWhere.text?.substring(to: (txtWhere.text?.index((txtWhere.text?.startIndex)!, offsetBy: (txtWhere.text?.characters.count)! - 1))!))!
            }
            else if string.characters.count == 0 && txtWhere.text?.characters.count == 1 {
                serachText = ""
            }
            else if string.characters.count == 0 && (txtWhere.text?.characters.count)! > 1
            {
                serachText = ""
            }
            else
            {
                serachText = (txtWhere.text?.appending(string))!
            }
            if serachText.length == 0
            {
                txtWhere.text = ""
                tblLocation.reloadData()
            }
            else
            {
                getLocation(str: serachText)
            }
        }
        return true
    }
    //MARK:- API CALL
    //MARK:- APi Call
    func getUSerSetting()
    {
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getUserId(), forKey: "UserID")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        print(parameter)
        API.callApiPOST(strUrl: API_GetUserSettings,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                let arrLoc: NSArray = response.object(forKey: "Location") as! NSArray
                self.arrOfHomeLocation = NSMutableArray.init(array: arrLoc)
                let dd: NSMutableDictionary = NSMutableDictionary()
                dd.setValue("Current Location", forKey: "BaseName")
                self.arrOfHomeLocation.insert(dd, at: 0)
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
    func getLocation(str: String)
    {
        if custObj.checkInternet() == false
        {
            return
        }
        
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(GoogleAutocompleteKey, forKey: "key")
        parameter.setValue(str, forKey: "input")
        
        mainManager.operationQueue.cancelAllOperations()
        mainManager = AFHTTPRequestOperationManager(baseURL: URL(string: "https://maps.googleapis.com/maps/api/"))
        mainManager.operationQueue.cancelAllOperations()
        mainManager.get("place/autocomplete/json", parameters: parameter,
                        success: { (op, response) -> Void in
                            
                            let dict: NSDictionary!
                            dict = response as! NSDictionary
                            print(response ?? 0)
                            let aa: NSArray = dict.object(forKey: "predictions") as! NSArray
                            //print(aa)
                            if aa.count != 0
                            {
                                self.arrOfLocation = NSMutableArray.init(array: aa)
                            }
                            else
                            {
                            }
                            self.tblLocation.reloadData()
        },failure: { (op, fault) -> Void in
            print(op?.error ?? 0)
        })
        
    }
    func getLatLong(str: String)
    {
        if custObj.checkInternet() == false
        {
            return
        }
        custObj.showSVHud("Loading")
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(false, forKey: "sensor")
        parameter.setValue(str, forKey: "address")
        var manager: AFHTTPRequestOperationManager!
        manager = AFHTTPRequestOperationManager(baseURL: URL(string: "http://maps.google.com/maps/api/"))
        manager?.get("geocode/json", parameters: parameter,
                     success: { (op, response) -> Void in
                        
                        let dict: NSDictionary!
                        dict = response as! NSDictionary
                        print(dict)
                        if dict.object(forKey: "status") as! String == "OK"
                        {
                            let arrResult: NSArray = dict.object(forKey: "results") as! NSArray
                            if arrResult.count != 0
                            {
                                print((arrResult.object(at: 0) as AnyObject).object(forKey:"formatted_address") ?? "Not found")
                                let dd: NSDictionary = (arrResult.object(at: 0) as AnyObject).object(forKey:"geometry") as! NSDictionary
                                let ddLocation: NSDictionary = dd.object(forKey: "location") as! NSDictionary
                                self.strLat = String(format: "%f", ddLocation.object(forKey: "lat") as! Float)
                                self.strLong = String(format: "%f", ddLocation.object(forKey: "lng") as! Float)
                                
                                let coordinateDesti = CLLocation(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!)
                                let coordinateSource = CLLocation(latitude: -27.4698, longitude: 153.0251)
                                let distance: Double = coordinateDesti.distance(from: coordinateSource)
                                
                                if distance/1000 < self.deleObj.distanceToPostJob || self.deleObj.distanceToPostJob == -1
                                {
                                    self.map.removeAnnotations(self.map.annotations)
                                    let newYorkLocation = CLLocationCoordinate2DMake(Double(self.strLat)!, Double(self.strLong)!)
                                    let dropPin = MKPointAnnotation()
                                    dropPin.coordinate = newYorkLocation
                                    dropPin.title = "Your Location"
                                    self.map.addAnnotation(dropPin)
                                    self.zoomPin()
                                }
                                else
                                {
                                    self.txtWhere.text = ""
                                    self.strLat = ""
                                    self.strLong = ""
                                    self.custObj.alertMessage(SEVERING_MESSAGE)
                                }
                            }
                        }
                        self.custObj.hideSVHud()
        },failure: { (op, fault) -> Void in
            print(op?.error ?? 0)
            self.custObj.hideSVHud()
        })
    }
    
    //MARK:- MAP
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //        var v : MKAnnotationView! = nil
        //        let ident = "bike"
        //        v = mapView.dequeueReusableAnnotationView(withIdentifier: ident)
        //        if v == nil {
        //            v = MKAnnotationView(annotation:annotation, reuseIdentifier:ident)
        //        }
        //        v.image = UIImage(named: "map_pin")
        //        v.annotation = annotation
        //        v.isDraggable = true
        //        return v
        if annotation is MKPointAnnotation
        {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .red
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            pinAnnotationView.isDraggable = true
            pinAnnotationView.isEnabled = true
            return pinAnnotationView
        }
        
        return nil
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState)
    {
        if newState == MKAnnotationViewDragState.ending
        {
            let ann = view.annotation
            print("annotation dropped at: \(ann!.coordinate.latitude),\(ann!.coordinate.longitude)")
            strLat = String(format: "%f", ann!.coordinate.latitude)
            strLong = String(format: "%f", ann!.coordinate.longitude)
            
            let coordinateDesti = CLLocation(latitude: Double(self.strLat)!, longitude: Double(self.strLong)!)
            let coordinateSource = CLLocation(latitude: -27.4698, longitude: 153.0251)
            let distance: Double = coordinateDesti.distance(from: coordinateSource)
            
            if distance/1000 < deleObj.distanceToPostJob || self.deleObj.distanceToPostJob == -1
            {
                setUsersClosestCity()
            }
            else
            {
                txtWhere.text = ""
                strLat = ""
                strLong = ""
                self.custObj.alertMessage(SEVERING_MESSAGE)
            }
        }
    }
    
    func zoomPin()
    {
        //self.map.showAnnotations(self.map.annotations, animated: true)
        //return
        let latDelta:CLLocationDegrees = 0.05
        
        let lonDelta:CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location = CLLocationCoordinate2DMake(Double(strLat)!, Double(strLong)!)
        
        let region = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        //setUsersClosestCity()
    }
    func setUsersClosestCity()
    {
        if custObj.checkInternet() == false
        {
            return
        }
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(GoogleAutocompleteKey, forKey: "key")
        parameter.setValue(String(format: "%@,%@",strLat,strLong), forKey: "latlng")
        var manager: AFHTTPRequestOperationManager!
        manager = AFHTTPRequestOperationManager(baseURL: URL(string: "https://maps.googleapis.com/maps/api/"))
        manager?.get("geocode/json", parameters: parameter,
                     success: { (op, response) -> Void in
                        
                        let dict: NSDictionary!
                        dict = response as! NSDictionary
                        print(dict)
                        let arrResult: NSArray = dict.object(forKey: "results") as! NSArray
                        if arrResult.count != 0
                        {
                            print((arrResult.object(at: 0) as AnyObject).object(forKey:"formatted_address") ?? "Not found")
                            self.txtWhere.text = (arrResult.object(at: 0) as AnyObject).object(forKey:"formatted_address") as! String
                            //self.actiView.isHidden = true
                        }
        },failure: { (op, fault) -> Void in
            print(op?.error ?? 0)
        })
        
    }
}
