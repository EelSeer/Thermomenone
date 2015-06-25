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
    case country = "_country"
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
    public let venueID: String
    public init(venueName: String, venueID: String) {
        assert(count(venueName) > 0, "Empty String passed on TMVenue initializer");
        self.venueName = venueName
        self.venueID = venueID
    }

    public var country: String?
    public var countryID: String?
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
    
    //There's got to be a definitive list of weatherTypes somewhere and TM_Venue looks like the place to put it.
    public class func weatherTypes() -> Array<String> {
        return ["Clear",
            "Cloudy",
            "Fog",
            "Haze",
            "Mist",
            "Mostly Cloudy",
            "Partly Cloudy",
            "Scattered Clouds",
            "Overcast",
            "Rain",
            "Smoke",
            "Snow",
            "Thunderstorm",
            "Sunny"
        ]
    }
    
    public func updateVenue(venueDictionary: Dictionary<String, AnyObject>) {
        //check that venue name and ID are correct. we don't want to update at all if we got the wrong venue here.
        if let v: String = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.venueName) {
            if self.venueName != v {
                return
            }
        }
        
        if let v: String = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.venueID) {
            if v != self.venueID {
                return
            }
        }
        
        if let countryDictionary: Dictionary<String, AnyObject> = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.country) {
            if let v: String = manifestValueForKey(countryDictionary, key: TM_CountryKey.countryName) {
                if self.country == nil {
                    self.country = v
                } else if self.country != v {
                    return
                }
            }

            if let v: String = manifestValueForKey(countryDictionary, key: TM_CountryKey.countryID) {
                if self.countryID == nil {
                    self.countryID = v
                } else if self.countryID != v {
                    return
                }
            }
        }

        if let v: NSNumber = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherLastUpdated) {
            let lastUpdateDate = NSDate(timeIntervalSince1970: v.doubleValue)
            if self.lastUpdated == nil || lastUpdateDate.compare(self.lastUpdated!) == NSComparisonResult.OrderedAscending {
                self.lastUpdated = lastUpdateDate
            } else {
                return
            }
        } else {
            self.lastUpdated = nil
        }

        if let v: String = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherCondition) {
            self.weatherCondition = v
        } else {
            self.weatherCondition = nil
        }
        
        if let v: String = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherConditionIcon) {
            switch v {
            case "storm":
                self.weatherConditionIcon = "tstorm"
            case "clear", "partlycloudy":
                self.weatherConditionIcon = v+"_day"
            default:
                self.weatherConditionIcon = v
            }
        } else {
            self.weatherConditionIcon = nil
        }
        
        if let v: String = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherWind) {
            let windvals = convertWindString(v)
            self.weatherWindSpeed = windvals.windSpeed
            self.weatherWindDirection = windvals.windDir
        } else {
            self.weatherWindDirection = nil
            self.weatherWindSpeed = nil
        }
        
        if let v: String = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherHumidity) {
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
        
        if let v: String = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherTemp) {
            self.weatherTemp = v.toInt()
        } else {
            self.weatherTemp = nil;
        }
        
        if let v: String = manifestValueForKey(venueDictionary, key: TM_Venue_ManifestKey.weatherFeelsLike) {
            self.weatherFeelsLike = v.toInt()
        } else {
            self.weatherFeelsLike = nil
        }
    }
    
    private func convertWindString(windString: String) -> (windDir: String?, windSpeed: Double?) {
        let windTokens = windString.componentsSeparatedByString(" ")
        var windSpeed : Double? = nil
        var windDir : String? = nil
        if count(windTokens) == 4 {
            windDir = windTokens[1]
            let speed = windTokens[3]
            let kphrange = speed.rangeOfString("kph")
            windSpeed = (speed.substringToIndex(kphrange!.startIndex) as NSString).doubleValue
        }
        if (windDir != nil && windSpeed != nil) {
            return (windDir!, windSpeed!)
        } else {
            return (nil, nil)
        }
    }
    
    private func manifestValueForKey<T>(dictionary: Dictionary<String, AnyObject>, key: TM_Venue_ManifestKey) -> T? {
        let k = key.rawValue
        return manifestValueForKey(dictionary, key: k)
    }
    
    private func manifestValueForKey<T>(dictionary: Dictionary<String, AnyObject>, key: TM_CountryKey) -> T? {
        let k = key.rawValue
        return manifestValueForKey(dictionary, key: k)
    }
    
    private func manifestValueForKey<T>(dictionary: Dictionary<String, AnyObject>, key: String) -> T? {
        if let v = dictionary[key] as? T? {
            return v
        }
        // If the value is not nil, then assert it.
        assert([key].self == nil, "Could not find value for \(key)")
        return nil
    }
}
