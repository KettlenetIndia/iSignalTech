//
//  ISNetworkManager.swift
//  iSignal Tech
//
//  Created by Apple on 22/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

//let BASEURLV2 = "http://api.isignal.tech/v2/"
let BASEURLV2 = "http://api.isignal.tech/n1/"

struct APIList {
    static let Login = BASEURLV2 + "auth/login"
    static let Register = BASEURLV2 + "auth/register"
    static let PushToken = BASEURLV2 + "auth/device_token"
    static let VerifyOtp  = BASEURLV2 + "auth/activate"
    static let ForgotPassword = BASEURLV2 + "auth/send_code?email="
    static let ResetPassword = BASEURLV2 + "auth/reset"
    
    static let CountryState = BASEURLV2 + "util/countries_states"
    static let UploadProfile = BASEURLV2 + "user/update_photo"
    static let UpdateProfile = BASEURLV2 + "user/update"
    static let SubmitFeedback = BASEURLV2 + "util/feedback"
    
    static let BeaconList = BASEURLV2 + "device/get_all?date="
    
    static let AddAnalystic = BASEURLV2 + "Hits/hits"
    
    static let CheckUpdate = BASEURLV2 + "Forceupdate/version"
}

class ISNetworkManager: NSObject {
    
    
    public static let shred = ISNetworkManager()
    
    var countriesFetched : Bool = false
    var offerUpdateTimer:Timer!
    
    /*
     *  Get side menu category list
     */
    func getSideMenuCategoryList(completion: @escaping (_ success: Bool,_ response : RootModel?) -> Void){
        let url = "http://api.isignal.tech/n1/Category/category"
        self.commanGetSetvice(url: url, completion: completion)
    }
    
    /*
     *  Get category sub items (map data)
     *  @param category id
     */
    func getSideMenuCategoryItemList(categoryId : String,completion: @escaping (_ success: Bool,_ response : RootModel?) -> Void){
        let url = "http://api.isignal.tech/n1/Client/get_clients_category?category=\(categoryId)"
        self.commanGetSetvice(url: url, completion: completion)
    }
    
    /*
     *  Login api
     *  @param User Email Id
     *  @param User Password
     */
    func loginWithEmail(email : String, password : String,completion: @escaping (_ success: Bool,_ response : RootModel?) -> Void){
        let param = ["email":email,
                     "password":password]
        self.commanPostService(url: APIList.Login, param: param, completion: completion)
    }
    
    /*
     *  Signup api
     *  @param User Name Id
     *  @param User Email Id
     *  @param User Password
     *  @param User Phone number
     *  @param User Country id
     *  @param User State id
     *  @param User Social id
     *  @param is Social Login
     *  @param Newsletter subscribed
     */
    func registerUserWith(name:String, email:String, password:String, phoneNo:String, countryId:String, stateId:String, socialId:String?, socialNetwork:String, newsletter:String, completion: @escaping (_ success: Bool) -> Void){
        
        let param = ["name"         :   name,
                     "email"        :   email,
                     "password"     :   password,
                     "phone_no"     :   phoneNo,
                     "country_id"   :   countryId,
                     "state_id"     :   stateId,
                     "newsletter"   :   newsletter,
                     "social_network" :socialNetwork,
                     "social_id"    :   socialId!]
        
        print("Sign up Param \(param)")
        self.commanPostService(url: APIList.Register, param: param) { (isSuccess, response) in
            
            if(isSuccess){
                user = (response?.userDetail)!
                let strUserDetail = response?.userDetail?.toJSONString()
                userDefaults.set(strUserDetail, forKey: getUserObjectKey)
                if (countryId != "101"){
                    showAlert(title: "Registration Successful", message: "You have successfully registered.", buttonText: "OK")
                }
            }else{
                if let message = response?.error{
                    showAlert(title: "Registration Failed", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Registration Failed", message: "There was some error while registering. Please try again.", buttonText: "OK")
                }
            }
            completion(isSuccess)
            progressHUD.hide(animated: true)
        }
    }
    
    /*
     *  Forgot password api
     *  @param Email id
     *  @param Code
     */
    func forgotPassword(email:String, code:String, completion: @escaping (_ success: Bool) -> Void){
        let url = "\(APIList.ForgotPassword)\(email)&code=\(code)"
        self.commanGetSetvice(url: url) { (isSuccess, response) in
            if (isSuccess == false){
                if let message = response?.error{
                    showAlert(title: "Create New Password", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Create New Password", message: "There was some error while resetting your password. Please try again.", buttonText: "OK")
                }
            }
            completion(isSuccess)
            progressHUD.hide(animated: true)
        }
    }

    /*
     *  Reset password api
     *  @param Email id
     *  @param new password
     */
    func resetPassword(email:String, password:String, completion: @escaping (_ success: Bool) -> Void){
        let param = ["email":email,
                     "password":password]
        self.commanPostService(url: APIList.ResetPassword, param: param) { (isSuccess, response) in
            if(isSuccess){
                if let message = response?.error{
                    showAlert(title: "Reset Password", message: message, buttonText: "OK")
                }
            }else{
                if let message = response?.error{
                    showAlert(title: "Reset Password", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Reset Password", message: "There was some error while resetting your password. Please try again.", buttonText: "OK")
                }
            }
            completion(isSuccess)
            progressHUD.hide(animated: true)
        }
    }
    
    /*
     *  Verify Otp api
     *  @param User Id
     *  @param User otp
     */
    func activateUserAccount(userId:String, otp:String, completion: @escaping (_ success: Bool) -> Void){
        let param = ["user_id" : userId,
                     "otp" : otp]
        self.commanPostService(url: APIList.VerifyOtp, param: param) { (isSuccess, response) in
            if(isSuccess){
                showAlert(title: "Registration Successful", message: "You have successfully registerd.", buttonText: "OK")
                userDefaults.set(true, forKey: getLoggedInKey)
                userDefaults.synchronize()
            }else{
                if let message = response?.error{
                    showAlert(title: "Registration Failed", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Registration Failed", message: "There was some error while registering. Please try again.", buttonText: "OK")
                }
            }
            
            completion(isSuccess)
            progressHUD.hide(animated: true)
        }
    }
    
    
    /*
     *  Send Device Token to server
     */
    func pushDeviceToken(completion: @escaping (_ success: Bool,_ response : RootModel?) -> Void){
        
        let token  = userDefaults.value(forKey: getDeviceToken) as? String
        let userId = user.id
        
        if token == nil || userId == nil{
            completion(false,nil)
            return
        }
        
        let param = ["user_id"  :       userId!,
                     "platform" :       "2",
                     "device_token":    token!]
        
        self.commanPostService(url: APIList.PushToken, param: param, completion: completion)
        
    }
    
    /*
     *  Get Country and state list from server
     */
    func getCountriesAndStates(completion: @escaping (_ success: Bool) -> Void){
        let url = APIList.CountryState
        
        self.commanGetSetvice(url: url) { (isSuccess, response) in
            if(isSuccess){
                let countries = response?.countryState.toJSON()
                userDefaults.set(countries, forKey: getCountries)
                userDefaults.synchronize()
                countriesData = response?.countryState
            }else{
                if let message = response?.error{
                    showAlert(title: "Countries Fetch Failed", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Countries Fetch Failed", message: "There was some error while fetching countries. Please try again.", buttonText: "OK")
                }
            }
            completion(true)
        }
    }
    
    
    /*
     * Update User API
     * @param Submit UserDetail Model
     */
    
    func updateUser(updatedUser:UserDetail, completion: @escaping (_ success: Bool) -> Void){
        
        let param = ["user_id":updatedUser.id!,
                     "name":updatedUser.name!,
                     "email":updatedUser.email!,
                     "password":updatedUser.password!,
                     "phone_no":updatedUser.phone_no!,
                     "country_id":updatedUser.country_id!,
                     "state_id":updatedUser.state_id!,
                     "newsletter":updatedUser.newsletter!]
        
        self.commanPostService(url: APIList.UpdateProfile, param: param) { (isSuccess, response) in
            
            if(isSuccess){
                let userStr  = response?.userDetail?.toJSONString()
                userDefaults.set(userStr, forKey: getUserObjectKey)
                userDefaults.synchronize()
                showAlert(title: "Profile Update Successful", message: "Your information was successfully updated.", buttonText: "OK")
            }else{
                if let message = response?.error{
                    showAlert(title: "Profile Update Failed", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Profile Update Failed", message: "There was some error while updating profile. Please try again.", buttonText: "OK")
                }
            }
            progressHUD.hide(animated: true)
            completion(isSuccess)
        }
        
    }
    
    /*
     * Submit Feedback API
     * @param Name
     * @param Email
     * @param Mobile Number
     * @param Subject
     * @param Message which entered by user
     */

    func submitFeedback(name:String, email:String, mobile:String, subject:String, message:String, completion: @escaping (_ success: Bool) -> Void){
        let param = ["name":name,
                     "email":email,
                     "mobile":mobile,
                     "subject":subject,
                     "message":message]
        self.commanPostService(url: APIList.SubmitFeedback, param: param) { (isSuccess, response) in
            completion(isSuccess)
            progressHUD.hide(animated: true)
            if(isSuccess){
                showAlert(title: "Feedback submit", message: (response?.error)!, buttonText: "OK")
            }else{
                if let message = response?.error{
                    showAlert(title: "Feedback submit Failed", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Feedback submit Failed", message: "There was some error while submiting feedback. Please try again.", buttonText: "OK")
                }
            }
        }
    }
    
    // Update user profile Image to server
    func updateUserPhoto(userPhoto:UIImage, completion: @escaping (_ success: Bool) -> Void){
        let param = ["user_id":user.id!]
        
        self.uploadTaskWith(url: APIList.UploadProfile, param: param, image: userPhoto) { (isSuccess, response) in
            completion(isSuccess)
            if(isSuccess){
                user.photo = response?.profileUrl
                let strUserDetail = user.toJSONString()
                userDefaults.set(strUserDetail, forKey: getUserObjectKey)
                userDefaults.synchronize()
                showAlert(title: "Photo Update Successful", message: "Your photo was successfully updated.", buttonText: "OK")
            }else{
                if let message = response?.error{
                    showAlert(title: "Photo Update Failed", message: message, buttonText: "OK")
                }else{
                    showAlert(title: "Photo Update Failed", message: "There was some error while updating your photo. Please try again.", buttonText: "OK")
                }
            }
        }
    }
    
    /*
     * Get Beacon list from server
     */
    func getActiveBeaconsAndOffers(completion: @escaping (_ success: Bool) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        let url = "\(APIList.BeaconList)\(date)"
        
        self.commanGetSetvice(url: url) { (isSuccess, response) in
            if(isSuccess){
                
                for sOffer in (response?.beaconList)!{
                    let contain = beaconsData.contains(where: { (eOffer) -> Bool in
                        if eOffer.deviceId  == sOffer.deviceId{
                            return true
                        }else{
                            return false
                        }
                    })
                    if (!contain){
                        beaconsData.append(sOffer)
                    }
                }
                if beaconsData.count > 0{
                    let strBeaconList = beaconsData.toJSONString()
                    
                    userDefaults.set(strBeaconList, forKey: getBeacons)
                    userDefaults.synchronize()
                }
            }
            completion(isSuccess)
        }
    }
    
    
    /*
     *  Add Analystic Report
     */
    
    func addAnalysticReport(beaconId: String,campaignId: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: Date())
        
        let param = ["date"         : date,
                     "beacon_id"    : beaconId,
                     "campaign_id"  :campaignId,
                     "user_id"      : user.id!,
                     "mobile_model" : modelIdentifier()]
        
        self.commanPostService(url: APIList.AddAnalystic, param: param) { (isSuccess, response) in
            print(response?.error ?? "")
        }
        
    }
    
    private func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    
    func checkUpdate(completion: @escaping (_ success: Bool,_ response : RootModel?) -> Void){
        self.commanGetSetvice(url: APIList.CheckUpdate, completion: completion)
    }
    
    /*
     * Comman Get Service
     * @param Send Url for service
     * it will return complition block with RootModel
     */
    private func commanGetSetvice(url : String , completion: @escaping (_ success: Bool,_ response : RootModel?) -> Void){
        
        Alamofire.request(url, method: .get).responseObject { (response: DataResponse<RootModel>) in
            if(response.result.isSuccess){
                if(response.result.value?.status)!{
                    completion(true,response.result.value)
                }else{
                    completion(false,response.result.value)
                }
            }else{
                completion(false,response.result.value)
            }
        }
    }
    
    /*
     * Comman Post Service
     * @param Send Url for service
     * @param Send Parameter which are need to pass in service
     * it will return complition block with RootModel
     */
    private func commanPostService(url : String , param : [String : String],completion: @escaping (_ success: Bool,_ response : RootModel?) -> Void){
        
//        let headers: HTTPHeaders = ["Accept": "application/json; charset=utf-8"]
//        , headers: headers
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default).responseObject { (response: DataResponse<RootModel>) in
            if(response.result.isSuccess){
                if(response.result.value?.status)!{
                    completion(true,response.result.value)
                }else{
                    completion(false,response.result.value)
                }
            }else{
                completion(false,response.result.value)
            }
        }
    }
    
    
    /*
     * Comman Method for uploading file
     * @param Send Url for service
     * @param Send Parameter which are need to pass in service
     * @param Attech Image Which you want to upload
     * it will return complition block with RootModel
     */
    private func uploadTaskWith(url : String, param : [String : String],image : UIImage,completion: @escaping (_ success: Bool,_ response : RootModel?) -> Void){
        
         let imgData = image.jpegData(compressionQuality: 0.2)!
      //  let imgData = UIImageJPEGRepresentation(image, 0.2)!

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "photo",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in param {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
           }
        },to:url){ (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseObject(completionHandler: { (response: DataResponse<RootModel>) in
                    if response.result.isSuccess{
                        completion(true,response.result.value)
                    }else{
                        completion(false,response.result.value)
                    }
                })
                
            case .failure(let encodingError):
                print(encodingError)
                completion(false,nil)
            }
        }
    }
        
    
}
