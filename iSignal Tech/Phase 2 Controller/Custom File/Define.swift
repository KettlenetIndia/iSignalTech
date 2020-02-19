//
//  Define.swift
//  iSignal Tech
//
//  Created by Apple on 21/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import Foundation
import KontaktSDK

@objc protocol ISDelegate {
    @objc optional func didSelectMenuAt(index : Int)
    @objc optional func didUpdateBeaconList(beacons: [CLBeacon])
    @objc optional func didUpdateKontaktBeaconList(config : KTKDeviceConfiguration , distance : Float)
    @objc optional func locationAuthorizationChanged()
    @objc optional func didUpdateBluetoothState(peripheral: CBManagerState)
}


let beaconName = "My Beacon"
let beaconUUID = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
let beaconMajor = 1
let beaconMinor = 1

var categoryList = [Category]()
var delegate : ISDelegate?
var beaconDelegate : ISDelegate?

var isShowAnimation = true
//var isPresentedOffers = false

//var sideMenuDelegate :

struct Services {
    static var isLocationEnable = false
    static var isBluetoothEnable = false
}

struct Location {
    static var latitude = ""
    static var longitude = ""
}

public struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad
}

//MARK: - Application Font Setup
//MARK:

enum FontSize {
    case standard(StandardSize)
    var value: CGFloat {
        switch self {
        case .standard(let size):
            return size.fontSize()
        }
    }
}

enum StandardSize : Int{
    case Extra2Small = 0
    case ExtraSmall = 1
    case Small = 2
    case RegularSmall = 3
    case Regular = 4
    case RegularLarge = 5
    case Large = 6
    
    
    func fontSize()->CGFloat{
        switch self {
            
        case .Extra2Small:
            return getSizeForDeviceType(15.0, sixPlusFSize: 13.0, iphoneSixSize: 12.0, iphoneFSize: 10.0,iphone4SFSize: 9.0) // use
        case .ExtraSmall:
            return getSizeForDeviceType(16.0, sixPlusFSize: 16.0, iphoneSixSize: 14.0, iphoneFSize: 12.0,iphone4SFSize: 10.0) // use
        case .Small:
            return getSizeForDeviceType(18.0, sixPlusFSize: 17.0, iphoneSixSize: 15.0, iphoneFSize: 13.0,iphone4SFSize: 12.0); // use
        case .RegularSmall:
            return getSizeForDeviceType(20.0, sixPlusFSize: 18.0, iphoneSixSize: 16.0, iphoneFSize: 14.0,iphone4SFSize: 13.0); //USe
        case .Regular:
            return getSizeForDeviceType(22.0, sixPlusFSize: 14.0, iphoneSixSize: 12.0, iphoneFSize: 10.0,iphone4SFSize: 10.0); // use
        case .RegularLarge:
            return getSizeForDeviceType(24.0, sixPlusFSize: 16.0, iphoneSixSize: 15.0, iphoneFSize: 11.0,iphone4SFSize: 11.0); // use
        case .Large:
            return getSizeForDeviceType(25.0, sixPlusFSize: 18.0, iphoneSixSize: 17.0, iphoneFSize: 15.0,iphone4SFSize: 13.0);
            
        }
    }
    
}

struct Font {
    
    enum FontType {
        case custom(FontName)
    }
    
    
    
    enum FontName: String {
        case Roboto_Regular             = "Roboto-Regular"
        case Roboto_Bold                = "Roboto-Bold"
        case Roboto_Light               = "Roboto-Light"
        case Roboto_Thin                = "Roboto-Thin"
        case Roboto_Mediam              = "Roboto-Medium"
    }
    
    
    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
    
}

//Basic use:
//Font(.custom(.Lato_Regular), size: .standard(.Regular)).instance

func getSizeForDeviceType(_ iPadFSize : CGFloat,sixPlusFSize : CGFloat, iphoneSixSize : CGFloat, iphoneFSize : CGFloat,iphone4SFSize : CGFloat)->CGFloat{
    
    if DeviceType.IS_IPAD{
        return iPadFSize
    }else if DeviceType.IS_IPHONE_6P{
        return sixPlusFSize
    }else if DeviceType.IS_IPHONE_6{
        return iphoneSixSize
    }else if DeviceType.IS_IPHONE_4_OR_LESS{
        return iphone4SFSize
    }else {
        return iphoneFSize
    }
}

extension Font {
    var instance: UIFont {
        var instanceFont: UIFont!
        switch type {
            
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        }
        return instanceFont
    }
}


extension String{
    func toNSNumber() -> NSNumber{
        if let myInteger = Int(self) {
            return NSNumber(value:myInteger)
        }
        return NSNumber(value: 0)
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
