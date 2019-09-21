//
//  AppDelegate.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 26/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import CoreLocation
import GoogleSignIn
import Firebase
import UserNotifications
import ObjectMapper
import IQKeyboardManagerSwift
import SDWebImage
import Fabric
import Crashlytics
import KontaktSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate,CLLocationManagerDelegate,CBCentralManagerDelegate{
    
    var window: UIWindow?
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    let center = UNUserNotificationCenter.current()
    
    var centralManager : CBCentralManager!
    var locationManager : CLLocationManager!
    var region : CLBeaconRegion!
    
//    var bluetoothPeripheralManager: CBPeripheralManager?

    
    var isPreparingForNotification = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])


        //Setup FCM for Push Notifications
        setupFCM(application: application)
        
        Kontakt.setAPIKey("MpyWprhmYWTHbCagDUtFndkAyOGqEwXj")
        
        KontaktBeacon.shared.authroziedbeacon()
        
        
        KontaktBeacon.shared.discoverbecon = { (config,distance) in
          //print(config)
            if (beaconDelegate != nil)
            {
                beaconDelegate?.didUpdateKontaktBeaconList!(config: config,distance: distance)
            }
            self.kontakt(config: config)
        }
 
        
        //Setup Local Notifications
        setupLocalNotifications()
        
        if userDefaults.bool(forKey: getLoggedInKey){
            
            let userStr:String = userDefaults.value(forKey: getUserObjectKey) as! String
            user = Mapper<UserDetail>().map(JSONString: userStr)
            
            moveToDashboard()
        }
        
        IQKeyboardManager.shared.enable = true
        self.checkUpdate()
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) { }
    
    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
        
        userDefaults.removeObject(forKey: "removeFiredIds")
//        centralManager.cancelPeripheralConnection(<#T##peripheral: CBPeripheral##CBPeripheral#>)
        
//        iBeaconManager.shared.stopRanging()
        
//        beaconManager.startMonitoring(for: appRegion)
//        beaconManager.startRangingBeacons(in: appRegion)
    }
    
    
    func moveToDashboard(){
        
        Thread.sleep(forTimeInterval: 3.0)
        
        // Checking location permission
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            Services.isLocationEnable = true
        }
        
        // Set Home screen as root
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ISEnterNavigationController")
        if let window =  UIApplication.shared.delegate!.window{
            window!.rootViewController = viewController
        }
        
        
        // Remove Expire offer from list
        self.removeExpireOffers()
    
        /*
         *  Initialize beacon for background and when app is killed
         *  It detect beacon and fire notification. on click show the offer
         */
        
        self.initBeacon()
        
        // To get beacon list after every 30 secounds
        self.startFetchingBeacon()
        
        //Getting beacon list aync. in background
        self.getActiveBeacons()
        
        
        userDefaults.removeObject(forKey: "removeFiredIds")
    }
    
    private func initBeacon(){
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                
            case .notDetermined, .restricted, .denied:
                
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                Services.isLocationEnable = true
            }
        }
        
        let options = [CBCentralManagerOptionShowPowerAlertKey:true]
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
        
//        let options = [CBCentralManagerOptionShowPowerAlertKey:0]
//        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
        
        region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimote")
        region.notifyEntryStateOnDisplay = true
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: self.region)
        
    }
    
    //MARK: CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            Services.isLocationEnable = true
        }else{
            Services.isLocationEnable = false
        }
        if beaconDelegate != nil{
            beaconDelegate?.locationAuthorizationChanged!()
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        NSLog("didUpdateLocations \(locations.count)")
    }
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("willRestoreState")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didConnect peripheral")
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        centralManager = central;
        self.checkState()
    }

//
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        if peripheral.state == .poweredOn{
//            print("Bluetooth is On")
//        }else if peripheral.state == .poweredOff{
//            print("Bluetooth is Off")
//        }else if peripheral.state == .resetting{
//            print("Bluetooth is Resetting")
//        }else if peripheral.state == .unauthorized{
//            print("Bluetooth is  UnAuthorized")
//        }else if peripheral.state == .unsupported{
//            print("Bluetooth is unsupported")
//        }else if peripheral.state == .unknown{
//            print("Bluetooth is unknown")
//        }
//        if beaconDelegate != nil{
//            beaconDelegate?.didUpdateBluetoothState!(peripheral: peripheral.state)
//        }
//    }
    
    func checkState(){
        if centralManager.state == .poweredOn{
            print("Bluetooth is On")
        }else if centralManager.state == .poweredOff{
            print("Bluetooth is Off")
        }else if centralManager.state == .resetting{
            print("Bluetooth is Resetting")
        }else if centralManager.state == .unauthorized{
            print("Bluetooth is  UnAuthorized")
        }else if centralManager.state == .unsupported{
            print("Bluetooth is unsupported")
        }else if centralManager.state == .unknown{
            print("Bluetooth is unknown")
        }
        if beaconDelegate != nil{
            beaconDelegate?.didUpdateBluetoothState!(peripheral: centralManager.state)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        NSLog("monitoringDidFailFor : \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        NSLog("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
//        if state == .inside{
//            NSLog("Inside Region")
//        }else if state == .outside{
//            NSLog("Outside Region")
//        }else{
//            NSLog("Unknown")
//        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        NSLog("Enter in Region")
        
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        NSLog("Exit from region")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
     //  NSLog("App Delegate didRangeBeacons Count : \(beacons.count)")
        
        if beaconDelegate != nil{
            beaconDelegate?.didUpdateBeaconList!(beacons: beacons)
        }
        if UIApplication.shared.applicationState.hashValue == 2{
            if !isPreparingForNotification{
                isPreparingForNotification = true
                self.beaconInRange(beacons: beacons)
            }
        }
    }
    
    private func kontakt(config : KTKDeviceConfiguration)
    {
        
        if userDefaults.object(forKey: getBeacons) != nil{
            

            //2. getting beacon list from userdefault
            let strBeacon = userDefaults.object(forKey: getBeacons) as! String
            //3. converting beacon list string to particuler model
            let beaconList = Mapper<ISBeacon>().mapArray(JSONString: strBeacon)
            
            // Checking the detected beacon major and minir and setup local notification
           
                
                
                
                for offer in beaconList!{
                    
                    if offer.major?.toNSNumber() == config.major && offer.minor?.toNSNumber() == config.minor
                    {
                            //1. Created UNMutableNotificationContent Object and configure it
                            let content = UNMutableNotificationContent()
                            content.title = "iSignal notification"
                            content.body = "You have entered into \(offer.deviceName!) iSignal beacon."
                            content.sound = UNNotificationSound.default
                            content.userInfo = ["notificationContent" : offer.toJSONString() ?? ""]
                            
                            //2. Download notification image and set it.
                            let urlString = offer.pushnotificationImage?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                            print(urlString)
                            SDWebImageManager.shared.loadImage(
                                with: URL(string: urlString),
                                options: .highPriority,
                                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                                    print(isFinished)
                                    if error == nil{
                                        do{
                                            //3. Adding image attechment to notification
                                            if let url = self.storeImage(imageName: "Test Notification", image: image!){
                                                let attechMent = try UNNotificationAttachment(identifier: "Image", url: url, options: nil)
                                                
                                                content.attachments = [attechMent]
                                            }
                                        }catch _{}
                                    }
                              
                                    userDefaults.synchronize()
                                    //4. setting up trigger time
                                    //let trigger = UNLocationNotificationTrigger(region:appRegion, repeats:false)
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
                                    //5. adding notification
                                    let request = UNNotificationRequest(identifier: offer.deviceName!, content: content, trigger: trigger)
                                    self.center.add(request) { (error) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        }
                                    }
                            }
                           
                        }
                    }
                }
                
//                if config.major == beacons.last?.major && config.minor == beacons.last?.minor{
//                    isPreparingForNotification = false
//                }
            }
        
        
    
    
    private func beaconInRange(beacons: [CLBeacon]) {
        
//         When the beacon is detected at that time this delegate method called

//        1. check the beacon list is available or nont

        if userDefaults.object(forKey: getBeacons) != nil{

            
            //2. getting beacon list from userdefault
            let strBeacon = userDefaults.object(forKey: getBeacons) as! String
            //3. converting beacon list string to particuler model
            let beaconList = Mapper<ISBeacon>().mapArray(JSONString: strBeacon)

            // Checking the detected beacon major and minir and setup local notification
            for cOffer in beacons
            {
                
                var firedIds = [String]()
                if (userDefaults.object(forKey: "removeFiredIds") != nil){
                    firedIds = userDefaults.object(forKey: "removeFiredIds") as! [String]
                }
                
                for offer in beaconList!{
                    
                    if offer.major?.toNSNumber() == cOffer.major && offer.minor?.toNSNumber() == cOffer.minor
                    {
                        
                        if !firedIds.contains(offer.deviceId!){
                            //1. Created UNMutableNotificationContent Object and configure it
                            let content = UNMutableNotificationContent()
                            content.title = "iSignal notification"
                            content.body = "You have entered into \(offer.deviceName!) iSignal beacon."
                             content.sound = UNNotificationSound.default
                            content.userInfo = ["notificationContent" : offer.toJSONString() ?? ""]
                            
                            //2. Download notification image and set it.
                            let urlString = offer.pushnotificationImage?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                            print(urlString)
                            SDWebImageManager.shared.loadImage(
                                with: URL(string: urlString),
                                options: .highPriority,
                                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                                    print(isFinished)
                                    if error == nil{
                                        do{
                                            //3. Adding image attechment to notification
                                            if let url = self.storeImage(imageName: "Test Notification", image: image!){
                                                let attechMent = try UNNotificationAttachment(identifier: "Image", url: url, options: nil)
                                                
                                                content.attachments = [attechMent]
                                            }
                                        }catch _{}
                                    }
                                    firedIds.append(offer.deviceId!)
                                    userDefaults.set(firedIds, forKey: "removeFiredIds")
                                    userDefaults.synchronize()
                                    //4. setting up trigger time
                                    //let trigger = UNLocationNotificationTrigger(region:appRegion, repeats:false)
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
                                    //5. adding notification
                                    let request = UNNotificationRequest(identifier: offer.deviceName!, content: content, trigger: trigger)
                                    self.center.add(request) { (error) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                        }
                                    }
                            }
//                            SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: urlString), options: [], progress: nil, completed: { (image, imageDta, error, isSuccess) in
//                                if error == nil{
//                                    do{
//                                        //3. Adding image attechment to notification
//                                        if let url = self.storeImage(imageName: "Test Notification", image: image!){
//                                            let attechMent = try UNNotificationAttachment(identifier: "Image", url: url, options: nil)
//
//                                            content.attachments = [attechMent]
//                                        }
//                                    }catch _{}
//                                }
//
//                                firedIds.append(offer.deviceId!)
//                                userDefaults.set(firedIds, forKey: "removeFiredIds")
//                                userDefaults.synchronize()
//                                //4. setting up trigger time
//                                //                            let trigger = UNLocationNotificationTrigger(region:appRegion, repeats:false)
//                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
//                                //5. adding notification
//                                let request = UNNotificationRequest(identifier: offer.deviceName!, content: content, trigger: trigger)
//                                self.center.add(request) { (error) in
//                                    if let error = error {
//                                        print(error.localizedDescription)
//                                    }
//                                }
//                            })
                        }
                    }
                }
                
                if cOffer.major == beacons.last?.major && cOffer.minor == beacons.last?.minor{
                    isPreparingForNotification = false
                }
            }
        }
    }
    
    //Saving notification image to document directory.
    func storeImage(imageName: String, image : UIImage) -> URL?{
        var documentsDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsDirectoryPath.appendPathComponent("\(imageName).png")
        
        do{
            try image.pngData()?.write(to:documentsDirectoryPath)
          //  try UIImagePNGRepresentation(image)?.write(to:documentsDirectoryPath)
            return documentsDirectoryPath
        }catch{
            return nil
        }
    }
    
    // Function for getting beacon list
    private func getActiveBeacons(){
        ISNetworkManager.shred.getActiveBeaconsAndOffers(completion: { (success) in})
    }
    
    
    // MARK: - Local Notifications Dialog
    func setupLocalNotifications(){
        
        //Register for local notification (Reminders)
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
    }
    
    
    // MARK: - Push Notifications
    func setupFCM(application:UIApplication){
        
        FIRApp.configure()
        
        //Register for remote Notification
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            // For iOS 10 data message (sent via FCM)
            //FIRMessaging.messaging().remoteMessageDelegate = self
            
        }else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(tokenRefreshNotification), name:
            NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            
            userDefaults.set(refreshedToken, forKey: getDeviceToken)
            userDefaults.synchronize()
            print("TOKEN :: \(refreshedToken)")
        }
        else{
            print("TOKEN:: NILL")
        }
    }
    
    
    private func removeExpireOffers(){
        if (userDefaults.object(forKey: "isWelComePresented") != nil){
            let date = userDefaults.object(forKey: "isWelComePresented") as! Date
            
            if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff > 24 {
                userDefaults.removeObject(forKey: "isWelComePresented")
                userDefaults.synchronize()
            }
            
        }
    }
    
    
    // When firebase token refresh this observer method is callsed
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            
            userDefaults.set(refreshedToken, forKey: getDeviceToken)
            userDefaults.synchronize()
            print("TOKEN NOTIF: \(refreshedToken)")
        }
    }
    
    // Firebase Delegate method
    func messaging(_ messaging: FIRMessaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var readableToken: String = ""
        for i in 0..<deviceToken.count {
            readableToken += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            
            userDefaults.set(refreshedToken, forKey: getDeviceToken)
            userDefaults.synchronize()
            print("TOKEN:: \(refreshedToken)")
        }
        else{
            print("TOKEN:: NILL")
        }
        
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("didReceiveRemoteNotification")
        //print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        if let tag:String = userInfo["tag"] as! String?{
            
            if tag == "logout"{
                var title1:String = "Your account has been suspended"
                
                if let aps = userInfo["aps"] as? NSDictionary {
                    if let alert = aps["alert"] as? NSDictionary {
                        if let title = alert["title"] as? NSString {
                            
                            title1 = title as String
                        }
                    }
                }
                
                userDefaults.set(false, forKey: getLoggedInKey)
                userDefaults.synchronize()
                moveToLogin()
                showAlert(title: title1, message: "", buttonText: "OK")
            }
        }
    }
    
    // Receive displayed notifications for iOS 10 devices.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        NSLog("userNotificationCenter")
        //print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        if let tag : String = userInfo["tag"] as! String?{
            
            if tag == "logout"{
                
                var title1:String = "Your account has been suspended"
                
                if let aps = userInfo["aps"] as? NSDictionary {
                    if let alert = aps["alert"] as? NSDictionary {
                        if let title = alert["title"] as? NSString {
                            
                            title1 = title as String
                        }
                    }
                }
                
                userDefaults.set(false, forKey: getLoggedInKey)
                userDefaults.synchronize()
                moveToLogin()
                showAlert(title: title1, message: "", buttonText: "OK")
            }
        }
        
        //completionHandler([.sound,.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
            if let strNotification:String = userInfo["notificationContent"] as? String{
                let beacon = Mapper<ISBeacon>().map(JSONString: strNotification)
                if let rootController = UIApplication.shared.windows[0].rootViewController
                {
                    if  rootController.children.count > 0
                    {
                        if  rootController.children[0].isKind(of: ISEnterVenueViewController.classForCoder()){
                            let enterVenueViewController = rootController.children[0]  as! ISEnterVenueViewController
                            enterVenueViewController.setupOfferView(beacon: beacon!,isAutoPopup: false, isNeedToAddAnalystic:true)
                        }
                    }
                }
                
//                let controller = UIApplication.shared.windows[0].rootViewController?.childViewControllers[0] as! ISEnterVenueViewController
//                controller.setupOfferView(beacon: beacon!,isAutoPopup: false, isNeedToAddAnalystic: true)
            }
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage)
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "iSignal_Tech")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func startFetchingBeacon(){
        if ISNetworkManager.shred.offerUpdateTimer == nil{
            ISNetworkManager.shred.offerUpdateTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.scheduleOffersFetch), userInfo: nil, repeats: true)
        }
    }
    @objc private func scheduleOffersFetch(){
        ISNetworkManager.shred.getActiveBeaconsAndOffers(completion: { (success) in })
    }

    private func checkUpdate(){
        ISNetworkManager.shred.checkUpdate { (isSuccess, response) in
            if isSuccess{
                if response?.status == true{
                    let numberFormatter = NumberFormatter()
                    let versionNumber = numberFormatter.number(from: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)
                    print("version \(String(describing: versionNumber))")
                    if (response?.update.count)! > 0{
                        if response?.update[0].version != ""{
                            let versionNumbeinServer = numberFormatter.number(from: (response?.update[0].version)!)
                            if (versionNumbeinServer?.floatValue)! >  (versionNumber?.floatValue)!{
                                self.UpdateAPP()
                            }
                        }
                    }
                }
            }
        }
    }
    func UpdateAPP(){
        let alert = UIAlertController(title: "Update required!", message: "Please update newer version",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style:UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            exit(0)
        }))
        alert.addAction(UIAlertAction(title: "Update",
                                      style:UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        if #available(iOS 10.0, *) {
                                            UIApplication.shared.open(URL(string:"https://itunes.apple.com/us/app/isignal-tech/id1224269674?ls=1&mt=8")!)
                                        } else {
                                            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/isignal-tech/id1224269674?ls=1&mt=8")!)
                                        }
        }))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
//    private func checkUpdate(){
//        ISNetworkManager.shred.checkUpdate { (isSuccess, response) in
//            if isSuccess{
//                if response?.status == true{
//                    let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//                    if (response?.update.count)! > 0{
//                        if response?.update[0].version != ""{
//                            if (response?.update[0].version.toFloat())! > (versionNumber.toFloat())!{
//                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                let viewController = storyboard.instantiateViewController(withIdentifier: "ISUpdateViewController")
//                                if let window =  UIApplication.shared.delegate!.window{
//                                    window!.rootViewController?.presentVC(viewController)
//                                }
//                            }
//                        }
//                    }
//
//                }
//            }
//        }
//    }
    
}


//            let content = UNMutableNotificationContent()
//            content.title = "iSignal notification"
//            content.body = "\(UIApplication.shared.applicationState.hashValue ). Beacon detected"
//            content.sound = UNNotificationSound.default()
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
//            let request = UNNotificationRequest(identifier: "Beacon detected", content: content, trigger: trigger)
//            self.center.add(request) { (error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//            }

