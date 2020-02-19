//
//  ISFindVenueViewController.swift
//  iSignal Tech
//
//  Created by Apple on 20/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import MapKit
import LGSideMenuController
import MBProgressHUD
import EZSwiftExtensions
import CoreLocation

class ISFindVenueViewController: UIViewController,MKMapViewDelegate,ISDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var categoryItemList = [CategoryItem]()
    var locationManager : CLLocationManager?
    var currentLatLng : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func InitialSetup(){
        mapView.delegate = self
        delegate = self
        
        self.checkPermission()
    }
    
    private func checkPermission(){
        
        // Checking Location Permission
        
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
    }
    
    //MARK: CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            locationManager?.stopUpdatingLocation()
            currentLatLng = locations[0]
//            let region = MKCoordinateRegionMakeWithDistance(locations[0].coordinate, 350.0, 350.0)
//            mapView.setRegion(region, animated: true)
        }
    }
    
    //MARK: - ISDelegate -
    func didSelectMenuAt(index: Int) {
        print("Selected Index \(index)")
        
        self.removeAllMarker()
        self.categoryItemList = [CategoryItem]()
        self.getItemsWith(categoryId: categoryList[index].category_id!)
    }
    
    
    private func getItemsWith(categoryId : String){
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.detailsLabel.text = "Getting list"
        
        ISNetworkManager.shred.getSideMenuCategoryItemList(categoryId: categoryId) { (isSuccess, response) in
            if (response?.status)!{
                
                self.categoryItemList = (response?.categoryItemList)!
                self.addMarkerOnMap()
                progressHUD.hide(animated: true)
            }else{
                progressHUD.hide(animated: true)
                if let message = response?.error{
                    showAlert(title: "Failed", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Failed", message: "There was some error while getting data. Please try again.", buttonText: "OK")
                }
            }
        }
    }
    
    func removeAllMarker(){
        let userLocation = mapView.userLocation
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(userLocation)
    }
    
    private func addMarkerOnMap(){
     
        for pin in self.categoryItemList{
            if(pin.latitude != nil && pin.longitude != nil && pin.latitude != "" && pin.longitude != ""){               
                
                
                if let lati = pin.latitude?.toDouble()  {
                    if let longitude = pin.longitude?.toDouble(){
                        let centerCoordinate = CLLocationCoordinate2D(latitude: lati , longitude:longitude)
                        let annotation = CustomMapAnnotationPoint()
                        annotation.coordinate = centerCoordinate
                        annotation.annotationDetail = pin
                        mapView.addAnnotation(annotation)
                    }
                }
            }
        }
  
        var zoomRect = MKMapRect.null
        for annotation in mapView.annotations{
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        
        mapView.setVisibleMapRect(zoomRect, animated: true)

    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.title = ""
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.classForCoder()){
            var annotationView =  mapView.dequeueReusableAnnotationView(withIdentifier: "ISCustomMapAnnotation") as? ISCustomMapAnnotation
            if(annotationView == nil){
                annotationView = ISCustomMapAnnotation(annotation: annotation, reuseIdentifier: "ISCustomMapAnnotation")
            }
            annotationView?.canShowCallout = false
//            let annotationDetailView
//                = Bundle.main.loadNibNamed("PopUpView", owner: nil, options: nil)![0] as? PopUpView
//            annotationDetailView?.lblTitle.text = "You are here !"
//            annotationDetailView?.lblAddress.text = "Position : latt/lng : (\(currentLatLng?.coordinate.latitude.toString ?? ""),\(currentLatLng?.coordinate.longitude.toString ?? ""))"
            annotationView?.image = UIImage(named: "ic_map_pin_user")
//            annotationView?.detailCalloutAccessoryView = annotationDetailView
//            annotationView?.canShowCallout = true
            return annotationView
        }else{
            if annotation.isKind(of: CustomMapAnnotationPoint.classForCoder()){
                let cAnnotation = annotation as! CustomMapAnnotationPoint
                var annotationView =  mapView.dequeueReusableAnnotationView(withIdentifier: "ISCustomMapAnnotation") as? ISCustomMapAnnotation
                if(annotationView == nil){
                    annotationView = ISCustomMapAnnotation(annotation: annotation, reuseIdentifier: "ISCustomMapAnnotation")
                }
                annotationView?.isEnabled = true
                annotationView?.canShowCallout = false
                annotationView?.annotationDetail = cAnnotation.annotationDetail
                
//                let annotationDetailView
//                    = Bundle.main.loadNibNamed("PopUpView", owner: nil, options: nil)![0] as? PopUpView
//                annotationDetailView?.lblTitle.text = cAnnotation.annotationDetail?.companyName
//                annotationDetailView?.lblAddress.text = "\(cAnnotation.annotationDetail?.street ?? ""),\(cAnnotation.annotationDetail?.city ?? "")"
//                annotationDetailView?.btnClick.addTapGesture(action: { (tap) in
//                    self.openDetail(detail: cAnnotation.annotationDetail!)
//                })
//                annotationView?.detailCalloutAccessoryView = annotationDetailView
                return annotationView
            }else{
                return nil
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isKind(of: ISCustomMapAnnotation.classForCoder()){
            self.removeAllAnnotationView(view: view)
            
            let cAnnotation = view as! ISCustomMapAnnotation
            
            var companyName = cAnnotation.annotationDetail?.companyName
            var addressString = "\(cAnnotation.annotationDetail?.street ?? ""),\(cAnnotation.annotationDetail?.city ?? "")"
            if cAnnotation.annotationDetail == nil{
                companyName = "You are here !"
                
                let nf = NumberFormatter()
                nf.numberStyle = .decimal
                
                addressString = "Position : latt/lng : (\( nf.string(from: NSNumber(floatLiteral: (currentLatLng?.coordinate.latitude)!)) ?? ""),\(nf.string(from: NSNumber(floatLiteral: (currentLatLng?.coordinate.longitude)!)) ?? ""))"
            }
            let annotationDetailView = Bundle.main.loadNibNamed("PopUpView", owner: nil, options: nil)![0] as? PopUpView
            annotationDetailView?.lblTitle.text = companyName
            annotationDetailView?.lblAddress.text = addressString
            annotationDetailView?.btnClick.addTapGesture(action: { (tap) in
                if cAnnotation.annotationDetail != nil{
                    self.openDetail(detail: cAnnotation.annotationDetail!)
                }
            })
            
            let height  = addressString.height(withConstrainedWidth: 250, font: (annotationDetailView?.lblAddress.font)!)
            let frame = CGRect(x: 0, y: 0, width: 250, height: Int(70.0 + height))
            annotationDetailView?.frame = frame
            annotationDetailView?.center = CGPoint(x: view.bounds.size.width / 2, y: -((annotationDetailView?.bounds.size.height)!*0.52))
            
            view.addSubview(annotationDetailView!)
            mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        }
    }
    
    private func removeAllAnnotationView(view: MKAnnotationView){
        if view.isKind(of: ISCustomMapAnnotation.classForCoder()){
            for subview in view.subviews{
                subview.removeFromSuperview()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            self.removeAllAnnotationView(view: view)
    }
    
    
    private func openDetail(detail : CategoryItem){
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ISPinDetailViewController") as? ISPinDetailViewController
        if detail.punchcardUrl != ""{
            detailViewController?.strTitle = detail.companyName
            detailViewController?.webpageUrl = detail.punchcardUrl
        }else if detail.images != ""{
            detailViewController?.itemDetail = detail
        }
        self.pushVC(detailViewController!)
    }
    
    @IBAction func btnActionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

