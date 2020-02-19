//
//  Pipeline.swift
//  Custom Communication Layer
//
//  Created by Avanza on 1/18/16.
//  Copyright © 2016 Avanza. All rights reserved.
//

import UIKit
import Alamofire
import Security

protocol SMNetworkManagerDelegate{
    
    func receivedSuccessResponse(_ response:CustomResponse)
    func receivedFailureResponse(_ response:CustomResponse)
}

public protocol PreprocessorDelegate{
    
    func processRequest(_ request:CustomRequest) -> CustomRequest
}

public protocol PostprocessorDelegate{
    
    func processResponse(_ response:CustomResponse) -> CustomResponse
}

var isEncryptionEnabled:Bool = false
var isSSLPinningEnabled:Bool = false

open class SMNetworkManager: NSObject {
    
    open static let sharedInstance = SMNetworkManager() //Singleton
    
    fileprivate override init(
        ) {} //This prevents others from using the default '()' initializer for this class.
    
    let defaultManager: Alamofire.SessionManager = {
        
        if isSSLPinningEnabled {
        
            let serverHost:String = Bundle.main.object(forInfoDictionaryKey: "ServerHost") as! String

            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                serverHost: .pinCertificates(
//                    certificates: ServerTrustPolicy.cerctificatesInBundle(),
                    certificates: ServerTrustPolicy.certificates(),
                    validateCertificateChain: true,
                    validateHost: true
                )//,
                //serverHost: .DisableEvaluation
            ]
            
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            configuration.timeoutIntervalForRequest = 20 // seconds
            
            return Alamofire.SessionManager(
                configuration: configuration,
                serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
            )
        }
        else{
            
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            configuration.timeoutIntervalForRequest = 20 // seconds
            
            return Alamofire.SessionManager(
                configuration: configuration
            )
        }
    }()
    
    var preprocessors:NSMutableArray = NSMutableArray()
    var postprocessors:NSMutableArray = NSMutableArray()
    //var delegate:SMNetworkManagerDelegate! = nil
    
    public func sendRequest(_ request:CustomRequest, completion: @escaping (_ myResponse: CustomResponse) -> Void){
        var request = request
        
        //Do Preprocessing Tasks
        for preprocessor in preprocessors{
            
            let mypreprocessor:PreprocessorDelegate = preprocessor as! PreprocessorDelegate
            request = mypreprocessor.processRequest(request)
        }
        
        print("URL: \(request.URL!)")
        print("REQUEST: \(request.body)")
        
        if request.image == nil{
            request.header = ["content-type":"application/json; charset = utf-8"]
            
            sendRequestToAlamofire(request, completionHandler:{(myResponse:CustomResponse) -> Void in
                
                if myResponse.isSuccess{}
                
                completion(myResponse)
            })
        }
        else{
         
            //Multipart Upload Request
            sendUploadRequestToAlamofire(request, completionHandler: { (myResponse:CustomResponse) in
                
                completion(myResponse)
            })
        }
        
    }
    
    open func addPreprocessor(_ preprocessor:PreprocessorDelegate){
        
        if preprocessors.count == 0{
            
            preprocessors = NSMutableArray()
        }
        
        preprocessors.add(preprocessor as AnyObject)
    }

    open func addPostprocessor(_ postprocessor:PostprocessorDelegate){
        
        if postprocessors.count == 0{
            
            postprocessors = NSMutableArray()
        }
        
        postprocessors.add(postprocessor as AnyObject)
    }
    
    fileprivate func sendRequestToAlamofire(_ request:CustomRequest, completionHandler: @escaping (_ result: CustomResponse) -> Void){
        
        let httpMethod = HTTPMethod(rawValue: request.type.uppercased as String)
//        let httpMethod = Method(rawValue: request.type! as String)!
        
        
        //Added this line for encryption else only request.body can be passed as parameter
    
        if isEncryptionEnabled {
            let body:[String:AnyObject] = ["body" : request.strBody! as AnyObject]
            
            defaultManager.request(request.URL! as URLConvertible, method: httpMethod!, parameters: body, encoding: JSONEncoding.default, headers: request.header).responseString { response in

//            defaultManager.request(method, request.URL! as URLConvertible, parameters: body, encoding: .json, headers: request.header).responseString { response in
            
                if response.result.isSuccess{
                    
                    var myResponse:CustomResponse = CustomResponse()
                    
                    myResponse.header = response.request?.allHTTPHeaderFields
                    myResponse.strBody = response.result.value! as String
                    
                    //Apply Post-Processors
                    for postprocessor in self.postprocessors{
                        
                        let mypostprocessor:PostprocessorDelegate = postprocessor as! PostprocessorDelegate
                        myResponse = mypostprocessor.processResponse(myResponse)
                    }
                    
                    completionHandler(myResponse)
                    
                    //self.delegate?.receivedSuccessResponse(myResponse)
                }
                else{
                    
                    let myResponse:CustomResponse = CustomResponse()
                    
                    myResponse.error = response.result.error?.localizedDescription
                    
                    if (response.result.error?._code)! == -1009 {
                        
                        let alert:UIAlertView = UIAlertView()
                        alert.title = "Internet Connection Error"
                        alert.message = "Your internet connection appears to be offline. Please check your connectivity and try again."
                        alert.addButton(withTitle: "OK")
                        alert.show()
                    }
                    
                    completionHandler(myResponse)
                    
                    //self.delegate?.receivedFailureResponse(myResponse)
                }
            }
            
        }
        else{
        
            defaultManager.request(request.URL! as URLConvertible, method: httpMethod!, parameters: request.body, encoding: JSONEncoding.default, headers: request.header).responseJSON { response in

//            defaultManager.request(method, request.URL! as URLConvertible, parameters: request.body, encoding: .json, headers: request.header)
//                .responseJSON { response in
                
                    if response.result.isSuccess{
                        
                        var myResponse:CustomResponse = CustomResponse()
                        
                        myResponse.header = response.request?.allHTTPHeaderFields
                        myResponse.body = response.result.value as! NSDictionary
                        
                        //Apply Post-Processors
                        for postprocessor in self.postprocessors{
                            
                            let mypostprocessor:PostprocessorDelegate = postprocessor as! PostprocessorDelegate
                            myResponse = mypostprocessor.processResponse(myResponse)
                        }
                        
                        completionHandler(myResponse)
                        
                        //self.delegate?.receivedSuccessResponse(myResponse)
                    }
                    else{
                        
                        let myResponse:CustomResponse = CustomResponse()
                        
                        myResponse.error = response.result.error?.localizedDescription
                        
                        if (response.result.error?._code)! == -1009 {
                            
                            let alert:UIAlertView = UIAlertView()
                            alert.title = "Internet Connection Error"
                            alert.message = "Your internet connection appears to be offline. Please check your connectivity and try again."
                            alert.addButton(withTitle: "OK")
                            alert.show()
                        }
                        
                        completionHandler(myResponse)
                        
                        //self.delegate?.receivedFailureResponse(myResponse)
                    }
                }
        }
    }
    
    fileprivate func sendUploadRequestToAlamofire(_ request:CustomRequest, completionHandler: @escaping (_ result: CustomResponse) -> Void){
        
        let httpMethod = HTTPMethod(rawValue: request.type.uppercased as String)
        let imgData = request.image!.jpegData(compressionQuality: 0.2)
      //  let imgData = UIImageJPEGRepresentation(request.image!, 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "photo",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in request.body {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            },
                         to:request.URL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    if response.result.isSuccess{
                        
                        var myResponse:CustomResponse = CustomResponse()
                        
                        myResponse.header = response.request?.allHTTPHeaderFields
                        myResponse.body = response.result.value as! NSDictionary
                        
                        //Apply Post-Processors
                        for postprocessor in self.postprocessors{
                            
                            let mypostprocessor:PostprocessorDelegate = postprocessor as! PostprocessorDelegate
                            myResponse = mypostprocessor.processResponse(myResponse)
                        }
                        
                        completionHandler(myResponse)
                        
                    }
                    else{
                        
                        let myResponse:CustomResponse = CustomResponse()
                        
                        myResponse.error = response.result.error?.localizedDescription
                        
                        if (response.result.error?._code)! == -1009 {
                            
                            let alert:UIAlertView = UIAlertView()
                            alert.title = "Internet Connection Error"
                            alert.message = "Your internet connection appears to be offline. Please check your connectivity and try again."
                            alert.addButton(withTitle: "OK")
                            alert.show()
                        }
                        
                        completionHandler(myResponse)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}
