//
//  TM_Country.swift
//  Thermomenone
//
//  Created by Tom Rees-Lee on 22/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

import Foundation

public class TM_Country : NSObject {
    public let countryName: String
    public let countryID: String
    
    public init(countryName: String, countryID: String) {
        assert(count(countryName) > 0, "Empty String passed on TMVenue initializer");
        self.countryName = countryName
        self.countryID = countryID
        self.venues = NSMutableDictionary()
    }
    
    public var venues: NSMutableDictionary
}