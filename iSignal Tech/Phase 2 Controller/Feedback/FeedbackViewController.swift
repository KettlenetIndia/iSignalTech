//
//  FeedbackViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 27/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import MBProgressHUD

class FeedbackViewController: UIViewController{

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var keyboardIsShown:Bool = false
    var keyboardFrame: CGRect!
    var lastDifference: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.InitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FeedbackViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FeedbackViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupViews(){
        
        setTextFieldStyle(txtFields: [nameTextField,emailTextField,mobileTextField,subjectTextField])
        setViewOutlineStyle(views: [messageView], clearColor: true)
        setTextFieldLeftImage(txtField: nameTextField, imgName: "name_icon")
        setTextFieldLeftImage(txtField: emailTextField, imgName: "email_icon")
        setTextFieldLeftImage(txtField: mobileTextField, imgName: "mobile_icon")
        setTextFieldLeftImage(txtField: subjectTextField, imgName: "subject_icon")
        setButtonNormalStyle(buttons: [submitBtn], cornerRadius: 20)
        
      //  addDoneButtonOnKeyboard(textFields: [mobileTextField], textViews: [messageTextView], target: self)

        messageTextView.text = "Your Message"
        messageTextView.textColor = UIColor.lightGray
    }
    
    
    private func InitialSetup(){
        nameTextField.text = user.name ?? ""
        emailTextField.text = user.email ?? ""
        mobileTextField.text = user.phone_no ?? ""
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        let error = validateForm()
        if error == ""{
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.detailsLabel.text = "Submitting Feedback"
            ISNetworkManager.shred.submitFeedback(name: nameTextField.text!, email: emailTextField.text!, mobile: mobileTextField.text!, subject: subjectTextField.text!, message: messageTextView.text!) { (success) in
                
                if success {
                    
                    self.nameTextField.text = ""
                    self.emailTextField.text = ""
                    self.mobileTextField.text = ""
                    self.subjectTextField.text = ""
                    self.messageTextView.text = ""
                }
            }
        }else{
            showAlert(title: "Required Field", message: error, buttonText: "OK")
        }
        
        
    }
    
    func validateForm() -> String{
        
        if nameTextField.text == "" {
            return "Please enter name"
        }else if emailTextField.text == "" {
            return "Please enter email "
        }else if !((emailTextField.text?.isEmail)!){
            return "Please enter valid email"
        }else if mobileTextField.text == "" {
            return "Please enter Mobile number"
        }else if (mobileTextField.text?.length)! <= 7{
                return "Mobile number must be 8 charecter long"
        }else if subjectTextField.text == "" {
            return "Please enter subject"
        }else if messageTextView.text == "" {
            return "Please write some message"
        }else{
            return ""
        }
    }

    @IBAction func btnActionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        showDrawerMenu(this: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Keyboard Methods
    @objc func keyboardWillHide(_ notification : NSNotification){
        
        if !keyboardIsShown {
            return;
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            
            self.view.frame.origin.y += self.lastDifference
        })
        
        keyboardIsShown = false;
    }
    
    @objc func keyboardWillShow(_ notification : NSNotification){
        
        if keyboardIsShown {
            return;
        }
        
        var info = notification.userInfo!
        keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var frame:CGRect = .zero
        
        if messageTextView.isFirstResponder{
            
            if messageTextView != nil {
                
                frame = (messageTextView!.superview?.convert(messageTextView!.frame, to: self.view))!
            }
            else{
                return
            }
        }
        else{
            
            let textField:UITextField? = self.getFirstResponderTextFields()
            
            if textField != nil {
                
                frame = (textField!.superview?.convert(textField!.frame, to: self.view))!
            }
            else{
                return
            }
        }
        
        if frame.origin.y + frame.size.height > self.view.frame.size.height - keyboardFrame.height{
            
            lastDifference = (frame.origin.y + frame.size.height) - (self.view.frame.size.height - self.keyboardFrame.height) + 20
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y -= self.lastDifference
            })
        }
        else{
            lastDifference = 0
        }
        
        keyboardIsShown = true;
    }
    
    func getFirstResponderTextFields() -> UITextField?{
        
        if nameTextField.isFirstResponder{ return nameTextField }
        else if emailTextField.isFirstResponder{ return emailTextField }
        else if mobileTextField.isFirstResponder{ return mobileTextField }
        else if subjectTextField.isFirstResponder{ return subjectTextField }
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
 
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your Message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func doneButtonAction(){

        self.view.endEditing(true)
    }
}
