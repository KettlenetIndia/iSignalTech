//
//  FDView.swift

import UIKit

@IBDesignable

class ZWView : UIView {
    var topBorder: UIView?
    var bottomBorder: UIView?
    var leftBorder: UIView?
    var rightBorder: UIView?
    
    private var _round = false
    @IBInspectable var round: Bool{
        set{
            _round = newValue
            makeRound()
        }
        get{
            return self._round
        }
    }
    
    private func makeRound(){
        if self.round == true{
            self.clipsToBounds = true
            self.layer.cornerRadius = (self.frame.width + self.frame.height) / 4
            
        }
        else{
            self.layer.cornerRadius = 0
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var shadow : Bool = false {
        didSet{
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOpacity = 0.2
            layer.shadowOffset = CGSize.zero
            layer.shadowRadius = 1
            
            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            layer.shouldRasterize = true
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    @IBInspectable var topBorderColor : UIColor = UIColor.clear
    @IBInspectable var topBorderHeight : CGFloat = 0 {
        didSet{
            if topBorder == nil{
                topBorder = UIView()
                topBorder?.backgroundColor=topBorderColor;
                topBorder?.frame = CGRect(x: 0,y: 0,width: self.frame.size.width,height: topBorderHeight)
                addSubview(topBorder!)
            }
        }
    }
    @IBInspectable var bottomBorderColor : UIColor = UIColor.clear
    @IBInspectable var bottomBorderHeight : CGFloat = 0 {
        didSet{
            if bottomBorder == nil{
                bottomBorder = UIView()
                bottomBorder?.backgroundColor=bottomBorderColor;
                bottomBorder?.frame = CGRect(x: 0, y: self.frame.size.height - bottomBorderHeight, width: self.frame.size.width, height: bottomBorderHeight)
                addSubview(bottomBorder!)
            }
        }
    }
    @IBInspectable var leftBorderColor : UIColor = UIColor.clear
    @IBInspectable var leftBorderHeight : CGFloat = 0 {
        didSet{
            if leftBorder == nil{
                leftBorder = UIView()
                leftBorder?.backgroundColor=leftBorderColor;
                leftBorder?.frame = CGRect(x: 0, y: 0, width: leftBorderHeight, height: self.frame.size.height)
                addSubview(leftBorder!)
            }
        }
    }
    @IBInspectable var rightBorderColor : UIColor = UIColor.clear
    @IBInspectable var rightBorderHeight : CGFloat = 0 {
        didSet{
            if rightBorder == nil{
                rightBorder = UIView()
                rightBorder?.backgroundColor=rightBorderColor;
                rightBorder?.frame = CGRect(x: self.frame.size.width - rightBorderHeight, y: 0, width: rightBorderHeight, height: self.frame.size.height)
                addSubview(rightBorder!)
            }
        }
    }
    override func layoutSubviews() {
        if topBorder != nil{
            topBorder?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: topBorderHeight)
        }
        if bottomBorder != nil{
            bottomBorder?.frame = CGRect(x: 0, y: self.frame.height - bottomBorderHeight, width: self.frame.size.width, height: bottomBorderHeight)
        }
    }
    override func draw(_ rect: CGRect) {
        if topBorder != nil{
            topBorder?.frame = CGRect(x: 0, y: 0, width: rect.width, height: topBorderHeight)
        }
        if bottomBorder != nil{
            bottomBorder?.frame = CGRect(x: 0, y: rect.height - bottomBorderHeight, width: rect.size.width, height: bottomBorderHeight)
        }
    }
}
