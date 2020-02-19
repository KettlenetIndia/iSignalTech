//
//  ISEnterVenueViewController.swift
//  iSignal Tech
//
//  Created by Apple on 20/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Lightbox
import MBProgressHUD
import ObjectMapper
import UserNotifications
import SDWebImage
import KontaktSDK

class ISEnterVenueViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ISDelegate/*,CBPeripheralManagerDelegate,CLLocationManagerDelegate,CBCentralManagerDelegate*/{
    
    // Object outlet
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnScanning: UIButton!
    @IBOutlet weak var btnBluetooth: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var tblBeaconList: UITableView!
    @IBOutlet weak var imgTrue: UIImageView!
    
    // Variable Declaration
//    var bluetoothPeripheralManager: CBPeripheralManager!

    var  offerBeaconList = [ISBeacon](){
        didSet{
            tblBeaconList.reloadData()
        }
    }
    
    
    
    var offerPresentList = [ISBeacon?]()
    var isCurrentlyOfferShowing = false
    var currentOfferIndex = 0
    var isRanginStarted = false
    
    //MARK: -- ViewController life cycle **
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitialSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if !CLLocationManager.locationServicesEnabled() {
//            self.btnActionLocation(self.btnLocation)
//        }
//    }
    
    private func InitialSetup(){
        beaconDelegate = self
//        iBeaconManager.shared.vBeaconDelegate = self
//
//        if !iBeaconManager.shared.isCurrentlyRaging(){
//            iBeaconManager.shared.startRanging()
//        }

//        let options = [CBCentralManagerOptionShowPowerAlertKey:0]
//        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: DispatchQueue.main)
//            CBPeripheralManager(delegate: self, queue: nil, options: options)
        self.setPermissionImage()

 
        
    }
    
    func locationAuthorizationChanged() {
        self.setPermissionImage()
    }
    
    func didUpdateBeaconList(beacons: [CLBeacon]) {
        self.filterBeacon(beaconList: beacons)
    }
    
    func didUpdateKontaktBeaconList(config : KTKDeviceConfiguration,distance:Float)
    {
       //    self.filterBeacon(beaconList: beacons)
        
        if offerBeaconList.count == 0
           {
            offerBeaconList = [ISBeacon]()
           }
           for offerBeacon in beaconsData
           {
            if   config.major == offerBeacon.major?.toNSNumber() && config.minor == offerBeacon.minor?.toNSNumber()
                              {
                                 offerBeacon.distance = distance
                                  if offerBeacon.enterExist?.lowercased() != "true"
                                  {
                               
                                    
                                    if checkbeaconpresent(offerBeacon: offerBeacon) == false
                                                                                 {
                                                    offerBeaconList.append(offerBeacon)
                                                                                 }
                                  }
                                  if !self.containBeacon(beacon: offerBeacon)
                                  {
                                      offerBeacon.isPresented = false
                                     if checkbeaconpresentlist(offerBeacon: offerBeacon) == false
                                                             {
                                                            offerPresentList.append(offerBeacon)
                                                             }
                                  }
                              }
           }
           
           /* if offers are currently presenting then wait for new untill old are completed
            if any new offer are added then it will shown in it
            */
           if !isCurrentlyOfferShowing{
               isCurrentlyOfferShowing = true
               self.showOffer()
           }
        
    }
    
    private func filterBeacon(beaconList : [CLBeacon]){
        
        if offerBeaconList.count == 0
        {
                offerBeaconList = [ISBeacon]()
        }
        for offerBeacon in beaconsData
        {
            for beacon in beaconList
            {
                if  offerBeacon.uuid?.lowercased() == beaconUUID.uuidString.lowercased() && beacon.major == offerBeacon.major?.toNSNumber() && beacon.minor == offerBeacon.minor?.toNSNumber()
                {
                    offerBeacon.beacon = beacon
                    if offerBeacon.enterExist?.lowercased() != "true"
                    {
                        
                        
                        if checkbeaconpresent(offerBeacon: offerBeacon) == false
                                              {
                                                   offerBeaconList.append(offerBeacon)
                                              }
                        
                    }
                    if !self.containBeacon(beacon: offerBeacon)
                    {
                        offerBeacon.isPresented = false
                        if checkbeaconpresentlist(offerBeacon: offerBeacon) == false
                        {
                              offerPresentList.append(offerBeacon)
                        }
                      
                    }
                }
            }
        }
        
        /* if offers are currently presenting then wait for new untill old are completed
         if any new offer are added then it will shown in it
         */
        if !isCurrentlyOfferShowing{
            isCurrentlyOfferShowing = true
            self.showOffer()
        }
    }
    
     
    func checkbeaconpresent(offerBeacon : ISBeacon) -> Bool
    {
      let filter =   offerBeaconList.filter { (beacon) -> Bool in
            
            return offerBeacon.major?.toNSNumber() == beacon.major?.toNSNumber()
        }
        
        return filter.count>0 ? true:false;
    }
    
    func checkbeaconpresentlist(offerBeacon : ISBeacon) -> Bool
       {
         let filter =   offerPresentList.filter { (beacon) -> Bool in
               
            return offerBeacon.major?.toNSNumber() == beacon!.major?.toNSNumber()
           }
        
           return filter.count>0 ? true:false;
       }
    
    // Checking in list beacon are already in list or not
    private func containBeacon(beacon : ISBeacon) -> Bool
    {
        return offerPresentList.contains(where: {$0!.deviceId == beacon.deviceId})
    }
    
    
    /* showing offer one by one
     * and manage index for showing if onw time all are completed then it will start again.
     * if it  displayed one time then it will not shown again
     */
    private func showOffer(){
        if currentOfferIndex < offerPresentList.count{
            if let offer = offerPresentList[currentOfferIndex]{
                if !offer.isPresented{
                    offer.isPresented = true
                    self.setupOfferView(beacon: offer, isNeedToAddAnalystic: true)
                    print("Offer Shown id is: \(offer.deviceId ?? "") and name : \(offer.deviceName ?? "")")
                    
                }else{
                    self.showNextOffer()
                }
            }
        }else{
            currentOfferIndex = 0
            isCurrentlyOfferShowing = false
        }
    }
    
    @objc func showNextOffer(){
        currentOfferIndex = currentOfferIndex + 1
        self.showOffer()
    }
    
    //On click enter venue show particuler view controller
    func setupOfferView(beacon : ISBeacon , isAutoPopup : Bool = true, isNeedToAddAnalystic : Bool){
        
        if (beacon.campaigns?.count)! > 0{
            for campaign in (beacon.campaigns!){
                
                if isNeedToAddAnalystic{
                    ISNetworkManager.shred.addAnalysticReport(beaconId: beacon.deviceId!, campaignId: campaign.campaignId)
                }
                
                switch campaign.mediaType.lowercased() {
                    
                case "survey" :
                    if isAutoPopup && beacon.enterExist?.lowercased() == "true"{
                        if (userDefaults.object(forKey: "isWelComePresented") != nil){
                            self.showSurvayDetailPage(title: campaign.campaignName!, url: campaign.Survey_url!, webPageContent: "",isSurvey: true)
                            
                        }else{
                            let urlString = campaign.Welcome_image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                            let lightBox = LightboxImage(imageURL: URL(string: urlString!)!,
                                                         text: campaign.campaignName)
                            showLightBox(images: [lightBox])
                            
                            userDefaults.set(Date(), forKey: "isWelComePresented")
                            userDefaults.synchronize()
                            
                            Timer.scheduledTimer(withTimeInterval: 60, repeats: false, block: { (timer) in
                                self.showSurvayDetailPage(title: campaign.campaignName!, url: campaign.Survey_url!, webPageContent: "",isSurvey: true)
                            })
                        }
                        
                    }else{
                        self.showSurvayDetailPage(title: campaign.campaignName!, url: campaign.Survey_url!, webPageContent: "",isSurvey: true)
                    }
                    break
                case "url":
                    
                    self.showSurvayDetailPage(title: campaign.campaignName!, url: campaign.url!, webPageContent: "")
                    
                    break
                    
                case "videourl":
                    self.showSurvayDetailPage(title: campaign.campaignName!, url: "", webPageContent: campaign.embed)
                    
                    break
                case "image":
                    
                    let urlString = campaign.image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    let lightBox = LightboxImage(imageURL: URL(string: urlString!)!,
                                                     text: campaign.campaignName + "\r" + campaign.runningDate)
                        showLightBox(images: [lightBox])
                    
                    
                    break
                    
                case "videofile":
                    
                    let urlString = campaign.video?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    let lightBox = LightboxImage(image: UIImage(named: "logo_full")!,
                                                 text: campaign.campaignName + "\r" + campaign.runningDate,
                                                 videoURL: URL(string: urlString!))
                    
                    showLightBox(images: [lightBox])
                    break
                    
                case "notefile":
                    let alert = UIAlertController(title: campaign.title, message: campaign.notification, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                        self.showNextOffer()
                    }))
                    self.presentVC(alert)
                    break
                    
                default:
                    break
                }
            }
        }else{
            if isAutoPopup == false{
                showAlert(title: "There is no offer in this beacon", message: "", buttonText: "Dismiss")
            }
            
        }
    }
    
    
    private func showSurvayDetailPage(title :String, url :String,webPageContent: String,isSurvey : Bool = false){
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ISPinDetailViewController") as? ISPinDetailViewController
        detailViewController?.strTitle = title
        detailViewController?.webpageUrl = url
        detailViewController?.webPageContent = webPageContent
        detailViewController?.isSurvey = isSurvey
        detailViewController?.dismiss = { () in
            self.showNextOffer()
        }
        self.pushVC(detailViewController!)
    }
    
    
    //MARK: CBPeripheralManager Delegate
    func didUpdateBluetoothState(peripheral: CBManagerState) {
        if peripheral == .poweredOn{
            Services.isBluetoothEnable = true
        }else if peripheral == .poweredOff{
            Services.isBluetoothEnable = false
        }else{
            Services.isBluetoothEnable = false
        }
        self.setPermissionImage()
    }
    

    
    
    // Change image as per Bluetooth and location enable disable
    private func setPermissionImage(){
        btnLocation.setImage(Services.isLocationEnable ? #imageLiteral(resourceName: "ic_location_on") : #imageLiteral(resourceName: "ic_location_off"), for: .normal)
        btnBluetooth.setImage(Services.isBluetoothEnable ? #imageLiteral(resourceName: "ic_bluetooth_on") : #imageLiteral(resourceName: "ic_bluetooth_off"), for: .normal)
    }
    
    // For testing purpose this method is used
    @IBAction func btnActionFireNotification(_ sender: UIButton){
        
        
        
        
        /* if userDefaults.object(forKey: getBeacons) != nil{
         let strBeacon = userDefaults.object(forKey: getBeacons) as! String
         
         let beaconList = Mapper<ISBeacon>().mapArray(JSONString: strBeacon)
         let offer = beaconList![0]
         
         let content = UNMutableNotificationContent()
         content.title = "iSignal notification"
         content.body = offer.deviceName!
         content.sound = UNNotificationSound.default()
         content.userInfo = ["notificationContent" : offer.toJSONString() ?? ""]
         
         
         SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: offer.pushnotificationImage!), options: [], progress: nil, completed: { (image, imageDta, error, isSuccess) in
         if error == nil{
         do{
         
         if let url = AppDelegate.shared.storeImage(imageName: "Test Notification", image: image!){
         let attechMent = try UNNotificationAttachment(identifier: "Image", url: url, options: nil)
         
         content.attachments = [attechMent]
         }
         }catch _{}
         }
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
         let request = UNNotificationRequest(identifier: "Enter region", content: content, trigger: trigger)
         AppDelegate.shared.center.add(request) { (error) in
         if let error = error {
         print(error.localizedDescription)
         }
         }
         })
         }*/
    }
    
    
    //Location buttion action for enable/disable Location
    @IBAction func btnActionLocation(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
            let alert = UIAlertController(title: "Please allow location permission to app. please go to setting", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                } else {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            var alertTitle = "Location OFF"
            var alertMessage = "Your location services appears to be offline. Please enable it from setting to get nearby offers even more accurate."
            if Services.isLocationEnable{
                alertTitle = "Location ON"
                alertMessage = "You may not get nearby offers even more accurate. Do you want to OFF Location ?"
            }
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                } else {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Bluetooth buttion action for enable/disable Bluetooth
    @IBAction func btnActionBluetooth(_ sender: UIButton) {
        
        let bluetoothController = self.storyboard?.instantiateViewController(withIdentifier: "BluetoothSettingViewController") as! BluetoothSettingViewController
        self.present(bluetoothController, animated: true, completion: nil)
        
        
//        var alertTitle = "Turn Bluetooth ON"
//        var alertMessage = "To turn on bluetooth. Please go to the settings and enable it."
//
//        if Services.isBluetoothEnable{
//            alertTitle = "Turn Bluetooth OFF"
//            alertMessage = "To turn off bluetooth. Please go to the settings and disable it."
//        }
//
//        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        
        
//        var alertTitle = "Turn Bluetooth ON"
//        var alertMessage = "To turn on bluetooth. Please go to the control center and enable it."
//        if Services.isBluetoothEnable{
//            alertTitle = "Turn Bluetooth OFF"
//            alertMessage = "To turn off bluetooth. Please go to the control center and disable it."
//        }
        
//        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL(string:"App-Prefs:root=Bluetooth")!)
//            } else {
//                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
    }
    
    //Bottom menu actions. navigating to map screen
    @IBAction func btnActionFindVenues(_ sender: Any) {
        let findVenuesViewController = self.storyboard?.instantiateViewController(withIdentifier: "RootViewController")
        self.navigationController?.pushViewController(findVenuesViewController!, animated: true)
    }
    
    // Navigation to setting screen
    @IBAction func btnActionSettings(_ sender: Any) {
        let settingViewController = self.storyboard?.instantiateViewController(withIdentifier: "ISSettingViewController")
        self.navigationController?.pushViewController(settingViewController!, animated: true)
    }
    
    // Navigation to feedback screen
    @IBAction func btnActionFeedback(_ sender: Any) {
        let feedbackViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController")
        self.navigationController?.pushViewController(feedbackViewController!, animated: true)
    }
    
   //MARK: UITableView Delegate and Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if offerBeaconList.count > 0 {
            lblMessage.text = "Congratulations ! \n You are in iSignal installed venue."
            lblMessage.textColor = UIColor(hex: "28B9E6")
            btnScanning.setBackgroundImage(#imageLiteral(resourceName: "ic_led_on"), for: .normal)
            imgTrue.isHidden = false
            return offerBeaconList.count
        }else{
            lblMessage.text = "You are not under any iSignal device range.Click on Find venues button and visit the venue!"
            lblMessage.textColor = UIColor.lightGray
            btnScanning.setBackgroundImage(#imageLiteral(resourceName: "ic_led_off"), for: .normal)
            imgTrue.isHidden = true
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let beaconCell = tableView.dequeueReusableCell(withIdentifier: "ISBeaconVenueCell", for: indexPath) as! ISBeaconVenueCell
        let beacon = offerBeaconList[indexPath.row]
        if beacon.beacon != nil
        {
           beaconCell.lblDistance.text = offerBeaconList[indexPath.row].locationString()
        }
        else
        {
            beaconCell.lblDistance.text = String(format: "%.2f", beacon.distance!)
        }
        beaconCell.lblBeaconName.text = offerBeaconList[indexPath.row].deviceName
        beaconCell.btnEnterVenue.addTapGesture { (tap) in
            self.setupOfferView(beacon: self.offerBeaconList[indexPath.row],isAutoPopup: false, isNeedToAddAnalystic: false)
        }
        beaconCell.selectionStyle = .none
        return beaconCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    private func showLightBox(images:[LightboxImage]){
        
        let lightBoxController = LightboxController(images: images)
        
        lightBoxController.pageDelegate = self
        lightBoxController.dismissalDelegate = self
        lightBoxController.dynamicBackground = true
        lightBoxController.modalPresentationStyle = .fullScreen
        present(lightBoxController, animated: true, completion: nil)
    }
    
    
}

extension ISEnterVenueViewController: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        controller.dismissVC(completion: nil)
        //print(page)
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        controller.dismissVC(completion: nil)
        self.perform(#selector(showNextOffer), with: self, afterDelay: 4.0)
    }
}

//MARK: - Beacon Cell -
class ISBeaconVenueCell : UITableViewCell{
    
    @IBOutlet weak var btnEnterVenue: ZWButton!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblBeaconName: UILabel!
    
}


//            for offer in offerPresentList{
//                if offer.isWelComePresentedForToday == false{
//                    if !offer.isPresented{
//                        offer.isPresented = true
//                        if offer.enterExist?.lowercased() == "true"{
//                            offer.isWelComePresentedForToday = true
//                            self.addBeaconToPresented(beacon: offer)
//                        }
//                        self.setupOfferView(beacon: offer, isNeedToAddAnalystic: true)
//                    }
//                }
//            }
