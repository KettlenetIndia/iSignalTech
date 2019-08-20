//
//  ForgotPasswordViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 03/06/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import MBProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var otpHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var isOTP:Bool = false
    var generatedOTP:String!
    
    var keyboardIsShown:Bool = false
    var keyboardFrame: CGRect!
    var lastDifference: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldStyle(txtFields: [emailTextField,newPasswordTextField,otpTextField])
        setButtonNormalStyle(buttons: [submitBtn], cornerRadius: 20)
        setTextFieldLeftImage(txtField: emailTextField, imgName: "email_icon")
        setTextFieldLeftImage(txtField: newPasswordTextField, imgName: "password_icon")
        setTextFieldLeftImage(txtField: otpTextField, imgName: "password_icon")
        }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
    
        if isOTP{
            
            if newPasswordTextField.text == "" {
                _ = showRequiredAlert(msg: "New Password")
                return
            }else if (newPasswordTextField.text?.length)! <= 4{
                _ = showRequiredAlert(msg: "Password must be 5 charecter long")
                return
            }else if otpTextField.text == "" {
                _ = showRequiredAlert(msg: "Verfification code")
                return
            }
            else if otpTextField.text?.caseInsensitiveCompare(generatedOTP) != .orderedSame{
                showAlert(title: "Incorrect verfification code", message: "Your verfification code is incorrect. Please try again.", buttonText: "OK")
                return
            }
            
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.detailsLabel.text = "Loading"
            
            ISNetworkManager.shred.resetPassword(email: emailTextField.text!, password: newPasswordTextField.text!, completion: { (success) in
                if success{
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else{
            
            if emailTextField.text == "" {
                _ = showRequiredAlert(msg: "Please enter email")
                return
            }else if !((emailTextField.text?.isEmail)!){
                _ = showRequiredAlert(msg: "Please enter valid email")
                return
            }
            
            
            generatedOTP = randomString(length: 5)
            
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.detailsLabel.text = "Loading"
            ISNetworkManager.shred.forgotPassword(email: emailTextField.text!, code: generatedOTP, completion: { (success) in
                if success{
                    
                    UIView.animate(withDuration: 0.3, animations: { 
                        
                        self.emailTextField.isEnabled = false
                        self.emailTextField.alpha = 0.6
                        
                        self.otpHeightConstraint.constant = 100
                        self.view.layoutIfNeeded()
                    })
                    self.isOTP = true
                    
                    let alert = UIAlertController(title: "iSignal Tech", message: "Verification code has been sent to your registered email.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.presentVC(alert)
                }
            })
            
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Keyboard Methods
    func keyboardWillHide(_ notification : NSNotification){
        
        if !keyboardIsShown {
            return;
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            
            self.view.frame.origin.y += self.lastDifference
        })
        
        keyboardIsShown = false;
    }
    
    func keyboardWillShow(_ notification : NSNotification){
        
        if keyboardIsShown {
            return;
        }
        
        var info = notification.userInfo!
        keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let textField:UITextField? = self.getFirstResponderTextFields()
        
        if textField != nil{
            
            let frame:CGRect = (textField!.superview?.convert(textField!.frame, to: self.view))!
            
            if frame.origin.y + frame.size.height > self.view.frame.size.height - keyboardFrame.height{
                
                lastDifference = (frame.origin.y + frame.size.height) - (self.view.frame.size.height - self.keyboardFrame.height) + 20
                
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= self.lastDifference
                })
            }else{
                lastDifference = 0
            }
            
            keyboardIsShown = true;
        }
    }
    
    func getFirstResponderTextFields() -> UITextField?{
        
        if emailTextField.isFirstResponder{ return emailTextField }
        else if newPasswordTextField.isFirstResponder{ return newPasswordTextField }
        else if otpTextField.isFirstResponder{ return otpTextField }
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
