//
//  NightscoutEntry.swift
//  RileyLink
//
//  Created by Timothy Mecklem on 11/5/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation
import MinimedKit

public class NightscoutEntry: DictionaryRepresentable {
    
    public enum GlucoseType: String {
        case Meter
        case Sensor
    }
    
    public let timestamp: Date
    let glucose: Int
    let previousSGV: Int?
    let previousSGVNotActive: Bool?
    let direction: String?
    let device: String
    let glucoseType: GlucoseType
    
    init(glucose: Int, timestamp: Date, device: String, glucoseType: GlucoseType,
         previousSGV: Int? = nil, previousSGVNotActive: Bool? = nil, direction: String? = nil) {
        
        self.glucose = glucose
        self.timestamp = timestamp
        self.device = device
        self.previousSGV = previousSGV
        self.previousSGVNotActive = previousSGVNotActive
        self.direction = direction
        self.glucoseType = glucoseType
    }
    
    convenience init?(event: TimestampedGlucoseEvent, device: String) {
        if let glucoseSensorData = event.glucoseEvent as? SensorValueGlucoseEvent {
            self.init(glucose: glucoseSensorData.sgv, timestamp: event.date, device: device, glucoseType: .Sensor)
        } else {
            return nil
        }
    }
    
    public var dictionaryRepresentation: [String: Any] {
        var representation: [String: Any] = [
            "device": device,
            "date": round(timestamp.timeIntervalSince1970 * 1000),
            "dateString": TimeFormat.timestampStrFromDate(timestamp)
        ]
        
        switch glucoseType {
        case .Meter:
            representation["type"] = "mbg"
            representation["mbg"] = glucose
        case .Sensor:
            representation["type"] = "sgv"
            representation["sgv"] = glucose
        }
        
        if let direction = direction {
            representation["direction"] = direction
        }
        
        if let previousSGV = previousSGV {
            representation["previousSGV"] = previousSGV
        }
        
        if let previousSGVNotActive = previousSGVNotActive {
            representation["previousSGVNotActive"] = previousSGVNotActive
        }
        
        return representation
    }
}
