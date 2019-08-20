//
//  NetworkOperations.swift
//  Smart Learner
//
//  Created by Salman Maredia on 27/03/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import CoreData

class NetworkOperations: NSObject {
    
//    static let sharedInstance = NetworkOperations()
    //var managedObjectContext:NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
//    var countriesFetched:Bool = false
//    var offerUpdateTimer:Timer!
    
//    func loginUser(email:String, password:String, completion: @escaping (_ success: Bool) -> Void){
//
//        let requestBody:Dictionary<String,AnyObject> = ["email":email as AnyObject,
//                                                        "password":password as AnyObject]
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "auth/login"
//        myRequest.body = requestBody
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    let userObject:NSDictionary = myResponse.body!.value(forKeyPath: "data") as! NSDictionary
//
//                    user = Mapper<User>().map(JSONObject: userObject)!
//
//                    let userStr:String = user.toJSONString()!
//                    userDefaults.set(userStr, forKey: getUserObjectKey)
//                    userDefaults.synchronize()
//
//                    userDefaults.set(true, forKey: getLoggedInKey)
//                    userDefaults.synchronize()
//
//                    self.pushDeviceToken(completion: { (success) in
//
//                        progressHUD.hide(animated: true)
//                        completion(true)
//                    })
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Login Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Login Failed", message: "There was some error while logging in. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func activateUserAccount(userId:String, otp:String, completion: @escaping (_ success: Bool) -> Void){
//
//        let requestBody:Dictionary<String,AnyObject> = ["user_id":userId as AnyObject,
//                                                        "otp":otp as AnyObject]
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "auth/activate"
//        myRequest.body = requestBody
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//
//                    showAlert(title: "Registration Successful", message: "You have successfully registerd.", buttonText: "OK")
//
//                    userDefaults.set(true, forKey: getLoggedInKey)
//                    userDefaults.synchronize()
//
//                    progressHUD.hide(animated: true)
//
//                    completion(true)
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Registration Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Registration Failed", message: "There was some error while registering. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func socialLoginUser(name:String, email:String, socialNetwork:String, socialId:String, completion: @escaping (_ success: Bool) -> Void){
//
//        let requestBody:Dictionary<String,AnyObject> = ["social_network":socialNetwork as AnyObject,
//                                                        "social_id":socialId as AnyObject]
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "auth/social_login"
//        myRequest.body = requestBody
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    let userObject:NSDictionary = myResponse.body!.value(forKeyPath: "data") as! NSDictionary
//
//                    user = Mapper<User>().map(JSONObject: userObject)!
//
//                    let userStr:String = user.toJSONString()!
//                    userDefaults.set(userStr, forKey: getUserObjectKey)
//                    userDefaults.synchronize()
//
//                    userDefaults.set(true, forKey: getLoggedInKey)
//                    userDefaults.synchronize()
//
//                    self.pushDeviceToken(completion: { (success) in
//
//                        progressHUD.hide(animated: true)
//                        completion(true)
//                    })
//
//                }
//                else{
//
//                    self.registerUser(name: name, email: email, password: "abc123", phoneNo: "000", countryId: "231", stateId: "0", socialId: socialId, socialNetwork: socialNetwork, newsletter: "0", completion: { (success) in
//
//                        if success{
//
//                            progressHUD.hide(animated: true)
//                            completion(true)
//                        }
//                    })
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func registerUser(name:String, email:String, password:String, phoneNo:String, countryId:String, stateId:String, socialId:String?, socialNetwork:String, newsletter:String, completion: @escaping (_ success: Bool) -> Void){
//
//        var requestBody:Dictionary<String,AnyObject> = ["name":name as AnyObject,
//                                                        "email":email as AnyObject,
//                                                        "password":password as AnyObject,
//                                                        "phone_no":phoneNo as AnyObject,
//                                                        "country_id":countryId as AnyObject,
//                                                        "state_id":stateId as AnyObject,
//                                                        "newsletter":newsletter as AnyObject,
//                                                        "social_network":socialNetwork as AnyObject]
//
//        if socialId != nil{
//
//            requestBody["social_id"] = socialId! as AnyObject
//        }
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "auth/register"
//        myRequest.body = requestBody
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    let userObject:NSDictionary = myResponse.body!.value(forKeyPath: "data") as! NSDictionary
//
////                    user = Mapper<User>().map(JSONObject: userObject)!
//
//                    if (countryId != "101"){
//                        showAlert(title: "Registration Successful", message: "You have successfully registered.", buttonText: "OK")
//                    }
//
//                    userDefaults.set(true, forKey: getLoggedInKey)
//                    userDefaults.synchronize()
//
//                    self.pushDeviceToken(completion: { (success) in
//
//                        progressHUD.hide(animated: true)
//                        completion(true)
//                    })
//
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Registration Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Registration Failed", message: "There was some error while registering. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }

//    func pushDeviceToken(completion: @escaping (_ success: Bool) -> Void){
//
//        let token = userDefaults.value(forKey: getDeviceToken)
//        let userId:String = user.id!
//
//        if token == nil || userId == nil{
//            return
//        }
//
//        let requestBody:Dictionary<String,AnyObject> = ["user_id":userId as AnyObject,
//                                                        "platform":"2" as AnyObject,
//                                                        "device_token":token! as AnyObject]
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "auth/device_token"
//        myRequest.body = requestBody
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    progressHUD.hide(animated: true)
//                    completion(true)
//                }
//                else{
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func updateUser(updatedUser:User, completion: @escaping (_ success: Bool) -> Void){
//
//        let requestBody:Dictionary<String,AnyObject> = ["user_id":updatedUser.id as AnyObject,
//                                                        "name":updatedUser.name as AnyObject,
//                                                        "email":updatedUser.email as AnyObject,
//                                                        "password":updatedUser.password as AnyObject,
//                                                        "phone_no":updatedUser.phoneNo as AnyObject,
//                                                        "country_id":updatedUser.countryId as AnyObject,
//                                                        "state_id":updatedUser.stateId as AnyObject,
//                                                        "newsletter":updatedUser.newsletter as AnyObject]
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "user/update"
//        myRequest.body = requestBody
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    let userObject:NSDictionary = myResponse.body!.value(forKeyPath: "data") as! NSDictionary
//
//                    user = Mapper<User>().map(JSONObject: userObject)!
//
//                    let userStr:String = user.toJSONString()!
//                    userDefaults.set(userStr, forKey: getUserObjectKey)
//                    userDefaults.synchronize()
//
//                    showAlert(title: "Profile Update Successful", message: "Your information was successfully updated.", buttonText: "OK")
//
//                    progressHUD.hide(animated: true)
//
//                    completion(true)
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Registration Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Registration Failed", message: "There was some error while registering. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func updateUserPhoto(userPhoto:UIImage, completion: @escaping (_ success: Bool) -> Void){
//
//        let requestBody:Dictionary<String,AnyObject> = ["user_id":user.id as AnyObject]
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "user/update_photo"
//        myRequest.body = requestBody
//        myRequest.image = userPhoto
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    let photoUrl:String = myResponse.body!.value(forKeyPath: "data.photo") as! String
//
//                    user.photo = photoUrl
//
//                    showAlert(title: "Photo Update Successful", message: "Your photo was successfully updated.", buttonText: "OK")
//
//                    progressHUD.hide(animated: true)
//
//                    completion(true)
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Photo Update Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Photo Update Failed", message: "There was some error while updating your photo. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func submitFeedback(name:String, email:String, mobile:String, subject:String, message:String, completion: @escaping (_ success: Bool) -> Void){
//
//        let requestBody:Dictionary<String,AnyObject> = ["name":name as AnyObject,
//                                                        "email":email as AnyObject,
//                                                        "mobile":mobile as AnyObject,
//                                                        "subject":subject as AnyObject,
//                                                        "message":message as AnyObject]
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "util/feedback"
//        myRequest.body = requestBody
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "success") as? String) {
//
//                        showAlert(title: "Feedback Submitted", message: msg, buttonText: "OK")
//                    }
//                    else{
//                       showAlert(title: "Profile Update Successful", message: "Your feedback was successfully submitted.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//
//                    completion(true)
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Registration Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Registration Failed", message: "There was some error while registering. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func forgotPassword(email:String, code:String, completion: @escaping (_ success: Bool) -> Void){
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "GET"
//        myRequest.URL = BASE_URL + "auth/send_code?email=\(email)&code=\(code)"
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "success") as? String) {
//
//                        showAlert(title: "Create New Password", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Create New Password", message: "Please enter your new password and OTP.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//
//                    completion(true)
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Forgot Password Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Forgot Password Failed", message: "There was some error while resetting your password. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func resetPassword(email:String, password:String, completion: @escaping (_ success: Bool) -> Void){
//
//        let requestBody:Dictionary<String,AnyObject> = ["email":email as AnyObject,
//                                                        "password":password as AnyObject]
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "POST"
//        myRequest.URL = BASE_URL + "auth/reset"
//        myRequest.body = requestBody
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "success") as? String) {
//
//                        showAlert(title: "Reset Password", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Reset Password", message: "Your password has been successfully reset.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//
//                    completion(true)
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Reset Password Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Reset Password Failed", message: "There was some error while resetting your password. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func getActiveBeaconsAndOffers(completion: @escaping (_ success: Bool) -> Void){
//
//        let df:DateFormatter = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd"
//        let date:String = df.string(from: Date())
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "GET"
//        myRequest.URL = BASE_URL + "device/get_all?date=\(date)"
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    let offers:[NSDictionary] = myResponse.body!.value(forKey: "data") as! [NSDictionary]
//
//                    userDefaults.set(offers, forKey: getBeacons)
//                    userDefaults.synchronize()
//
//                    beaconsData = Mapper<Beacon>().mapArray(JSONObject: offers)!
//
//                    progressHUD.hide(animated: true)
//                    completion(true)
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Offers Fetch Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Offers Fetch Failed", message: "There was some error while fetching offers. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
//    func getCountriesAndStates(completion: @escaping (_ success: Bool) -> Void){
//
//        let myRequest:CustomRequest = CustomRequest()
//        myRequest.type = "GET"
//        myRequest.URL = BASE_URL + "util/countries_states"
//
//        SMNetworkManager.sharedInstance.sendRequest(myRequest) { (myResponse) -> Void in
//
//            if myResponse.body != nil{
//
//                print("------- Success Callback Called --------")
//                print(myResponse.body!)
//
//                if myResponse.body!.value(forKey: "status") as? Bool == true{
//
//                    let countries:[NSDictionary] = myResponse.body!.value(forKey: "data") as! [NSDictionary]
//
//                    userDefaults.set(countries, forKey: getCountries)
//                    userDefaults.synchronize()
//
//                    countriesData = Mapper<Country>().mapArray(JSONObject: countries)!
//
//                    progressHUD.hide(animated: true)
//                    completion(true)
//                }
//                else{
//
//                    if let msg:String = (myResponse.body!.value(forKey: "error") as? String) {
//
//                        showAlert(title: "Countries Fetch Failed", message: msg, buttonText: "OK")
//                    }
//                    else{
//                        showAlert(title: "Countries Fetch Failed", message: "There was some error while fetching countries. Please try again.", buttonText: "OK")
//                    }
//
//                    progressHUD.hide(animated: true)
//                    completion(false)
//                }
//            }
//
//            progressHUD.hide(animated: true)
//        }
//    }
    
    
    func getsideMenuCategory(){
        
    }
}
