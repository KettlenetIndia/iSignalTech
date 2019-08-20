//
//  RootViewController.swift
//  iSignal Tech
//
//  Created by Apple on 21/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import LGSideMenuController

class RootViewController: LGSideMenuController,LGSideMenuDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
         isShowAnimation = true
        sideMenuController?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "ISFindVenueViewController")
        sideMenuController?.leftViewController = self.storyboard?.instantiateViewController(withIdentifier: "ISSideMenuViewController")
        sideMenuController?.leftViewWidth = self.view.frame.size.width;
        sideMenuController?.leftViewPresentationStyle = .slideAbove
        sideMenuController?.swipeGestureArea = .full
        sideMenuController?.delegate = self
    }
    
   
    func didShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        if isShowAnimation{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayAnimation"), object: nil)
        }
    }
    

}
