//
//  addLocationClass.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/23/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class addLocationClass: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MKMapViewDelegate
{

    //MARK:- Outlet
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var tvLocation: placeholderTextView!
    @IBOutlet weak var txtLocationName: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    var objSetting: settingsPoster!
    var objPostComEdit: completedJobDetailPoster!
    var objPostHisEdit: postHisDetail!
    var fromWhere: String = ""
    var dictFromSetting: NSDictionary!
    var strLat: String = ""
    var strLong: String = ""
    var arrOfLocation: NSMutableArray = NSMutableArray()
    var deleObj: AppDelegate!
    var mainManager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    let custObj: customClassViewController = customClassViewController()
    //MARK:- View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        deleObj = UIApplication.shared.delegate as! AppDelegate!
        tblLocation.layer.cornerRadius = 15
        tblLocation.clipsToBounds = true
        
        tblLocation.isHidden = true
        tvLocation.layer.cornerRadius = 10
        tvLocation.clipsToBounds = true
        tblLocation.delegate = self
        tblLocation.dataSource = self
        txtLocationName.layer.borderColor = API.dividerColor().cgColor
        txtLocationName.layer.borderWidth = 1
        tvLocation.layer.borderColor = API.dividerColor().cgColor
        tvLocation.layer.borderWidth = 1
        
        tvLocation.delegate = self
        
        
        
        map.delegate = self
        if fromWhere == "objPostHisEdit"
        {
            txtLocationName.isHidden = true
            tvLocation.frame.origin.y = txtLocationName.frame.origin.y
            tblLocation.frame = CGRect.init(x: tblLocation.frame.origin.x, y: tvLocation.frame.size.height + tvLocation.frame.origin.y, width: tblLocation.frame.size.width, height: tblLocation.frame.size.height + 30)
            
            strLat = objPostHisEdit.strLat
            strLong = objPostHisEdit.strLong
            tvLocation.text = objPostHisEdit.btnAddress.currentTitle
            
            self.map.removeAnnotations(self.map.annotations)
            let newYorkLocation = CLLocationCoordinate2DMake(Double(self.strLat)!, Double(self.strLong)!)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = newYorkLocation
            dropPin.title = "Your Location"
            self.map.addAnnotation(dropPin)
            self.zoomPin()
        }
        else if fromWhere == "objPostComEdit"
        {
            txtLocationName.isHidden = true
            tvLocation.frame.origin.y = txtLocationName.frame.origin.y
            tblLocation.frame = CGRect.init(x: tblLocation.frame.origin.x, y: tvLocation.frame.size.height + tvLocation.frame.origin.y, width: tblLocation.frame.size.width, height: tblLocation.frame.size.height + 30)
            
            strLat = objPostComEdit.strLat
            strLong = objPostComEdit.strLong
            tvLocation.text = objPostComEdit.btnAddress.currentTitle
            
            self.map.removeAnnotations(self.map.annotations)
            let newYorkLocation = CLLocationCoordinate2DMake(Double(self.strLat)!, Double(self.strLong)!)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = newYorkLocation
            dropPin.title = "Your Location"
            self.map.addAnnotation(dropPin)
            self.zoomPin()
        }
        else if fromWhere == "setting"
        {
            strLat = dictFromSetting.object(forKey: "Latitude") as! String
            strLong = dictFromSetting.object(forKey: "Longitude") as! String
            txtLocationName.text = dictFromSetting.object(forKey: "BaseName") as? String
            if txtLocationName.text?.lowercased() == "Add more".lowercased()
            {
                txtLocationName.text = ""
            }
            tvLocation.text = dictFromSetting.object(forKey: "LocationName") as? String
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action Zone
    @IBAction func btnSave(_ sender: Any)
    {
        if fromWhere == "setting"
        {
            if txtLocationName.text == "" || strLat == "" || strLong == ""
            {
                custObj.alertMessage("Please enter location name")
                return
            }
            if tvLocation.text == ""
            {
                custObj.alertMessage("Please choose your location")
                return
            }
            saveLocation()
        }
        else if fromWhere == "objPostHisEdit"
        {
            if tvLocation.text == "" || strLat == "" || strLong == ""
            {
                custObj.alertMessage("Please choose your location")
                return
            }
            objPostHisEdit.strLat = strLat
            objPostHisEdit.strLong = strLong
            objPostHisEdit.btnAddress.setTitle(tvLocation.text, for: UIControlState.normal)
            _ = self.navigationController?.popViewController(animated: true)
        }
        else if fromWhere == "objPostComEdit" || strLat == "" || strLong == ""
        {
            if tvLocation.text == ""
            {
                custObj.alertMessage("Please choose your location")
                return
            }
            objPostComEdit.strLat = strLat
            objPostComEdit.strLong = strLong
            objPostComEdit.btnAddress.setTitle(tvLocation.text, for: UIControlState.normal)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- UITableviewDelegatde
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrOfLocation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! customCellSwift
        let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
        cell.lblLocationName?.text = dd.object(forKey: "description") as? String
        cell.imgLocatiobIcon.tintColor = API.blackColor()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dd: NSDictionary = arrOfLocation.object(at: indexPath.row) as! NSDictionary
        tvLocation.text = dd.object(forKey: "description") as? String
        tblLocation.isHidden = true
        self.view.endEditing(true)
        getLatLong(str: dd.object(forKey: "description") as! String)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 36
    }
    //MARK:- TextView delegate
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView == tvLocation
        {
            var serachText = ""
            if tvLocation.text?.characters.count == 0
            {
                serachText = text
            }
            else if range.location > 0 && range.length == 1 && text.characters.count == 0 {
                serachText = (tvLocation.text?.substring(to: (tvLocation.text?.index((tvLocation.text?.startIndex)!, offsetBy: (tvLocation.text?.characters.count)! - 1))!))!
            }
            else if text.characters.count == 0 && tvLocation.text?.characters.count == 1 {
                serachText = ""
            }
            else if text.characters.count == 0 && (tvLocation.text?.characters.count)! > 1
            {
                serachText = ""
            }
            else
            {
                serachText = (tvLocation.text?.appending(text))!
            }
            if serachText.length == 0
            {
                arrOfLocation = NSMutableArray()
                tblLocation.reloadData()
                self.tblLocation.isHidden = true
            }
            else
            {
                getLocation(str: serachText)
            }
            
            //print(serachText.length)
        }
        return true
    }
    //MARK:- API CALL
    func saveLocation()
    {
       
        let parameter: NSMutableDictionary = NSMutableDictionary()
        parameter.setValue(API.getToken(), forKey: "Token")
        parameter.setValue(API.getDeviceToken(), forKey: "DeviceID")
        parameter.setValue(API.getUserId(), forKey: "PosterID")
        parameter.setValue(API.getRoleName(), forKey: "RoleName")
        parameter.setValue(strLat, forKey: "Latitude")
        parameter.setValue(strLong, forKey: "Longitude")
        parameter.setValue(tvLocation.text, forKey: "LocationName")
        parameter.setValue(txtLocationName.text, forKey: "BaseName")
        parameter.setValue(dictFromSetting.object(forKey: "ID"), forKey: "LocationID")
        
        print(parameter)
        API.callApiPOST(strUrl: API_CreatePosterLocation,parameter: parameter, success: { (response) in
            
            self.custObj.hideSVHud()
            print(response)
            if response.object(forKey: "ReturnCode") as! String == "1"
            {
                self.objSetting.getUSerSetting()
                _ = self.navigationController?.popViewController(animated: true)
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
                                self.tblLocation.isHidden = false
                            }
                            else
                            {
                                self.tblLocation.isHidden = true
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
                                    self.txtLocationName.text = ""
                                    self.tvLocation.text = ""
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
                self.txtLocationName.text = ""
                self.tvLocation.text = ""
                self.strLat = ""
                self.strLong = ""
                self.custObj.alertMessage(SEVERING_MESSAGE)
            }
            
            
        }
    }
    
    func zoomPin()
    {
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
                            self.tvLocation.text = (arrResult.object(at: 0) as AnyObject).object(forKey:"formatted_address") as! String
                            //self.actiView.isHidden = true
                        }
        },failure: { (op, fault) -> Void in
            print(op?.error ?? 0)
        })
        
    }
}
