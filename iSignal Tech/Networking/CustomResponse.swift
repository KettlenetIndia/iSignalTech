//
//  Response.swift
//  Custom Communication Layer
//
//  Created by Avanza on 1/18/16.
//  Copyright © 2016 Avanza. All rights reserved.
//

import UIKit

open class CustomResponse: NSObject {

    open var header:[String: String]!
    open var body:NSDictionary!
    open var strBody:String?
    open var error:String!
    open var code:Int!
    
    /// Returns `true` if the result is a success, `false` otherwise.
    open var isSuccess: Bool {
        
        if error==nil{
            return true
        }
        else{
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    open var isFailure: Bool {
        return !isSuccess
    }
}
