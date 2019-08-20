//
//  StartExploringViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 27/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit

class StartExploringViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    
    var isForOffer:Bool = false
    var isEmbed:Bool = false
    var offerUrl:String!
    var offerTitle:String = "Offer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url:URL!
        
        if isForOffer{
            menuBtn.isHidden = true
            headingLabel.text = offerTitle
            
            if isEmbed{
                
                createWebViewPlayer()
            }
            else{
                
                url = URL(string: offerUrl)!
                webView.loadRequest(URLRequest(url: url as URL))
            }
        }
        else{
            
            headingLabel.text = "Start Exploring"
            url = URL(string: "https://isignal.tech/app/apps-m/map.php")!
            webView.loadRequest(URLRequest(url: url as URL))
        }
    }
    
    func createWebViewPlayer(){
        
        self.webView.allowsInlineMediaPlayback = true
        
        let embededHTML = "<html><body>"+offerUrl+"</body></html>"
        
        self.webView.loadHTMLString(embededHTML, baseURL: nil)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        if isForOffer{
            dismiss(animated: true, completion: nil)
        }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        
        showDrawerMenu(this: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
