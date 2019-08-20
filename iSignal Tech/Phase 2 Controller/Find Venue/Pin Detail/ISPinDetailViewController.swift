//
//  ISPinDetailViewController.swift
//  iSignal Tech
//
//  Created by Apple on 29/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import SDWebImage



typealias dismissComplition = () -> Void

class ISPinDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var itemDetail : CategoryItem?
    var strTitle : String?
    var webpageUrl : String?
    var isSurvey = false
    var webPageContent = ""
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgHeaderBackgrund: UIImageView!
    
    @IBOutlet weak var scrrollViewAddress: UIScrollView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblWebSite: UILabel!
    
    var arrSliderImages = [String]()
    
    var dismiss : dismissComplition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    private func InitialSetup(){
        if webPageContent != ""{
            self.lblTitle.text = strTitle
            self.webView.loadHTMLString(webPageContent, baseURL: nil)
            self.webView.isHidden = false
        }else if strTitle != nil && webpageUrl != nil{
                self.lblTitle.text = strTitle
                let urlString = webpageUrl?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                let url = URL(string: urlString!)
                self.webView.loadRequest(URLRequest(url: url!))
                self.webView.isHidden = false
        }else if itemDetail != nil{
            if itemDetail?.images != ""{
                
                self.sliderCollectionView.layer.borderWidth = 5
                self.sliderCollectionView.layer.borderColor = UIColor.white.cgColor
                self.sliderCollectionView.layer.cornerRadius = 10
                self.sliderCollectionView.clipsToBounds = true
                
                imgHeaderBackgrund.isHidden = true
                self.scrrollViewAddress.isHidden = false
                arrSliderImages = (itemDetail?.images.components(separatedBy: ","))!
                self.pageControl.numberOfPages = arrSliderImages.count
                self.sliderCollectionView.reloadData()
                
                self.lblTitle.text = itemDetail?.companyName ?? ""
                self.lblTitle.textColor = UIColor.black
                self.lblAddress.text = "\(itemDetail?.street ?? ""),\(itemDetail?.city ?? "")"
                self.lblPhoneNo.text = itemDetail?.phoneNo ?? ""
                self.lblEmail.text = itemDetail?.email ?? ""
                self.lblWebSite.text = itemDetail?.website ?? ""
                
            }
        }
        
        if isSurvey{
            userDefaults.removeObject(forKey: "isWelComePresented")
            userDefaults.synchronize()
        }
    }
    
    //MARK:- ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.sliderCollectionView{
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
            self.pageControl.currentPage = page
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSliderImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath)
        let imageView = collectionViewCell.viewWithTag(555) as! UIImageView
        imageView.sd_setImage(with: URL(string: arrSliderImages[indexPath.row]))
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        let confirmationAlert = UIAlertController(title: "Are you sure to exit ?", message: "", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
            self.navigationController?.popViewController(animated: true)
            if self.dismiss != nil{
                self.dismiss!()
            }
        }))
        self.present(confirmationAlert, animated: true, completion: nil)
    }
}


