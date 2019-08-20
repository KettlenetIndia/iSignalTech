//
//  Request.swift
//  Custom Communication Layer
//
//  Created by Avanza on 1/18/16.
//  Copyright © 2016 Avanza. All rights reserved.
//

import UIKit

open class CustomRequest: NSObject {

    open var header:[String: String]!
    open var body:[String: AnyObject]!
    open var strBody:String?
    open var type:NSString!
    open var URL:String!
    open var image:UIImage!
}
