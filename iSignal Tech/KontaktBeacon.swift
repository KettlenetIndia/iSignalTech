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
    var  devicesManager : KTKDevicesManager!
    static let shared = KontaktBeacon()
    var closureName: ((String) -> (Void)) = { (testing) in
        print(testing)
    }
    
  
    
    private override init()
    {
        
    }
    
    func authroziedbeacon() -> Void
    {
    beaconManager = KTKBeaconManager(delegate: self)
    devicesManager = KTKDevicesManager(delegate: self)
        
        let myProximityUuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
        let region = KTKBeaconRegion(proximityUUID: myProximityUuid!, identifier: "Beacon region 1")
        
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
    
    if KTKBeaconManager.isMonitoringAvailable() {
        beaconManager.startMonitoring(for: region)
    }
    
        break
    }
    
    }
    }
    
 
}

extension KontaktBeacon: KTKBeaconManagerDelegate,KTKDevicesManagerDelegate
{
    func devicesManager(_ manager: KTKDevicesManager, didDiscover devices: [KTKNearbyDevice]) {

        
        if let device = devices.filter({$0.uniqueID == "abcd"}).first {
            let connection = KTKDeviceConnection(nearbyDevice: device)
            connection.readConfiguration() { configuration, error in
                if error == nil, let config = configuration {
                    print("Advertising interval for beacon \(String(describing: config.uniqueID)) is \(config.advertisingInterval!)ms")
                }
            }
        }
        
    }
    
    
    func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion) {
        // Do something when monitoring for a particular
        // region is successfully initiated
    }
    
    func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
        // Handle monitoring failing to start for your region
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion) {
        // Decide what to do when a user enters a range of your region; usually used
        // for triggering a local notification and/or starting a beacon ranging
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        // Decide what to do when a user exits a range of your region; usually used
        // for triggering a local notification and stoping a beacon ranging
    }
}
