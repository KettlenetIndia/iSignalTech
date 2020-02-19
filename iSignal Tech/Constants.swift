//
//  Constants.swift
//  Smart Learner
//
import Foundation
import UIKit
import MBProgressHUD
import CoreLocation
import ObjectMapper

var BASE_URL = "http://api.isignal.tech/v1/"
//var BASE_URL = "http://api.isignal.tech/v2/"
var IMAGE_BASE_URL = "http://api.isignal.tech/assets/user/"

// MARK: APP COLORS
var themeColor:UIColor = UIColorFromRGB(rgbValue: 0xe9212d)

var cornerRadius:CGFloat = 5.0

// MARK: UserDefaults
var userDefaults:UserDefaults = UserDefaults.standard

//MARK: User Object
var userObject:NSDictionary!

// MARK:- MBProgressHUD
var progressHUD = MBProgressHUD()

// MARK:- Objects
var beaconsData = [ISBeacon]()
var countriesData:[Country]!
var user:UserDetail!

//Beacon Properties
//let beaconName = "My Beacon"
//let beaconUUID = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
//let beaconMajor = 1
//let beaconMinor = 1

// MARK:- Keys
let getBeacons:String = "getBeacons"
let getCountries:String = "getCountries"
let getMockQuestionsCount:String = "mockQuestionShowCount"
let getMoveToNextQuestion:String = "moveToNextQuestion"
let getShowCorrectAnswer:String = "showCorrectAnswer"
let getDeviceToken:String = "getDeviceToken"
let getLoggedInKey:String = "isLoggedIn"
let getUserObjectKey:String = "getUserObject"

public func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

public func getScreenWidth() -> CGFloat{
    if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight){
        return UIScreen.main.bounds.size.height
    }else{
        return UIScreen.main.bounds.size.width
        
    }
    if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft){
        return UIScreen.main.bounds.size.height
    }else{
        return UIScreen.main.bounds.size.width
        
    }
//    if (UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
//
//        return UIScreen.main.bounds.size.height
//    }
//    else{
//
//        return UIScreen.main.bounds.size.width
//    }
}

public func getScreenHeight() -> CGFloat{
    if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight){
         return UIScreen.main.bounds.size.width
    }else{
        return UIScreen.main.bounds.size.height
        
    }
    if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft){
          return UIScreen.main.bounds.size.width
    }else{
       return UIScreen.main.bounds.size.height
        
    }
//    if (UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
//
//        return UIScreen.main.bounds.size.width
//    }
//    else{
//
//        return UIScreen.main.bounds.size.height
//    }
}

public struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


// MARK:- Helper Methods

func addViewBackground(view:UIView, imageName:String, navigationBar:UINavigationBar?, navImageName:String?){
    
    var bgImgBottom:String!
    if DeviceType.IS_IPHONE_4_OR_LESS{
        bgImgBottom = imageName
    }
    else if DeviceType.IS_IPHONE_5{
        
        bgImgBottom = imageName
    }
    else if DeviceType.IS_IPHONE_6{
        
        bgImgBottom = imageName
    }
    else if DeviceType.IS_IPHONE_6P{
    
        bgImgBottom = imageName
    }
    else{
        bgImgBottom = imageName
    }
    
    // navigationBar.setBackgroundImage(UIImage.init(named: bgImgTop), forBarMetrics: UIBarMetrics.Default)
    view.backgroundColor = UIColor(patternImage: UIImage(named: bgImgBottom)!)
    //navigationBar.shadowImage = UIImage()
    //navigationBar.barTintColor = UIColor.blackColor()
}

func addDoneButtonOnKeyboard(textFields:[UITextField]?, textViews:[UITextView]?, target:AnyObject)
{
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 320, height: 50))
    doneToolbar.barStyle = UIBarStyle.default
    //doneToolbar.backgroundColor = UIColorFromRGB(0x2b2b2b)
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: target, action: Selector(("doneButtonAction")))
    
    done.setTitleTextAttributes([
        NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 14)!,
        NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .normal)
    
    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)
    
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    if textFields != nil{
        
        for textfield in textFields!{
            
            textfield.inputAccessoryView = doneToolbar
        }
    }
    
    if textViews != nil{
        
        for textView in textViews!{
            
            textView.inputAccessoryView = doneToolbar
        }
    }
    
}

func showDrawerMenu(this:UIViewController){
    
    let drawer:DrawerViewController = (this.storyboard?.instantiateViewController(withIdentifier: "DrawerViewController"))! as! DrawerViewController
    
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromLeft
    this.view.window!.layer.add(transition, forKey: kCATransition)
    drawer.this = this
    this.present(drawer, animated: false, completion: nil)
}

func hideDrawerMenu(this:UIViewController){
    
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromRight
    this.view.window!.layer.add(transition, forKey: kCATransition)
    this.dismiss(animated: false, completion: nil)
}

func showAlert(title:String, message:String, buttonText:String){
    
    let alert:UIAlertView = UIAlertView()
    alert.title = title
    alert.message = message
    alert.addButton(withTitle: buttonText)
    alert.show()
}

func showRequiredAlert(msg:String) -> Bool{
    
    showAlert(title: "Required Field", message: String(format: "%@ is required.",msg), buttonText: "OK")
    return false
}

func isValidEmail(emailStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: emailStr)
}

func setupCountriesAndCities(view:UIView){
    
    if !ISNetworkManager.shred.countriesFetched {
        
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD.detailsLabel.text = "Fetching Countries"
        ISNetworkManager.shred.getCountriesAndStates(completion: { (success) in
            progressHUD.hide(animated: true)
            if success{
                ISNetworkManager.shred.countriesFetched = true
            }
        })
    }
    else{
        if countriesData == nil{
            
            if let countries:[NSDictionary] = userDefaults.object(forKey: getCountries) as? [NSDictionary]{
                countriesData = Mapper<Country>().mapArray(JSONObject: countries)!
            }
            else{
                
                progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
                progressHUD.detailsLabel.text = "Fetching Countries"
                ISNetworkManager.shred.getCountriesAndStates(completion: { (success) in
                    
                })
            }
        }
    }
}

func moveToLogin(){
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
    if let window =  UIApplication.shared.delegate!.window{
        window!.rootViewController = viewController
    }
}

// MARK:- Styling Methods

func setTextFieldStyle(txtFields:[UITextField]){
    
    for txtField in txtFields {
        
        txtField.layer.borderColor = UIColorFromRGB(rgbValue: 0xE5E5E5).cgColor
        txtField.layer.borderWidth = 1
        txtField.layer.cornerRadius = 20
        txtField.clipsToBounds = true
        txtField.backgroundColor = UIColor.clear
        //txtField.textColor = UIColor.white
        txtField.font = UIFont(name: "Roboto-Light", size: 14.0)
        
//        let paddingView = UIView(frame: CGRectMake(0, 0, 0, txtField.frame.height))
//        txtField.leftView = paddingView
//        txtField.leftViewMode = UITextFieldViewMode.Always
        
        //txtField.attributedPlaceholder = NSAttributedString(string: txtField.placeholder!,attributes:[NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6)])
    }
}

func setTextFieldLeftImage(txtField:UITextField, imgName:String)  {
    
    let imgView = UIImageView(image: UIImage(named: imgName))
    imgView.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 15);
    imgView.contentMode = .scaleAspectFit;
    txtField.leftView = imgView
    txtField.leftViewMode = UITextField.ViewMode.always
}

func setTextFieldRightImage(txtField:UITextField, imgName:String)  {
    
    let imgView = UIImageView(image: UIImage(named: imgName))
    imgView.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 10);
    imgView.contentMode = .scaleAspectFit;
    txtField.rightView = imgView
    txtField.rightViewMode = UITextField.ViewMode.always
}

func setTextFieldRightImage2(txtField:UITextField, imgName:String)  {
    
    let imgView = UIImageView(image: UIImage(named: imgName))
    imgView.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 15);
    imgView.contentMode = .scaleAspectFit;
    txtField.rightView = imgView
    txtField.rightViewMode = UITextField.ViewMode.always
}

func setButtonNormalStyle(buttons:[UIButton], cornerRadius:CGFloat){
    
    for btn in buttons {
        
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = cornerRadius
        //btn.backgroundColor = UIColor.red
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Roboto-Regular", size: (btn.titleLabel?.font?.pointSize)!)
    }
}

func setButtonRemoveStyle(buttons:[UIButton]){
    
    for btn in buttons {
        
        btn.layer.borderColor = UIColor.clear.cgColor
        btn.layer.borderWidth = 0
    }
}

func setButtonFilledStyle(buttons:[UIButton]){
    
    for btn in buttons {
        
        btn.layer.borderColor = UIColor.clear.cgColor
        btn.layer.borderWidth = 0
        //btn.backgroundColor = themeColor
        btn.layer.cornerRadius = cornerRadius
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: (btn.titleLabel?.font?.pointSize)!)
    }
}

func setViewOutlineStyle(views:[UIView], clearColor:Bool){
    
    for view in views {
        
        view.layer.borderColor = UIColorFromRGB(rgbValue: 0xE5E5E5).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        
        if clearColor{
            view.backgroundColor = UIColor.clear
        }
    }
}

func setViewFilledStyle(views:[UIView]){
    
    for view in views {
        
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.backgroundColor = themeColor
    }
}

func setNavigationBarStyle(navigationBar:UINavigationBar, imageName:String){
    
    navigationBar.isHidden = false
    //navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    //navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
    navigationBar.setBackgroundImage(UIImage(named: imageName), for: .default)
    navigationBar.tintColor = UIColor.white
    navigationBar.titleTextAttributes = [
        NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 17)!,
        NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    //view.backgroundColor = UIColor.clearColor()
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

