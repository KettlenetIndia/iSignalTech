//
//  BluetoothSettingViewController.swift
//  iSignal Tech
//
//  Created by Apple on 22/12/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class BluetoothSettingViewController: UIViewController {

    
    @IBOutlet weak var playerView: UIView!
    var avPlayer : AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var videoUrl = Bundle.main.url(forResource: "ble_on", withExtension: "mp4")
        
        if Services.isBluetoothEnable{
           videoUrl = Bundle.main.url(forResource: "ble_off", withExtension: "mp4")
        }
        
            avPlayer = AVPlayer(url: videoUrl!)

            let avPlayerController = AVPlayerViewController()
            avPlayerController.player = avPlayer
            avPlayerController.view.frame = self.playerView.frame
           self.addChild(avPlayerController)
            self.playerView.addSubview(avPlayerController.view)
            avPlayer?.play()
        
//        let player = AVPlayer(url: videoUrl!)
//        let playerController = AVPlayerViewController()
//
//        playerController.player = player
//        playerController.view.frame = self.playerView.frame
//        self.addChild(playerController)
//        self.playerView.addSubview(playerController.view)
//        playerController.view.frame = self.view.frame
//
//        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnActionOkay(_ sender: Any) {
        if avPlayer != nil{
           avPlayer?.pause()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
//    let filepath: String? = Bundle.main.path(forResource: "qidong", ofType: "mp4")
//    let fileURL = URL.init(fileURLWithPath: filepath!)
//
//
//    avPlayer = AVPlayer(url: fileURL)
//
//
//    let avPlayerController = AVPlayerViewController()
//    avPlayerController.player = avPlayer
//    avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//
//    //  hide show control
//    avPlayerController.showsPlaybackControls = false
//    // play video
//
//    avPlayerController.player?.play()
//    self.view.addSubview(avPlayerController.view)

}
