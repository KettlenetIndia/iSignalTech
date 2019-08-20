//
//  RootModel.swift
//  iSignal Tech
//
//  Created by Apple on 22/11/17.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import ObjectMapper

class RootModel: Mappable {
    
    var status : Bool?
    var error  : String?
    
    // For user detail response
    var userDetail : UserDetail?
    
    // For getting Side menu category list
    var categoryList = [Category]()
    
    //For category item list
    var categoryItemList = [CategoryItem]()
    
    //For State and Country
    var countryState = [Country]()
    
    //For upload Profile image
    var profileUrl : String?
    
    //For beacon list
    var beaconList = [ISBeacon]()
    
    
    var update = [GetUserAppRelease]()
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        status <- map["status"]
        error <- map["error"]
        
        categoryList <- map["GetCategory"]
        
        userDetail <- map["data"]
        
        categoryItemList <- map["data"]
        
        countryState <- map["data"]
        
        profileUrl <- map["data.photo"]
        
        //used just for text message
        error <- map["success"]
        
        beaconList <- map["data"]
        
        update <- map["GetUserAppRelease"]
    }
}

class GetUserAppRelease : Mappable{
    
    var id : String?
    var version:  String = ""
    var releasedate:  String?
    var forceupdate:  String?
    var message:  String?
    var statuscode:  String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        version <- map["version"]
        releasedate <- map["releasedate"]
        forceupdate <- map["forceupdate"]
        statuscode <- map["statuscode"]
    }
}


class Category : Mappable{
    
    var category_id : String?
    var category_name : String?
    var category_icon : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        category_id <- map["category_id"]
        category_name <- map["category_name"]
        category_icon <- map["category_icon"]
    }
}

class UserDetail: Mappable {
    
    
    var id : String?
    var name : String?
    var email : String?
    var password : String?
    var type : String?
    var phone_no : String?
    var photo : String?
    var logo : String?
    var pushnot_image : String?
    var company_name : String?
    var company_desc : String?
    var category : String?
    var package : String?
    var street : String?
    var city : String?
    var country_id : String?
    var state_id : String?
    var open_time : String?
    var close_time : String?
    var website : String?
    var newsletter : String?
    var social_id : String?
    var social_network : String?
    var otp : String?
    var status : String?
    var modules : String?
    var main_client_id : String?
    var created_date : String?
    var created_by : String?
    var created_ip : String?
    var modified_date : String?
    var modified_by : String?
    var modified_ip : String?
    var is_delete : String?
    var deleted_by : String?
    var delete_from_ip : String?
    var state_name : String?
    
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        password <- map["password"]
        type <- map["type"]
        phone_no <- map["phone_no"]
        photo <- map["photo"]
        logo <- map["logo"]
        pushnot_image <- map["pushnot_image"]
        company_name <- map["company_name"]
        company_desc <- map["company_desc"]
        category <- map["category"]
        package <- map["package"]
        street <- map["street"]
        city <- map["city"]
        country_id <- map["country_id"]
        state_id <- map["state_id"]
        open_time <- map["open_time"]
        close_time <- map["close_time"]
        website <- map["website"]
        newsletter <- map["newsletter"]
        social_id <- map["social_id"]
        social_network <- map["social_network"]
        otp <- map["otp"]
        status <- map["status"]
        modules <- map["modules"]
        main_client_id <- map["main_client_id"]
        created_date <- map["created_date"]
        created_by <- map["created_by"]
        created_ip <- map["created_ip"]
        modified_date <- map["modified_date"]
        modified_by <- map["modified_by"]
        modified_ip <- map["modified_ip"]
        is_delete <- map["is_delete"]
        deleted_by <- map["deleted_by"]
        delete_from_ip <- map["delete_from_ip"]
        state_name <- map["state_name"]
    }
}


class CategoryItem : Mappable{
    
    var category : String?
    var city : String?
    var clientId : String?
    var clientName : String?
    var companyName : String?
    var email : String?
    var images : String = ""
    var latitude : String?
    var longitude : String?
    var phoneNo : String?
    var punchcardUrl : String = ""
    var street : String?
    var website : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        category <- map["category"]
        city <- map["city"]
        clientId <- map["client_id"]
        clientName <- map["client_name"]
        companyName <- map["company_name"]
        email <- map["email"]
        images <- map["images"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        phoneNo <- map["phone_no"]
        punchcardUrl <- map["punchcard_url"]
        street <- map["street"]
        website <- map["website"]
    }
}


class Country: Mappable {
    
    var id: String!
    var sortname: String!
    var name: String!
    var phonecode: String!
    var status: String!
    var states: [State]!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        id <- map["id"]
        sortname <- map["sortname"]
        name <- map["name"]
        phonecode <- map["phonecode"]
        status  <- map["status"]
        states <- map["states"]
    }
}

class State: Mappable {
    
    var id: String!
    var name: String!
    var countryId: String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        countryId <- map["country_id"]
    }
}



class ISBeacon : Mappable{
    
    var enterExist : String?
    var branch : String?
    var campaigns : [Campaign]?
    var client : String?
    var deviceId : String?
    var deviceName : String?
    var hotel : [Hotel]?
    var latitude : String?
    var longitude : String?
    var major : String?
    var minor : String?
    var pushnotificationImage : String?
    var room : Int?
    var status : Int?
    var uuid : String?
    var beacon: CLBeacon?
    
    var isPresented = false
    var isNotificationFired = false
    var todayPresentedTimer : Date?
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        enterExist <- map["Enter_Exist"]
        branch <- map["branch"]
        campaigns <- map["campaigns"]
        client <- map["client"]
        deviceId <- map["device_id"]
        deviceName <- map["device_name"]
        hotel <- map["hotel"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        major <- map["major"]
        minor <- map["minor"]
        pushnotificationImage <- map["pushnotification_image"]
        room <- map["room"]
        status <- map["status"]
        uuid <- map["uuid"]
        
    }
    
    
    func locationString() -> String {
        guard let beacon = beacon else { return "Unknown" }
        //let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = ""// = "\(proximity)"
        if beacon.proximity != .unknown {
            location += " \(accuracy) m"
        }
        else{
            location = "0.00 m"
        }
        
        return location
    }
    
    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
}

class Campaign: Mappable {
    
    var campaignId: String!
    var campaignName: String!
    var mediaId: String!
    var mediaType: String!
    var Welcome_image : String?
    var image: String?
    var video: String?
    var title: String!
    var notification: String!
    var url:String!
    var embed:String!
    var runningDate: String!
    var Survey_url : String!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        campaignId <- map["campaign_id"]
        campaignName <- map["campaign_name"]
        mediaId <- map["media_id"]
        mediaType <- map["media_type"]
        image <- map["image"]
        video <- map["video"]
        title <- map["title"]
        notification <- map["notification"]
        url <- map["url"]
        embed <- map["embed"]
        runningDate <- map["running_date"]
        Welcome_image <- map["Welcome_image"]
        Survey_url <- map["Survey_url"]
    }
    
}

class Hotel : Mappable{
    
    var branchName : String?
    var city : String?
    var companyName : String?
    var contactPerson : String?
    var decription : String?
    var email : String?
    var phoneNo : String?
    var street : String?
    var website : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        branchName <- map["branch_name"]
        city <- map["city"]
        companyName <- map["company_name"]
        contactPerson <- map["contact_person"]
        decription <- map["decription"]
        email <- map["email"]
        phoneNo <- map["phone_no"]
        street <- map["street"]
        website <- map["website"]
    }
}

