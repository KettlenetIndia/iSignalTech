//
//  iBeaconManager.swift
//  iSignal Tech
//
//  Created by Apple on 08/12/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit

class iBeaconManager: NSObject,CLLocationManagerDelegate,CBCentralManagerDelegate {
    
    static let shared = iBeaconManager()
    var isRanging = false
    
    var centralManager : CBCentralManager!
    var locationManager : CLLocationManager!
    var region : CLBeaconRegion!
    
    
    var vBeaconDelegate : ISDelegate?
    var aBeaconDelegate : ISDelegate?
    
    override init() {
        super.init()
        self.InitialBackgroudnBeacon()
    }
    
    
    private func InitialBackgroudnBeacon(){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                
            case .notDetermined, .restricted, .denied:
                
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                Services.isLocationEnable = true
            }
        }
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        
        region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimote")
        
    }
    
    func isCurrentlyRaging() -> Bool{
        return isRanging
    }
    
    func startRanging(){
        isRanging = true
        locationManager.startRangingBeacons(in: region)
    }
    
    func stopRanging(){
        isRanging = false
        locationManager.stopRangingBeacons(in: region)
        locationManager.stopUpdatingLocation()
    }
    
    
    //MARK: CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            Services.isLocationEnable = true
        }else{
            Services.isLocationEnable = false
        }
        if vBeaconDelegate != nil{
            vBeaconDelegate?.locationAuthorizationChanged!()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("didUpdateLocations \(locations.count)")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        centralManager = central;
        NSLog("centralManagerDidUpdateState")
    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        NSLog("monitoringDidFailFor : \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("Enter in Region")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("Exit from region")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if vBeaconDelegate != nil{
            vBeaconDelegate?.didUpdateBeaconList!(beacons: beacons)
        }
        if aBeaconDelegate != nil{
            if UIApplication.shared.applicationState == .inactive{
                aBeaconDelegate?.didUpdateBeaconList!(beacons: beacons)
            }
        }
    }
}
