//
//  DashboardViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 26/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class DashboardViewController: UIViewController, CBCentralManagerDelegate {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var bluetoothLabel: UILabel!
    
    var isBluetoothOn:Bool = true
    var centralManager:CBCentralManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewBackground(view: view, imageName: "bg_home", navigationBar: nil, navImageName: nil)
        //locationManager.delegate = self
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        
        if ISNetworkManager.shred.offerUpdateTimer == nil{
            
            ISNetworkManager.shred.offerUpdateTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.scheduleOffersFetch), userInfo: nil, repeats: true)
        }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.navigationController?.navigationBar.isHidden = true
    }
    
    func scheduleOffersFetch(){
        
        ISNetworkManager.shred.getActiveBeaconsAndOffers(completion: { (success) in })
    }
    
    func checkBluetooth(){
        
        if centralManager.state == .poweredOn{
            isBluetoothOn = true
            bluetoothLabel.text = "Switch the bluetooth OFF"
        }
        else if centralManager.state == .poweredOff{
            isBluetoothOn = false
            bluetoothLabel.text = "Switch the bluetooth ON"
        }
        else if centralManager.state == .unsupported{
            isBluetoothOn = false
            bluetoothLabel.text = "Bluetooth is not supported on this platform/device."
        }
        else if centralManager.state == .unauthorized{
            isBluetoothOn = false
            bluetoothLabel.text = "Bluetooth is not authorized in this app."
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender.tag == 0{

            let viewController:StartExploringViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartExploringViewController") as! StartExploringViewController
            viewController.isForOffer = false
            self.navigationController?.pushViewController(viewController, animated: true)

        }
        else if sender.tag == 1{
            
            if isBluetoothOn{
                
                showAlert(title: "Turn Bluetooth Off", message: "To turn off bluetooth, Please go to the settings.", buttonText: "OK")
            }
            else{
                showAlert(title: "Turn Bluetooth On", message: "To turn on bluetooth, Please go to the settings.", buttonText: "OK")
            }
            
        }
        else if sender.tag == 2{
            
            let viewController:NearbyBeaconsViewController = self.storyboard?.instantiateViewController(withIdentifier: "NearbyBeaconsViewController") as! NearbyBeaconsViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if sender.tag == 3{
            
            let viewController:FeedbackViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        centralManager = central
        
        checkBluetooth()
    }

}
