//
//  TM_Venue.swift
//  Thermomenone
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

import Foundation

public enum TM_Venue_ManifestKey: String {
    case venueID = "_venueID"
    case venueName = "_name"
    case country = "country"
    case weatherCondition = "_weatherCondition"
    case weatherConditionIcon = "_weatherConditionIcon"
    case weatherWind = "_weatherWind"
    case weatherHumidity = "_weatherHumidity"
    case weatherTemp = "_weatherTemp"
    case weatherFeelsLike = "_weatherFeelsLike"
    case weatherLastUpdated = "_weatherLastUpdated"
}

public enum TM_CountryKey: String {
    case countryID = "_countryID"
    case countryName = "_name"
}

public class TM_Venue : NSObject {
    public let venueName: String
    
    public init(venueName: String) {
        assert(count(venueName) > 0, "Empty String passed on TMVenue initializer");
        self.venueName = venueName;
    }

    public var country: String?
    public var countryID: NSNumber?
    public var weatherCondition: String?
    public var weatherConditionIcon: String?
    public var weatherWindDirection: String?
    public var weatherWindSpeed: NSNumber?
    public var weatherHumidity: NSNumber?
    public var weatherTemp: NSNumber?
    public var weatherFeelsLike: NSNumber?
    public var lastUpdated: NSDate?
}

extension TM_Venue {
    
    public func updateVenue(venueDictionary: Dictionary<String, AnyObject>) {
        //check that venue object is valid. we don't want to update at all if we got the wrong venue here.
        if let v: String = TM_Venue.manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.venueName) {
            if v != self.venueName {
                return
            }
        }
        
        if let v: NSNumber = TM_Venue.manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherLastUpdated) {
            let lastUpdateDate = NSDate(timeIntervalSince1970: v.doubleValue)
            if self.lastUpdated == nil || lastUpdateDate.compare(self.lastUpdated!) == NSComparisonResult.OrderedAscending {
                self.lastUpdated = lastUpdateDate
            } else {
                return
            }
        } else {
            self.lastUpdated = nil
        }

        if let v: String = TM_Venue.manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherCondition) {
            self.weatherCondition = v
        } else {
            self.weatherCondition = nil
        }
        
        if let v: String = TM_Venue.manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherConditionIcon) {
            self.weatherConditionIcon = v
        } else {
            self.weatherConditionIcon = nil
        }
        
        if let v: String = TM_Venue.manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherWind) {
            let windTokens = v.componentsSeparatedByString(" ")
            var speedVal : Double? = nil
            var speedDir : String? = nil
            if count(windTokens) == 4 {
                speedDir = windTokens[1]
                let speed = windTokens[3]
                let kphrange = speed.rangeOfString("kph")
                speedVal = (speed.substringToIndex(kphrange!.startIndex) as NSString).doubleValue
            }
            
            if (speedVal != nil && speedDir != nil) {
                self.weatherWindSpeed = speedVal!
                self.weatherWindDirection = speedDir!
            } else {
                self.weatherWindDirection = nil
                self.weatherWindSpeed = nil
            }
        } else {
            self.weatherWindDirection = nil
            self.weatherWindSpeed = nil
        }
        
        if let v: String = TM_Venue.manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherHumidity) {
            let humidityVal = v.stringByReplacingOccurrencesOfString("Humidity: ", withString: "").stringByReplacingOccurrencesOfString("%", withString: "")
            let doubleVal = (humidityVal as NSString).doubleValue
            if (doubleVal <= 100 && doubleVal >= 0) {
                self.weatherHumidity = doubleVal
            } else {
                self.weatherHumidity = nil
            }
        } else {
            self.weatherHumidity = nil
        }
        
        if let v: Int = TM_Venue.manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherTemp) {
            self.weatherTemp = v
        } else {
            self.weatherTemp = nil;
        }
        
        if let v: Int = TM_Venue.manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherFeelsLike) {
            self.weatherFeelsLike = v
        } else {
            self.weatherFeelsLike = nil
        }
    }
    
    private class func manifestValueForKey<T>(dictionary: Dictionary<String, AnyObject>, key: TM_Venue_ManifestKey) -> T? {
        let k = key.rawValue
        if let v = dictionary[k] as? T? {
            return v
        }
        // If the value is not nil, then assert it.
        assert([k].self == nil, "Could not find value for \(k)")
        return nil
    }
}
