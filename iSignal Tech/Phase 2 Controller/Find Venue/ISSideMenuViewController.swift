//
//  ISSideMenuViewController.swift
//  iSignal Tech
//
//  Created by Apple on 21/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import LGSideMenuController

class ISSideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblSideMenuList: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func InitialSetup(){
        tblSideMenuList.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tblSideMenuList.frame.size.width, height: 0.01))
        ISNetworkManager.shred.getSideMenuCategoryList { (isSuccess, response) in
            if isSuccess{
                categoryList = (response?.categoryList)!
                if categoryList.count > 0{
                    if(delegate != nil){
                        delegate?.didSelectMenuAt!(index: 0)
                    }
                }
                self.tblSideMenuList.reloadData()
            }else{
                
                guard response?.error != nil else{
                    return
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playAnimation), name: NSNotification.Name(rawValue: "PlayAnimation"), object: nil)
    }
    
    
    @objc  private func playAnimation(){
        if categoryList.count > 0{
            isShowAnimation = false
            self.animateTableViewHorizontal()
            NotificationCenter.default.removeObserver(self)
        }
    }
  

    //MARK: - UITableView Delegate Data source -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sideMenuCell = tableView.dequeueReusableCell(withIdentifier: "ISSideMenuCell", for: indexPath) as! ISSideMenuCell
        sideMenuCell.lblSideMenuName.text = categoryList[indexPath.row].category_name
        sideMenuCell.imgSideMenu.sd_setImage(with: URL(string: categoryList[indexPath.row].category_icon!))
        sideMenuCell.selectionStyle = .none
        sideMenuCell.isHidden = isShowAnimation
        return sideMenuCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sideMenuController?.hideLeftViewAnimated()
        if(delegate != nil){
            delegate?.didSelectMenuAt!(index: indexPath.row)
        }
    }
    
    

    
    private func animateTableViewHorizontal(){
        let visibleCells = self.tblSideMenuList.visibleCells
        let tableWidth = tblSideMenuList.bounds.size.width
        
        for cell in visibleCells{
            cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
        }
        
        var index = 0
        for cell in visibleCells{
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
                cell.isHidden = false
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                
            }, completion: nil)
            index += 1
        }
    }
}


class ISSideMenuCell : UITableViewCell{
    
    @IBOutlet weak var lblSideMenuName: UILabel!
    @IBOutlet weak var imgSideMenu: UIImageView!
    
}
