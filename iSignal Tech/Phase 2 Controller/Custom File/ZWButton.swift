//
//  FDButton.swift
//
//

import UIKit


private let buttonPadding: CGFloat = 50
//@IBDesignable
class ZWButton : UIButton {
    var topBorder: UIView?
    var bottomBorder: UIView?
    var leftBorder: UIView?
    var rightBorder: UIView?
    
    @IBInspectable var isRightImage : Bool = false {
        didSet {
            if isRightImage {
                titleEdgeInsets = UIEdgeInsets(top: 0, left: (10 - imageView!.frame.size.width), bottom: 0, right: imageView!.frame.size.width)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: frame.size.width - (10 + imageView!.frame.size.width), bottom: 0, right: 0)
                //self.layoutSubviews()
                //self.layoutIfNeeded()
            }
        }
    }
    @IBInspectable var highlightedImage : UIImage? {
        didSet {
            setImage(highlightedImage, for: .highlighted)
        }
    }
    @IBInspectable var normalImage: UIImage? {
        didSet {
            setImage(normalImage, for: .normal)
        }
    }
    @IBInspectable var normalTextColor : UIColor? {
        didSet {
            setTitleColor(normalTextColor, for: .normal)
        }
    }
    @IBInspectable var highlightedTextColor : UIColor? {
        didSet {
            setTitleColor(highlightedTextColor, for: .highlighted)
        }
    }
    @IBInspectable var highlightedBackgroundColor: UIColor = UIColor.clear {
        didSet {
            setBackgroundImage(getImageWithColor(color: highlightedBackgroundColor, size: CGSize(width: 1, height: 1)), for: .highlighted)
        }
    }
    @IBInspectable var normalBackgroundColor: UIColor = UIColor.clear {
        didSet {
            setBackgroundImage(getImageWithColor(color: normalBackgroundColor, size: CGSize(width: 1, height: 1)), for: .normal)
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
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    @IBInspectable var isCircle: Bool = false {
        didSet {
            layer.cornerRadius = frame.width/2
            layer.masksToBounds = true
        }
    }
    @IBInspectable var topBorderColor : UIColor = UIColor.clear
    @IBInspectable var topBorderHeight : CGFloat = 0 {
        didSet{
            if topBorder == nil{
                topBorder = UIView()
                topBorder?.backgroundColor=topBorderColor;
                topBorder?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: topBorderHeight)
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
                bottomBorder?.frame = CGRect(x: 0, y: self.frame.size.height - bottomBorderHeight, width: self.frame.size.width, height: topBorderHeight)
                addSubview(bottomBorder!)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRightImage {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: (10 - imageView!.frame.size.width), bottom: 0, right: imageView!.frame.size.width)
            print(imageView!.frame.size.width)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: frame.size.width - (10 + imageView!.frame.size.width), bottom: 0, right: 0)
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
                rightBorder?.backgroundColor=topBorderColor;
                rightBorder?.frame = CGRect(x: self.frame.size.width - rightBorderHeight, y: 0, width: rightBorderHeight, height: self.frame.size.height)
                addSubview(rightBorder!)
            }
        }
    }

}


func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}
