//
//  Beacon.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 30/05/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation

class Beacon: Mappable {
    
    var deviceId: String!
    var client: String!
    var deviceName: String!
    var uuid: String!
    var major: String!
    var minor: String!
    var status: String!
    var room: String!
    var latitude: String!
    var longitude: String!
    var campaigns: [Campaign]!
    var beacon: CLBeacon?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        deviceId <- map["device_id"]
        client <- map["client"]
        deviceName <- map["device_name"]
        uuid <- map["uuid"]
        major <- map["major"]
        minor <- map["minor"]
        status <- map["status"]
        room <- map["room"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        campaigns <- map["campaigns"]
    }
    
    func locationString() -> String {
        guard let beacon = beacon else { return "Unknown" }
        //let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = ""// = "\(proximity)"
        if beacon.proximity != .unknown {
            location += " \(accuracy)m"
        }
        else{
            location = "Unknown"
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
