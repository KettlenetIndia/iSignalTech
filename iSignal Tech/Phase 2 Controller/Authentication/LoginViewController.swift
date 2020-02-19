//
//  LoginViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 28/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import MBProgressHUD
import ObjectMapper

import GoogleSignIn

class LoginViewController: UIViewController, writeValueBackDelegate{ //}, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var regmainbtm2: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var registerbtm: NSLayoutConstraint!
    
    @IBOutlet weak var logintopspace: NSLayoutConstraint!
    @IBOutlet weak var topmargin: NSLayoutConstraint!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPassTextField: UITextField!
    @IBOutlet weak var loginSubmitBtn: UIButton!
    @IBOutlet weak var loginPointer: UIImageView!
    @IBOutlet weak var loginMainView: UIView!
    
    @IBOutlet weak var registerNameTextField: UITextField!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPassTextField: UITextField!
    @IBOutlet weak var registerMobileTextField: UITextField!
    @IBOutlet weak var registerCountryTextField: UITextField!
    @IBOutlet weak var registerStateTextField: UITextField!
    @IBOutlet weak var registerPinTextField: UITextField!
    @IBOutlet weak var registerPinHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerNewsletterBtn: UIButton!
    @IBOutlet weak var registerNewsletterLabel: UILabel!
    @IBOutlet weak var registerSubmitBtn: UIButton!
    @IBOutlet weak var registerPointer: UIImageView!
    @IBOutlet weak var registerMainView: UIView!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    
    @IBOutlet weak var loginBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerBottomConstraint: NSLayoutConstraint!
    
    var selectedCoutnry:Country! = nil
    var selectedState:State! = nil
    
    var keyboardIsShown:Bool = false
    var keyboardFrame: CGRect!
    var lastDifference: CGFloat = 0.0
    
    var name:String!
    var uid:String!
    var fname:String!
    var lname:String!
    var photoLink:String!
    var email:String!
    
    var isOTP:Bool = false
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitialSetup()
        self.setupLayout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
        
    }
    
    private func InitialSetup(){
    }
    
    private func setupLayout(){
        
//        #if DEBUG
//            loginEmailTextField.text = "poojaeorchids@gmail.com"
//            loginPassTextField.text = "Sample123"
//        #endif
        
//        var deviceType: String = UIDevice().type.rawValue
//        print("Running on: \(deviceType)")
//        if deviceType == "iPhone XR"{
//          topmargin.priority = UILayoutPriority(rawValue: 5)
//          logintopspace.priority = UILayoutPriority(rawValue: 5)
//        }else  if deviceType  == "iPhone XS Max"{
//        topmargin.priority = UILayoutPriority(rawValue: 5)
//        }else  if deviceType  == "iPhone XS"{
//           topmargin.priority = UILayoutPriority(rawValue: 5)
//        }else  if deviceType  == "iPhone X"{
//        topmargin.priority = UILayoutPriority(rawValue: 5)
//        }else{
//      topmargin.priority = UILayoutPriority(rawValue: 15)
//             logintopspace.priority = UILayoutPriority(rawValue: 15)
//        }

        setTextFieldStyle(txtFields: [loginEmailTextField,loginPassTextField,registerNameTextField,registerEmailTextField,registerPassTextField,registerMobileTextField,registerCountryTextField,registerStateTextField,registerPinTextField])
        setButtonNormalStyle(buttons: [loginSubmitBtn, registerSubmitBtn, facebookBtn, googleBtn], cornerRadius: 20)
        setTextFieldLeftImage(txtField: loginEmailTextField, imgName: "email_icon")
        setTextFieldLeftImage(txtField: loginPassTextField, imgName: "password_icon")
        setTextFieldLeftImage(txtField: registerNameTextField, imgName: "name_icon")
        setTextFieldLeftImage(txtField: registerEmailTextField, imgName: "email_icon")
        setTextFieldLeftImage(txtField: registerPassTextField, imgName: "password_icon")
        setTextFieldLeftImage(txtField: registerMobileTextField, imgName: "mobile_icon")
        setTextFieldLeftImage(txtField: registerCountryTextField, imgName: "country_icon")
        setTextFieldLeftImage(txtField: registerStateTextField, imgName: "state_icon")
        setTextFieldLeftImage(txtField: registerPinTextField, imgName: "password_icon")
        setTextFieldRightImage(txtField: registerCountryTextField, imgName: "arrow")
        setTextFieldRightImage(txtField: registerStateTextField, imgName: "arrow")
        
      //  addDoneButtonOnKeyboard(textFields: [registerMobileTextField, registerPinTextField], textViews: nil, target: self)
        
    }


    
    @IBAction func loginButtonsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 0{ //Login
            
            self.setEditing(false, animated: true)
            let error = loginValidate()
            if  error == ""{
                progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
                progressHUD.detailsLabel.text = "Logging In"
                
                ISNetworkManager.shred.loginWithEmail(email: loginEmailTextField.text!, password: loginPassTextField.text!, completion: { (isSuccess, response) in
                    
                    if response?.status == true{
                        user = (response?.userDetail)!
                        let strUserDetail = response?.userDetail?.toJSONString()
                        userDefaults.set(strUserDetail, forKey: getUserObjectKey)
                        userDefaults.set(true, forKey: getLoggedInKey)
                        userDefaults.synchronize()
                        AppDelegate.shared.moveToDashboard()
                    }else{
                        progressHUD.hide(animated: true)
                        if let message = response?.error{
                            showAlert(title: "Login Failed", message: message, buttonText: "OK")
                        }else{
                            showAlert(title: "Login Failed", message: "There was some error while logging in. Please try again.", buttonText: "OK")
                        }
                    }
                })
            }else{
                showAlert(title: "Required Field", message: error, buttonText: "OK")
            }
            
            
        }
        else if sender.tag == 1{ //Forgot Password
            
            let viewController:ForgotPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    private func loginValidate() -> String{
        if loginEmailTextField.text == ""{
            return "Please enter email"
        }else if !((loginEmailTextField.text?.isEmail)!){
            return "Please enter valid email"
        }else if loginPassTextField.text == ""{
            return "Please enter password"
        }else if (loginPassTextField.text?.length)! <= 4{
            return "Password must be 5 charecter long"
        }else{
            return ""
        }
    }
    
    
    
    
    @IBAction func registerButtonsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 0{
            
            if isOTP{
                
                self.setEditing(false, animated: true)
                if registerPinTextField.text != ""{
                    progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
                    progressHUD.detailsLabel.text = "Verifying"
                    ISNetworkManager.shred.activateUserAccount(userId: String(user.id!), otp: registerPinTextField.text!, completion: { (success) in
                        
                        if success{
                            
                            self.enableDisableForm(enable: true)
                            
                            self.registerNameTextField.text = ""
                            self.registerEmailTextField.text = ""
                            self.registerPassTextField.text = ""
                            self.registerMobileTextField.text = ""
                            self.registerCountryTextField.text = ""
                            self.registerStateTextField.text = ""
                            self.registerNewsletterBtn.isSelected = false
                            self.registerPinHeightConstraint.constant = 0
                            
                            let btn:UIButton = UIButton()
                            btn.tag = 0
                            self.tabButtonPressed(btn)
                        }
                    })
                }else{
                    showAlert(title: "Required Field", message: "Enter OTP code", buttonText: "OK")
                }
            }else{
                
                self.setEditing(false, animated: true)
                let error = signupValidate()
                if  error == ""{
                    progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
                    progressHUD.detailsLabel.text = "Registering"
                    
                    let email = registerEmailTextField.text?.trimmingCharacters(in: .whitespaces)
                    
                    ISNetworkManager.shred.registerUserWith(name: registerNameTextField.text!, email: email!, password: registerPassTextField.text!, phoneNo: registerMobileTextField.text!, countryId: selectedCoutnry.id, stateId: selectedState.id, socialId: "0", socialNetwork: "0", newsletter: (registerNewsletterBtn.isSelected) ? "1" : "0") { (success) in
                        
                        if success{
                            if self.selectedCoutnry.id == "101"{
                                showAlert(title: "OTP", message: "Please enter the OTP sent to you through SMS.", buttonText: "OK")
                                
                                self.enableDisableForm(enable: false)
                                
                                self.isOTP = true
                                
                                UIView.animate(withDuration: 0.3, animations: {
                                    
                                    self.registerPinHeightConstraint.constant = 60
                                    self.view.layoutIfNeeded()
                                })
                                
                            }else{
                                
                                self.enableDisableForm(enable: true)
                                
                                self.registerNameTextField.text = ""
                                self.registerEmailTextField.text = ""
                                self.registerPassTextField.text = ""
                                self.registerMobileTextField.text = ""
                                self.registerCountryTextField.text = ""
                                self.registerStateTextField.text = ""
                                self.registerNewsletterBtn.isSelected = false
                                self.registerPinHeightConstraint.constant = 0
                                
                                self.isOTP = false
                                
                                let btn:UIButton = UIButton()
                                btn.tag = 0
                                self.tabButtonPressed(btn)
                            }
                        }
                    }
                }else{
                    showAlert(title: "Required Field", message: error, buttonText: "OK")
                }
            }
        }
        else if sender.tag == 1{
            
            if isOTP{ return }
            
            let viewController:popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "popupViewController") as! popupViewController
            viewController.dataset = countriesData as NSArray
            viewController.dataType = "Countries"
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }
        else if sender.tag == 2{
            
            if isOTP{ return }
            
            if selectedCoutnry == nil{
                showAlert(title: "Country Required", message: "Please select a country first.", buttonText: "OK")
                return
            }
            
            let viewController:popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "popupViewController") as! popupViewController
            viewController.dataset = selectedCoutnry.states as NSArray
            viewController.dataType = "States"
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }
        else if sender.tag == 3{
            registerNewsletterBtn.isSelected = !registerNewsletterBtn.isSelected
        }
    }
    
    
    
    private func signupValidate() -> String{
        if registerNameTextField.text == ""{
            return "Please enter name"
        }else if registerEmailTextField.text == ""{
            return "Please enter email"
        }else if !((registerEmailTextField.text?.isEmail)!){
            return "Please enter valid email"
        }else if registerPassTextField.text == ""{
            return "Please enter password"
        }else if (registerPassTextField.text?.length)! <= 4{
            return "Your password must be minimum 5 characters"
        }else if registerMobileTextField.text == ""{
            return "Please eneter mobile number"
        }else if (registerMobileTextField.text?.length)! <= 7{
            return "Please enter the valid mobile number"
        }else if registerCountryTextField.text == ""{
            return "Please select country"
        }else if registerStateTextField.text == ""{
            return "Please select state"
        }else{
            return ""
        }
    }
    
    
    
    @IBAction func socialLoginBtnsPressed(_ sender: UIButton) {
        
        //        if sender.tag == 0{
        //
        //            let loginManager = FBSDKLoginManager()
        //
        //            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        //            progressHUD.detailsLabel.text = "Connecting"
        //
        //            loginManager.logIn(withReadPermissions:["public_profile","email"], from: self) {
        //                loginResult,error in
        //
        //                if ((error) != nil){
        //
        //                    print(error)
        //                    progressHUD.hide(animated: true)
        //                }
        //                else if (loginResult?.isCancelled)! {
        //
        //                    print("User cancelled login.")
        //                    progressHUD.hide(animated: true)
        //                }
        //                else {
        //
        //                    print("Logged in!")
        //                    self.facebookProfileFetched()
        //                }
        //            }
        //        }
        //        else if sender.tag == 1 {
        //
        //            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        //            progressHUD.detailsLabel.text = "Connecting"
        //            GIDSignIn.sharedInstance().signIn()
        //        }
    }
    
    @IBAction func tabButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 0{ //loginview
            
            loginPointer.isHidden = false
            registerPointer.isHidden = true
            loginBottomConstraint.priority = UILayoutPriority(rawValue: 750)
            registerBottomConstraint.priority = UILayoutPriority(rawValue: 250)
            
            self.view.layoutIfNeeded()
            
            //UIView.animate(withDuration: 0.3, animations: {
            
            self.loginMainView.alpha = 1
            self.registerMainView.alpha = 0
            
            self.view.layoutIfNeeded()
            //})
            
        }
        else{ //registerview
            
            loginPointer.isHidden = true
            registerPointer.isHidden = false
            loginBottomConstraint.priority = UILayoutPriority(rawValue: 250)
            registerBottomConstraint.priority = UILayoutPriority(rawValue: 750)
            
            self.view.layoutIfNeeded()
            
            //UIView.animate(withDuration: 0.3, animations: {
            
            self.loginMainView.alpha = 0
            self.registerMainView.alpha = 1
            
            self.view.layoutIfNeeded()
            //})
            
            setupCountriesAndCities(view: self.view)
        }
    }
    
    //    func validateForm(forLogin:Bool) -> Bool{
    //
    //        if forLogin{
    //            if loginEmailTextField == nil { return showRequiredAlert(msg: "Email") }
    //            else if loginPassTextField.text == "" { return showRequiredAlert(msg: "Password") }
    //            else { return true }
    //        }
    //        else{
    //            if registerNameTextField == nil { return showRequiredAlert(msg: "Name") }
    //            else if registerEmailTextField.text == "" { return showRequiredAlert(msg: "Email") }
    //            else if registerPassTextField.text == "" { return showRequiredAlert(msg: "Password") }
    //            else if registerMobileTextField.text == "" && selectedCoutnry.id == "101" { return showRequiredAlert(msg: "Mobile number") }
    //            else if registerCountryTextField.text == "" { return showRequiredAlert(msg: "Country") }
    //            else if registerStateTextField.text == "" { return showRequiredAlert(msg: "State") }
    //            else { return true }
    //        }
    //    }
    
    func enableDisableForm(enable:Bool){
        
        if enable{
            self.registerNameTextField.alpha = 1
            self.registerEmailTextField.alpha = 1
            self.registerPassTextField.alpha = 1
            self.registerMobileTextField.alpha = 1
            self.registerCountryTextField.alpha = 1
            self.registerStateTextField.alpha = 1
            self.registerNewsletterBtn.alpha = 1
            self.registerNewsletterLabel.alpha = 1
            self.registerNameTextField.isEnabled = true
            self.registerEmailTextField.isEnabled = true
            self.registerPassTextField.isEnabled = true
            self.registerMobileTextField.isEnabled = true
            self.registerCountryTextField.isEnabled = true
            self.registerStateTextField.isEnabled = true
            self.registerNewsletterBtn.isEnabled = true
        }
        else{
            self.registerNameTextField.alpha = 0.6
            self.registerEmailTextField.alpha = 0.6
            self.registerPassTextField.alpha = 0.6
            self.registerMobileTextField.alpha = 0.6
            self.registerCountryTextField.alpha = 0.6
            self.registerStateTextField.alpha = 0.6
            self.registerNewsletterBtn.alpha = 0.6
            self.registerNewsletterLabel.alpha = 0.6
            self.registerNameTextField.isEnabled = false
            self.registerEmailTextField.isEnabled = false
            self.registerPassTextField.isEnabled = false
            self.registerMobileTextField.isEnabled = false
            self.registerCountryTextField.isEnabled = false
            self.registerStateTextField.isEnabled = false
            self.registerNewsletterBtn.isEnabled = false
        }
    }
    
    
    //Navigation to Home screen
    //    private func moveToDashboard(){
    //        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ISEnterNavigationController")
    //        if let window =  UIApplication.shared.delegate!.window{
    //            window!.rootViewController = viewController
    //        }
    //    }
    
    
    func scheduleOffersFetch(){
        ISNetworkManager.shred.getActiveBeaconsAndOffers(completion: { (success) in })
    }
    
    func setCountry(value: Country) {
        if selectedCoutnry != nil && value.id != selectedCoutnry.id{
            registerStateTextField.text = ""
            selectedState = nil
        }
        
        selectedCoutnry = value
        registerCountryTextField.text = value.name
    }
    
    func setState(value: State){
        
        selectedState = value
        registerStateTextField.text = value.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    //MARK:- Social Login Callback Methods
    //
    //    //MARK: Facebook
    //
    //    func facebookProfileFetched() {
    //
    //        if FBSDKAccessToken.current() != nil{
    //
    //            if FBSDKProfile.current() != nil{
    //
    //                self.name = FBSDKProfile.current().name
    //                self.uid = FBSDKProfile.current().userID
    //                self.fname = FBSDKProfile.current().firstName
    //                self.lname = FBSDKProfile.current().lastName
    //                self.photoLink = FBSDKProfile.current().imageURL(for: FBSDKProfilePictureMode.square, size: CGSize(width: 400,height: 400)).absoluteString
    //
    //                print(name)
    //                print(uid)
    //                print(fname)
    //                print(lname)
    //                print(photoLink)
    //
    //                self.getFacebookEmail()
    //            }
    //            else{
    //
    //                progressHUD.hide(animated: true)
    //                showAlert(title: "Facebook Login", message: "Could not connect at this time. Please try again.", buttonText: "OK")
    //            }
    //        }
    //        else {
    //
    //            print("logged out")
    //        }
    //    }
    //
    //    func getFacebookEmail(){
    //        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields": "email"], httpMethod: "GET")
    //        graphRequest.start(completionHandler: { (connection, result, error) in
    //
    //            if ((error) != nil){
    //                print("Error: \(error)")
    //            }
    //            else{
    //
    //                guard let data = result as? [String:Any] else { return }
    //
    //                if let userEmail = data["email"]{
    //
    //                    self.email = userEmail as! String
    //                    print(self.email)
    //                    progressHUD.hide(animated: true)
    //
    //                    progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    //                    progressHUD.detailsLabel.text = "Logging in"
    //                    NetworkOperations.sharedInstance.socialLoginUser(name: self.name, email: self.email, socialNetwork: "1", socialId: self.uid, completion: { (success) in
    //
    //                        if success{
    //
    //                            self.getActiveBeacons()
    //                        }
    //                    })
    //
    //                }
    //                else{
    //                    showAlert(title: "Email Not Found", message: "There was some error getting your email from facebook. Make sure you have allowed the permissions for Smart Learner.", buttonText: "OK")
    //                }
    //            }
    //        })
    //    }
    //
    //    //MARK: Google
    //
    //    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    //
    //    }
    //
    //    func sign(_ signIn: GIDSignIn!,
    //              present viewController: UIViewController!) {
    //        self.present(viewController, animated: true, completion: nil)
    //    }
    //
    //    func sign(_ signIn: GIDSignIn!,
    //              dismiss viewController: UIViewController!) {
    //        self.dismiss(animated: true, completion: nil)
    //    }
    //
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    //
    //        if (error == nil) {
    //            // Perform any operations on signed in user here.
    //            //let idToken = user.authentication.idToken // Safe to send to the server
    //            uid = user.userID                  // For client-side use only!
    //            name = user.profile.name
    //            fname = user.profile.givenName
    //            lname = user.profile.familyName
    //            email = user.profile.email
    //
    //            if user.profile.hasImage {
    //                let photoURL = user.profile.imageURL(withDimension: 100)
    //                photoLink = photoURL?.absoluteString
    //            }
    //
    //            print(uid)
    //            print(name)
    //            print(fname)
    //            print(lname)
    //            print(email)
    //            print(photoLink)
    //
    //            progressHUD.hide(animated: true)
    //
    //            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    //            progressHUD.detailsLabel.text = "Logging in"
    //            NetworkOperations.sharedInstance.socialLoginUser(name: self.name, email: self.email, socialNetwork: "2", socialId: self.uid, completion: { (success) in
    //
    //                if success{
    //
    //                    self.getActiveBeacons()
    //                }
    //            })
    //
    //
    //        } else {
    //            print("\(error.localizedDescription)")
    //            progressHUD.hide(animated: true)
    //            showAlert(title: "Google Login", message: "Could not connect at this time. Please try again.", buttonText: "OK")
    //        }
    //    }
    //
    //    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    //
    //    }
    
    //    //MARK:- Keyboard Methods
    //    func keyboardWillHide(_ notification : NSNotification){
    //
    //        if !keyboardIsShown {
    //            return;
    //        }
    //
    //        UIView.animate(withDuration: 0.1, animations: { () -> Void in
    //
    //            self.view.frame.origin.y += self.lastDifference
    //        })
    //
    //        keyboardIsShown = false;
    //    }
    //
    //    func keyboardWillShow(_ notification : NSNotification){
    //
    //        if keyboardIsShown {
    //            return;
    //        }
    //
    //        var info = notification.userInfo!
    //        keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    //
    //        let textField:UITextField? = self.getFirstResponderTextFields()
    //
    //        if textField != nil{
    //
    //            let frame:CGRect = (textField!.superview?.convert(textField!.frame, to: self.view))!
    //
    //            if frame.origin.y + frame.size.height > self.view.frame.size.height - keyboardFrame.height{
    //
    //                lastDifference = (frame.origin.y + frame.size.height) - (self.view.frame.size.height - self.keyboardFrame.height) + 20
    //
    //                UIView.animate(withDuration: 0.1, animations: { () -> Void in
    //                    self.view.frame.origin.y -= self.lastDifference
    //                })
    //            }
    //            else{
    //                lastDifference = 0
    //            }
    //
    //            keyboardIsShown = true;
    //        }
    //    }
    
    func getFirstResponderTextFields() -> UITextField?{
        
        if registerNameTextField.isFirstResponder{ return registerNameTextField }
        else if registerMobileTextField.isFirstResponder{ return registerMobileTextField }
        else if registerEmailTextField.isFirstResponder{ return registerEmailTextField }
        else if registerPassTextField.isFirstResponder{ return registerPassTextField }
        else if loginEmailTextField.isFirstResponder{ return registerNameTextField }
        else if loginPassTextField.isFirstResponder{ return registerNameTextField }
        else if registerPinTextField.isFirstResponder{ return registerPinTextField }
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        return false;
    }
    
    func doneButtonAction(){
        
        self.view.endEditing(true)
    }
}

protocol writeValueBackDelegate {
    
    func setCountry(value: Country)
    func setState(value: State)
}
public extension UIDevice {
    public enum Model : String {
        
        //Simulator
        case simulator     = "simulator/sandbox",
        
        //iPod
        iPod1              = "iPod 1",
        iPod2              = "iPod 2",
        iPod3              = "iPod 3",
        iPod4              = "iPod 4",
        iPod5              = "iPod 5",
        
        //iPad
        iPad2              = "iPad 2",
        iPad3              = "iPad 3",
        iPad4              = "iPad 4",
        iPadAir            = "iPad Air ",
        iPadAir2           = "iPad Air 2",
        iPadAir3           = "iPad Air 3",
        iPad5              = "iPad 5", //iPad 2017
        iPad6              = "iPad 6", //iPad 2018
        
        //iPad Mini
        iPadMini           = "iPad Mini",
        iPadMini2          = "iPad Mini 2",
        iPadMini3          = "iPad Mini 3",
        iPadMini4          = "iPad Mini 4",
        iPadMini5          = "iPad Mini 5",
        
        //iPad Pro
        iPadPro9_7         = "iPad Pro 9.7\"",
        iPadPro10_5        = "iPad Pro 10.5\"",
        iPadPro11          = "iPad Pro 11\"",
        iPadPro12_9        = "iPad Pro 12.9\"",
        iPadPro2_12_9      = "iPad Pro 2 12.9\"",
        iPadPro3_12_9      = "iPad Pro 3 12.9\"",
        
        //iPhone
        iPhone4            = "iPhone 4",
        iPhone4S           = "iPhone 4S",
        iPhone5            = "iPhone 5",
        iPhone5S           = "iPhone 5S",
        iPhone5C           = "iPhone 5C",
        iPhone6            = "iPhone 6",
        iPhone6Plus        = "iPhone 6 Plus",
        iPhone6S           = "iPhone 6S",
        iPhone6SPlus       = "iPhone 6S Plus",
        iPhoneSE           = "iPhone SE",
        iPhone7            = "iPhone 7",
        iPhone7Plus        = "iPhone 7 Plus",
        iPhone8            = "iPhone 8",
        iPhone8Plus        = "iPhone 8 Plus",
        iPhoneX            = "iPhone X",
        iPhoneXS           = "iPhone XS",
        iPhoneXSMax        = "iPhone XS Max",
        iPhoneXR           = "iPhone XR",
        
        //Apple TV
        AppleTV            = "Apple TV",
        AppleTV_4K         = "Apple TV 4K",
        unrecognized       = "?unrecognized?"
    }
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        var modelMap : [String: Model] = [
            
            //Simulator
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //iPad 2018
            "iPad7,6"   : .iPad6,
            
            //iPad Mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,
            
            //iPad Pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,
            
            //iPad Air
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,
            
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            
            //Apple TV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}
