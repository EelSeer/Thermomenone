//
//  TM_Utilities.swift
//  Thermomenone
//
//  Created by Tom Rees-Lee on 24/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

import Foundation

@objc public class TM_Utilities : NSObject {
    @objc public class func celsiusToFahrenheit(degrees: Double) -> Double {
        return (degrees*1.8)+30
    }
    
    @objc public class func celsiusToKelvin(degrees: Double) -> Double {
        return degrees+273.15
    }
    
    @objc public class func kilometresToMiles(kilometres: Double) -> Double {
        return kilometres/0.62137
    }
    
    @objc public class func kilometresToKnots(kilometres: Double) -> Double {
        return kilometres*0.539957
    }
    
}