//
//  DrawerViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 27/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import SDWebImage

class DrawerViewController: UIViewController {
    
    @IBOutlet weak var userPhoto: UIImageView!
    var this:UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        addViewBackground(view: view, imageName: "sidemenu_bg", navigationBar: nil, navImageName: nil)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if user.photo != "" {
            
            let photo:String = (user.photo!.contains(IMAGE_BASE_URL)) ? user.photo! : IMAGE_BASE_URL+user.photo!
            
            userPhoto.layer.cornerRadius = userPhoto.frame.size.height/2
            userPhoto.clipsToBounds = true
            userPhoto.layer.borderColor = UIColor.white.cgColor
            userPhoto.layer.borderWidth = 2
            
          //  userPhoto.sd_setShowActivityIndicatorView(true)
           // userPhoto.sd_setIndicatorStyle(.white)
            userPhoto.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "top_logo_white"))
        }
    }

    @IBAction func closePressed(_ sender: UIButton) {
     
        hideDrawerMenu(this: self)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        if sender.tag == 0{ //Profile
            
            let viewController:ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            this.navigationController?.pushViewController(viewController, animated: false)
            
            hideDrawerMenu(this: self)
        }
        else if sender.tag == 1{ //nearby
            
//            let viewController:NearbyBeaconsViewController = self.storyboard?.instantiateViewController(withIdentifier: "NearbyBeaconsViewController") as! NearbyBeaconsViewController
//            this.navigationController?.pushViewController(viewController, animated: true)
//
            hideDrawerMenu(this: self)
        }
        else if sender.tag == 2{ //logout
            
            userDefaults.set(false, forKey: getLoggedInKey)
            userDefaults.synchronize()
            moveToLogin()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
