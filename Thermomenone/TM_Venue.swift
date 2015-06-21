//
//  TM_Venue.swift
//  Thermomenone
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

import Foundation

public enum TM_CompassDirection {
    case North
    case NNE
    case NE
    case ENE
    case East
    case ESE
    case SE
    case SSE
    case South
    case SSW
    case SW
    case WSE
    case West
    case WNW
    case NW
    case NNW
}

public class TM_Venue : NSObject {
    public let venueName: String
    
    public init(venueName: String) {
        assert(count(venueName) > 0, "Empty String passed on TMVenue initializer");
        self.venueName = venueName;
    }
    
    public class func updateVenue(venueDictionary: Dictionary<String, AnyObject>) {
    
    }

    public var weatherCondition: String?
    public var weatherConditionIcon: String?
    public var weatherWindDirection: TM_CompassDirection?
    public var weatherWindSpeed: Int?
    public var weatherHumidity: Int?
    public var weatherTemp: Int?
    public var weatherFeelsLike: Int?
    public var lastUpdated: NSDate?
}
