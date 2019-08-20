//
//  ISSettingViewController.swift
//  iSignal Tech
//
//  Created by Apple on 20/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit

class ISSettingViewController: UIViewController {

    
    @IBOutlet weak var imgProfile: ZWImageView!
    @IBOutlet weak var lblProfile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountriesAndCities(view: self.view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if user.photo != "" {
            
            let photo:String = (user.photo!.contains(IMAGE_BASE_URL)) ? user.photo! : IMAGE_BASE_URL+user.photo!
//            imgProfile.sd_setShowActivityIndicatorView(true)
//            imgProfile.sd_setIndicatorStyle(.white)
            imgProfile.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "top_logo_white"))
        }
        
        var message = ""
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 0 && hour < 12 {
            message = "Good Morning !"
        }else if hour >= 12 && hour < 16{
            message = "Good Afternoon !"
        }else if hour >= 16 && hour <= 24{
            message = "Good Evening !"
        }
        self.lblProfile.text = "Hi \(user.name ?? ""), \(message)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnActionLogout(_ sender: UIButton) {
        
//        eBeaconManager.stopRangingBeaconsInAllRegions()
        userDefaults.set(false, forKey: getLoggedInKey)
        userDefaults.removeObject(forKey: "isWelComePresented")
        userDefaults.synchronize()
        moveToLogin()
    }
    
    @IBAction func btnActionNearbtDevices(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnActionProfile(_ sender: UIButton) {
        let profileController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
        self.navigationController?.pushViewController(profileController!, animated: true)
    }
    
    @IBAction func btnActionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
