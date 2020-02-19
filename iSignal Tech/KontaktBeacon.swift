//
//  KontaktBeacon.swift
//  iSignal Tech
//
//  Created by Varun on 15/08/19.
//  Copyright © 2019 Salman Maredia. All rights reserved.
//

import UIKit
import KontaktSDK

enum CustomError: Error {
    case throwvalue
    case rethrowvalue
}

class KontaktBeacon: NSObject {

    var beaconManager : KTKBeaconManager!
    var devicesManager : KTKDevicesManager!
    var beaconarray = [[String:Any]]()
    static let shared = KontaktBeacon()
    var closureName: ((String) -> (Void)) = { (testing) in
        print(testing)
    }
    var discoverbecon : ((KTKDeviceConfiguration,Float)->(Void)) = {(configuration,distance) in
        
    }
    
    private override init()
    {
        
    }
    
    func authroziedbeacon() -> Void
    {
        
        
    beaconManager = KTKBeaconManager(delegate: self)
    devicesManager = KTKDevicesManager(delegate: self)
        
        devicesManager.startDevicesDiscovery()
        

        
    switch KTKBeaconManager.locationAuthorizationStatus()
    {
    case .notDetermined:
        do
        {
            self.beaconManager.requestLocationAlwaysAuthorization()
        }

    case .denied, .restricted:
   do
   {
        break
    }
    // No access to Location Services
    case .authorizedWhenInUse:
    do {
           break
    }
    case .authorizedAlways:
  do {
    
  
    
        break
    }
    
    }
    }
    
 
}

extension KontaktBeacon: KTKBeaconManagerDelegate,KTKDevicesManagerDelegate
{
    func devicesManager(_ manager: KTKDevicesManager, didDiscover devices: [KTKNearbyDevice])
    {
//        if let device = devices.filter({$0.uniqueID == "BtYwy6"}).first
//        {
            
            for device in devices
            {
                
            //    print("device rssi",device.rssi.intValue)
                
                let connection = KTKDeviceConnection(nearbyDevice: device)
                        connection.readConfiguration() { configuration, error in
                            if error == nil, let config = configuration
                            {
                                
                                
                                let filterarray =  self.beaconarray.filter({ (dict) -> Bool in
                                
                                    let major = dict["major"] as! NSNumber
                                
                                return major.intValue == config.major?.intValue
                                
                                })
                                
//                          print("device rssi0",configuration?.rssiAt0Meter)
//                          print("device rssi1",configuration?.rssiAt1Meter)
//                          print("device rssitx",configuration?.referenceTXPowerIBeacon?.intValue)
//                          print("device rssieddy",configuration?.referenceTXPowerEddystone?.intValue)
                              
                            if filterarray.count==0
                            {
                              self.beaconarray.append(["major":config.major as Any,"minor":config.minor as Any])
                                
                                let myProximityUuid = UUID(uuidString: config.proximityUUID!.uuidString)
                                let region = KTKBeaconRegion(proximityUUID: myProximityUuid!, identifier:config.uniqueID!)
                                
                                if KTKBeaconManager.isMonitoringAvailable()
                                {
                                    self.beaconManager.startMonitoring(for: region)
                                }
                                
                                
                            }
                                
                             // Distance = 10 ^ ((Measured Power – RSSI)/(10 * N))
                                let power = ((config.rssiAt1Meter?.first!.floatValue)!-device.rssi.floatValue)/(10*2)
                                let distance = pow(10, power)
                                
                                self.discoverbecon(config,distance)
                                  
                                
                                
                                
                                
                           }
                        }
                
            }
            
        
        
        
    }
    
    
    func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion) {
        // Do something when monitoring for a particular
        // region is successfully initiated
        
//        if region != nil
//        {
//               print("start region",region)
//        }
     
        
    }
    
    func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
        // Handle monitoring failing to start for your region
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion) {
        // Decide what to do when a user enters a range of your region; usually used
        // for triggering a local notification and/or starting a beacon ranging
        
       //  print("enter region",region)
        
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        // Decide what to do when a user exits a range of your region; usually used
        // for triggering a local notification and stoping a beacon ranging
        
        
      //  print("exit region",region)
        
    }
}
