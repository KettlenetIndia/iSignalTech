//
//  NearbyBeaconsViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 27/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import CoreLocation
import Lightbox
import AVKit
import ObjectMapper
import SDWebImage
import CoreBluetooth

class NearbyBeaconsViewController: UIViewController, CBCentralManagerDelegate {

    @IBOutlet weak var byMapBtn: UIButton!
    @IBOutlet weak var byListBtn: UIButton!
    @IBOutlet weak var mapMainView: UIView!
    @IBOutlet weak var listMainView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var beaconNameLabel: UILabel!
    @IBOutlet weak var beaconDistanceLabel: UILabel!
    @IBOutlet weak var viewOfferBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var beaconBtn1: UIButton!
    @IBOutlet weak var beaconBtn2: UIButton!
    @IBOutlet weak var beaconBtn3: UIButton!
    @IBOutlet weak var beaconBtn4: UIButton!
    @IBOutlet weak var beaconBtn5: UIButton!
    
    var detectedBeacons = [ISBeacon]()
    var updateBeaconsRange:Bool = false
    
    var mediaNames: [String]!
    var lightBoxController:LightboxController!
    
    var locationManager = CLLocationManager()
    var centralManager:CBCentralManager!
    
    var offerShowing:Bool = false
    var offerShowed:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nearest Beacons"
        //setNavigationBarStyle(navigationBar: (navigationController?.navigationBar)!)
        setupViews()
        
        mediaNames = ["http://www.clarkvision.com/galleries/images.bears-2004a/web/brown_bear.c09.08.2004.JZ3F2624.b-700.jpg"]
        
        locationManager.delegate = self
        
        tableView.tableFooterView = UIView()
        
        viewOfferBtn.isEnabled = false
        viewOfferBtn.alpha = 0.5
        
        if beaconsData == nil{
            
            if let bcdata:[NSDictionary] = userDefaults.object(forKey: getBeacons) as? [NSDictionary]{
                
                beaconsData = Mapper<ISBeacon>().mapArray(JSONObject: bcdata)!
            }
        }
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])

        startMonitoring()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkLocationPermission()
        
        offerShowing = false
        
        if user.photo != "" {
            
            let photo:String = (user.photo!.contains(IMAGE_BASE_URL)) ? user.photo! : IMAGE_BASE_URL+user.photo!
            
            userImgView.layer.cornerRadius = userImgView.frame.size.height/2
            userImgView.clipsToBounds = true
            userImgView.sd_setShowActivityIndicatorView(true)
            userImgView.sd_setIndicatorStyle(.white)
            userImgView.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: ""))
        }
    }
    
    func setupViews(){
        
        setButtonNormalStyle(buttons: [byMapBtn], cornerRadius: 15)
        setButtonNormalStyle(buttons: [viewOfferBtn], cornerRadius: 20)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        centralManager = central
        //checkBluetooth()
    }
    
    func checkBluetooth(){
        
        if centralManager.state == .poweredOff{
            
            //showAlert(title: "Bluetooth Off", message: "Bluetooth is turned off. Please turn on bluetooth to see the nearby offers.", buttonText: "OK")
        }
        else if centralManager.state == .unsupported || centralManager.state == .unauthorized{
            //showAlert(title: "Bluetooth Off", message: "Bluetooth is turned off or not supported on this device. Please make sure bluetooth is turned on to see the nearby offers.", buttonText: "OK")
        }
    }
    
    func showLightBox(images:[LightboxImage]){
        
        lightBoxController = LightboxController(images: images)
        
        lightBoxController.pageDelegate = self
        lightBoxController.dismissalDelegate = self
        lightBoxController.dynamicBackground = true
        
        present(lightBoxController, animated: true, completion: nil)
    }
    
    @IBAction func tabBtnPressed(_ sender: UIButton) {
        
        if sender.tag == 0{ //map
            
            setButtonNormalStyle(buttons: [byMapBtn], cornerRadius: 15)
            setButtonRemoveStyle(buttons: [byListBtn])
            
            UIView.animate(withDuration: 0.3, animations: { 
                
                self.mapMainView.alpha = 1
                self.listMainView.alpha = 0
            })
            
        }
        else{ //list
            
            setButtonNormalStyle(buttons: [byListBtn], cornerRadius: 15)
            setButtonRemoveStyle(buttons: [byMapBtn])
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.mapMainView.alpha = 0
                self.listMainView.alpha = 1
            })
        }
    }
    
    @IBAction func beaconBtnPressed(_ sender: UIButton) {
        
        let filteredBeacons:[Beacon] = detectedBeacons.filter{$0.deviceId == String(sender.tag)}
        
        if filteredBeacons.count > 0 {
            
            let beacon = filteredBeacons.first
            beaconNameLabel.text = beacon?.deviceName!
            beaconDistanceLabel.text = beacon?.locationString()
            viewOfferBtn.tag = Int((beacon?.deviceId)!)!
            viewOfferBtn.isEnabled = true
            viewOfferBtn.alpha = 1
        }
        else{
            
            beaconNameLabel.text = "(No Beacon Detected)"
            beaconDistanceLabel.text = "(No Beacon Detected)"
            viewOfferBtn.isEnabled = false
            viewOfferBtn.alpha = 0.5
        }
        
    }
    
    @IBAction func viewOfferTapped(_ sender: UIButton) {
        
        for beacon in detectedBeacons {
            if beacon.deviceId == String(sender.tag) {
                
                if beacon.campaigns?.count > 0{
                    
                    setupOfferView(beacon: beacon)
                }
                else{
                    showAlert(title: "No Offers", message: "There are no offers on this beacon right now.", buttonText: "Dismiss")
                }
                break
            }
        }
    }
    
    func cellViewOfferTapped(_ sender:UIButton){
        
        let beacon = detectedBeacons[sender.tag]
        
//        if (beacon.campaigns?.count > 0{
//
//            setupOfferView(beacon: beacon)
//        }
//        else{
//            showAlert(title: "No Offers", message: "There are no offers on this beacon right now.", buttonText: "Dismiss")
//        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        stopMonitoring()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        
        showDrawerMenu(this: self)
    }
    
    func startMonitoring() {
        
        let beacon:MyBeacon = MyBeacon(name: beaconName, uuid: beaconUUID, majorValue: beaconMajor, minorValue: beaconMinor)
        
        let beaconRegion = beacon.asBeaconRegion()
        beaconRegion.notifyEntryStateOnDisplay = true
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func stopMonitoring() {
        
        let beacon:MyBeacon = MyBeacon(name: beaconName, uuid: beaconUUID, majorValue: beaconMajor, minorValue: beaconMinor)
        
        let beaconRegion = beacon.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    func setupOfferView(beacon:ISBeacon){
        
        var offerMedia:[LightboxImage] = []
        
        offerShowing = true
        offerShowed.append("\(beacon.uuid)\(beacon.major)\(beacon.minor!)")
        
        for campaign in beacon.campaigns{
            
            switch campaign.mediaType {
            case "imageFile":
                
                let lightBox = LightboxImage(imageURL: URL(string: campaign.image)!,
                              text: campaign.campaignName + "\r" + campaign.runningDate)
                offerMedia.append(lightBox)
                showLightBox(images: offerMedia)
                break
            
            case "videoFile":
                
                let lightBox = LightboxImage(image: UIImage(named: "logo_full")!,
                                             text: campaign.campaignName + "\r" + campaign.runningDate,
                                             videoURL: URL(string: campaign.video))
                offerMedia.append(lightBox)
                showLightBox(images: offerMedia)
                break
                
            case "videoUrl":
                
                let viewController:StartExploringViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartExploringViewController") as! StartExploringViewController
                viewController.isForOffer = true
                viewController.isEmbed = true
                viewController.offerTitle = campaign.campaignName
                viewController.offerUrl = campaign.embed
                self.present(viewController, animated: true, completion: nil)
                break
                
            case "fileUrl":
                
                let viewController:StartExploringViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartExploringViewController") as! StartExploringViewController
                viewController.isForOffer = true
                viewController.isEmbed = false
                viewController.offerTitle = campaign.campaignName
                viewController.offerUrl = campaign.url
                self.present(viewController, animated: true, completion: nil)
                break
                
            case "noteFile":
                
                showAlert(title: campaign.title, message: campaign.notification, buttonText: "Dismiss")
                break
                
            default:
                break
            }
        }
    }
    
    func showBeaconsOnMap(){
        
        beaconBtn1.isHidden = true
        beaconBtn2.isHidden = true
        beaconBtn3.isHidden = true
        beaconBtn4.isHidden = true
        beaconBtn5.isHidden = true
        
        let count = (detectedBeacons.count<5) ? detectedBeacons.count : 5
        
        for i in 0..<count {
            
            let beacon = detectedBeacons[i]
 
            switch i {
            case 0:
                beaconBtn1.tag = Int(beacon.deviceId)!
                beaconBtn1.isHidden = false
                viewOfferBtn.tag = Int(beacon.deviceId)!
                if !offerShowing && !offerShowed.contains("\(beacon.uuid)\(beacon.major)\(beacon.minor!)"){
                    viewOfferTapped(viewOfferBtn)
                }
                beaconBtnPressed(beaconBtn1)
                break
            case 1:
                beaconBtn2.tag = Int(beacon.deviceId)!
                beaconBtn2.isHidden = false
                viewOfferBtn.tag = Int(beacon.deviceId)!
                if !offerShowing && !offerShowed.contains("\(beacon.uuid)\(beacon.major)\(beacon.minor!)"){
                    viewOfferTapped(viewOfferBtn)
                }
                break
            case 2:
                beaconBtn3.tag = Int(beacon.deviceId)!
                beaconBtn3.isHidden = false
                viewOfferBtn.tag = Int(beacon.deviceId)!
                if !offerShowing && !offerShowed.contains("\(beacon.uuid)\(beacon.major)\(beacon.minor!)"){
                    viewOfferTapped(viewOfferBtn)
                }
                break
            case 3:
                beaconBtn4.tag = Int(beacon.deviceId)!
                beaconBtn4.isHidden = false
                viewOfferBtn.tag = Int(beacon.deviceId)!
                if !offerShowing && !offerShowed.contains("\(beacon.uuid)\(beacon.major)\(beacon.minor!)"){
                    viewOfferTapped(viewOfferBtn)
                }
                break
            case 4:
                beaconBtn5.tag = Int(beacon.deviceId)!
                beaconBtn5.isHidden = false
                viewOfferBtn.tag = Int(beacon.deviceId)!
                if !offerShowing && !offerShowed.contains("\(beacon.uuid)\(beacon.major)\(beacon.minor!)"){
                    viewOfferTapped(viewOfferBtn)
                }
                break
            default:
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NearbyBeaconsViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return detectedBeacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NearbyBeaconsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "nearbycell")! as! NearbyBeaconsTableViewCell
        
        cell.selectionStyle = .none
        
        let beacon:Beacon = detectedBeacons[indexPath.row]
        
        cell.beaconName.text = beacon.deviceName!
        
        if beacon.beacon != nil{
            cell.beaconDistance.text = beacon.locationString()
        }
        
        cell.viewOfferBtn.tag = indexPath.row
        cell.viewOfferBtn.addTarget(self, action: #selector(NearbyBeaconsViewController.cellViewOfferTapped(_:)), for: .touchUpInside)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return UITableViewAutomaticDimension
    }
}

extension NearbyBeaconsViewController: CLLocationManagerDelegate {
    
    func checkLocationPermission(){
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
        
                locationManager.requestAlwaysAuthorization()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            showAlert(title: "Location Services", message: "Your location services are disbaled. Please turn on locations servies from settings to get the nearby offers.", buttonText: "OK")
            print("Location services are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print  ("didEnterRegion Called")
        updateBeaconsRange = true
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        print  ("didExitRegion Called")
        updateBeaconsRange = false
        detectedBeacons.removeAll()
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        //if !updateBeaconsRange{
        //    return
        //}
        
        if detectedBeacons.count > beacons.count{
            detectedBeacons.removeAll()
        }
        
        var indexPaths = [IndexPath]()
        
        let beaconDataCopy = NSArray(array: beaconsData) as! [Beacon]
        
        for beacon in beacons {
            
            for myBeacon in beaconDataCopy{
                
                if myBeacon.uuid == beacon.proximityUUID.uuidString &&
                    myBeacon.major == beacon.major.stringValue &&
                    myBeacon.minor == beacon.minor.stringValue {
                    
                    var contains:Bool = false
                    for dbeacon in detectedBeacons{
                        
                        if dbeacon.uuid == myBeacon.uuid &&
                            dbeacon.major == myBeacon.major &&
                            dbeacon.minor == myBeacon.minor {
                            
                            contains = true
                            break
                        }
                    }
                    
                    if !contains{
                        
                        myBeacon.beacon = beacon
                        detectedBeacons.append(myBeacon)
                        
                        print("NAME: \(detectedBeacons)")
                        tableView.reloadData()
                        showBeaconsOnMap()
                    }
                    else{
                        
                        // To update the location of existing beacons
                        for row in 0..<detectedBeacons.count {
                            if detectedBeacons[row].deviceId == myBeacon.deviceId {
                                
                                detectedBeacons[row].beacon = beacon
                                indexPaths += [IndexPath(row: row, section: 0)]
                                break
                            }
                        }
                        
                        // Update beacon locations of visible rows.
                        if let visibleRows = tableView.indexPathsForVisibleRows {
                            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
                            
                            tableView.reloadRows(at: rowsToUpdate, with: UITableViewRowAnimation.none)
                        }
                    }
                }
            }
        }
    }
}

extension NearbyBeaconsViewController: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
        //print(page)
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // ...
    }
}
