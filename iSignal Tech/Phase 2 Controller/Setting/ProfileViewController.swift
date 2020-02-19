//
//  ProfileViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 27/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class ProfileViewController: UIViewController, writeValueBackDelegate {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var newsletterBtn: UIButton!
    @IBOutlet weak var profilebtn: UIButton!

    var keyboardIsShown:Bool = false
    var keyboardFrame: CGRect!
    var lastDifference: CGFloat = 0.0
    
    var selectedCoutnry:Country! = nil
    var selectedState:State! = nil
    var updatedUser:UserDetail!
    
    var picker:UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        setupViews()
        prefillData()
        
        picker.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if user.photo != "" {

            let photo:String = (user.photo!.contains(IMAGE_BASE_URL)) ? user.photo! : IMAGE_BASE_URL+user.photo!

            userPhoto.layer.cornerRadius = userPhoto.frame.size.height/2
            userPhoto.clipsToBounds = true
            userPhoto.layer.borderColor = UIColor.white.cgColor
            userPhoto.layer.borderWidth = 2

           // userPhoto.sd_setShowActivityIndicatorView(true)
          //  userPhoto.sd_setIndicatorStyle(.white)
            userPhoto.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "top_logo_white"))
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupViews(){
        
        setTextFieldRightImage2(txtField: nameTextField, imgName: "name_icon")
        setTextFieldRightImage2(txtField: passwordTextField, imgName: "password_icon")
        setTextFieldRightImage2(txtField: mobileTextField, imgName: "mobile_icon")
        setTextFieldRightImage2(txtField: emailTextField, imgName: "email_icon")
        setTextFieldRightImage2(txtField: countryTextField, imgName: "country_icon")
        setTextFieldRightImage2(txtField: stateTextField, imgName: "state_icon")
        setButtonNormalStyle(buttons: [updateBtn], cornerRadius: 20)
    }
    
    func prefillData(){
        
        nameTextField.text = user.name!
        emailTextField.text = user.email!
        mobileTextField.text = user.phone_no
        
        selectedCoutnry = getCountry(countryId: user.country_id!)
        if selectedCoutnry != nil {
            selectedState = getState(stateId: user.state_id!)
            
            countryTextField.text = selectedCoutnry.name
            
            if selectedState != nil{
                stateTextField.text = selectedState.name
            }
        }
        
        newsletterBtn.isSelected = (user.newsletter == "1") ? true : false
        
        updatedUser = user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imagePickerTapped(_ sender: UIButton) {
        
        let actionSheet: UIAlertController = UIAlertController(title: "", message: "Option to select", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Take Photo", style: .default){ _ in
            print("Take Photo")
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                self.picker.allowsEditing = true
                self.picker.sourceType = .camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                
             
                
                self.present(self.picker,animated: true,completion: nil)
            }
            else{
                return
            }
        }
        actionSheet.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Choose From Gallery", style: .default){ _ in
            print("Choose From Gallery")
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }
        
//        UIPopoverPresentationController *presentationController = [controller popoverPresentationController];
//        presentationController.sourceView = self.view;
//        presentationController.sourceRect = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
//        presentationController.permittedArrowDirections = 0;
        
        let presentationController = actionSheet.popoverPresentationController
        
        if presentationController != nil
        {
            presentationController!.sourceView = self.view
            presentationController!.sourceRect = CGRect(x: self.view.center.x, y:profilebtn.frame.origin.y+profilebtn.frame.size.height, w: 0, h: 0)
            presentationController!.permittedArrowDirections = UIPopoverArrowDirection.up
        }
        
        
        actionSheet.addAction(deleteActionButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func optionBtnPressed(_ sender: UIButton) {
        
        if sender.tag == 0{
            
            let viewController:popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "popupViewController") as! popupViewController
            viewController.dataset = countriesData as NSArray
            viewController.dataType = "Countries"
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }
        else if sender.tag == 1{
            
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
        else if sender.tag == 2{
            //Newsletter
            newsletterBtn.isSelected = !newsletterBtn.isSelected
        }
    }
    
    func setCountry(value: Country) {
        
        if value.id != selectedCoutnry.id{
            stateTextField.text = ""
            selectedState = nil
        }
        
        selectedCoutnry = value
        countryTextField.text = value.name
        
    }
    
    func setState(value: State){
        
        selectedState = value
        stateTextField.text = value.name
    }
    
    func getCountry(countryId:String) -> Country?{
        if countriesData != nil{
            let filteredData = countriesData.filter{($0.id == countryId)}
            
            if filteredData.count > 0{
                
                let country:Country = filteredData.first!
                return country
            }
        }
        return nil
    }

    func getState(stateId:String) -> State?{
        
        let filteredData = selectedCoutnry.states.filter{($0.id == stateId)}
        
        if filteredData.count > 0{
            
            let state:State = filteredData.first!
            return state
        }
        
        return nil
    }
    
    @IBAction func submitUpdate(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let error = validateForm()
        if error == ""{
            updatedUser.name = nameTextField.text!
            updatedUser.phone_no = mobileTextField.text!
            updatedUser.email = emailTextField.text!
            updatedUser.country_id = selectedCoutnry.id
            updatedUser.state_id = selectedState.id
            updatedUser.newsletter = (newsletterBtn.isSelected) ? "1" : "0"
            updatedUser.password = passwordTextField.text
            
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.detailsLabel.text = "Updating Profile"
            ISNetworkManager.shred.updateUser(updatedUser: updatedUser) { (success) in
                
            }
        }else{
            showAlert(title: "Required Field", message: error, buttonText: "OK")
        }
    }
    private func validateForm() -> String{
        if nameTextField.text == ""{
            return "Please enter name"
        }else if emailTextField.text == ""{
            return "Please enter email"
        }else if !((emailTextField.text?.isEmail)!){
            return "Please enter valid email"
        }else if mobileTextField.text == ""{
            return "Please eneter mobile number"
        }else if (mobileTextField.text?.length)! <= 7{
            return "Mobile number must be 8 numbers"
        }else if countryTextField.text == ""{
            return "Please select country"
        }else if stateTextField.text == ""{
            return "Please select state"
        }else{
            return ""
        }
    }
    @IBAction func backPressed(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }

    @IBAction func menuPressed(_ sender: UIButton) {
        showDrawerMenu(this: self)
    }
    
    
    func getFirstResponderTextFields() -> UITextField?{
        
        if nameTextField.isFirstResponder{ return emailTextField }
        else if emailTextField.isFirstResponder{ return emailTextField }
        else if mobileTextField.isFirstResponder{ return mobileTextField }
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

extension ProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let chosenImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        userPhoto.contentMode = .scaleAspectFit //3
        userPhoto.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
        
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.detailsLabel.text = "Updating Profile"
        
        ISNetworkManager.shred.updateUserPhoto(userPhoto: chosenImage) { (success) in
            progressHUD.hide(animated: true)
            if(success){
                self.userPhoto.image = chosenImage
            }
        }
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        userPhoto.layer.cornerRadius = userPhoto.frame.size.height/2
//
//        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage //2
//        userPhoto.contentMode = .scaleAspectFit //3
//        userPhoto.image = chosenImage //4
//        dismiss(animated:true, completion: nil) //5
//
//        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
//        progressHUD.detailsLabel.text = "Updating Profile"
//
//        ISNetworkManager.shred.updateUserPhoto(userPhoto: chosenImage) { (success) in
//            progressHUD.hide(animated: true)
//            if(success){
//                self.userPhoto.image = chosenImage
//            }
//        }
//    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
