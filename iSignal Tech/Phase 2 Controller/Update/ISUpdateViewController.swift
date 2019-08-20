//
//  ISUpdateViewController.swift
//  iSignal Tech
//
//  Created by Apple on 09/12/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit

class ISUpdateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnActionDismiss(_ sender: Any) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnActionUpdate(_ sender: Any) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string:"https://itunes.apple.com/us/app/isignal-tech/id1224269674?ls=1&mt=8")!)
        } else {
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/isignal-tech/id1224269674?ls=1&mt=8")!)
        }
    }
}
