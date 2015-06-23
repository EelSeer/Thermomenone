//
//  ThermomenoneTests.m
//  ThermomenoneTests
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ThermomenoneTests-Swift.h"
@interface ThermomenoneTests : XCTestCase

@end

@implementation ThermomenoneTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTMVenue {
    NSString *venueName = @"Adelaide River";

    TM_Venue *riverVenue = [[TM_Venue alloc] initWithVenueName:venueName venueID:@"97"];
    XCTAssert([riverVenue.venueName isEqualToString:venueName], "TM_Venue didn't have correct name on creation.");
    
    NSDictionary *riverVenueDictionary = @{
                                @"_venueID" : @"97",
                                @"_name" : @"Adelaide River",
                                @"_country" : @{
                                        @"_countryID" : @"16",
                                        @"_name" : @"Australia"
                                        },
                                @"_weatherCondition" : @"Partly Cloudy",
                                @"_weatherConditionIcon" : @"partlycloudy",
                                @"_weatherWind" : @"Wind: ESE at 17kph",
                                @"_weatherHumidity" : @"Humidity: 65%",
                                @"_weatherTemp" : @"27",
                                @"_weatherFeelsLike" : @"34",
                                @"_sport" : @{
                                        @"_sportID" : @"1",
                                        @"_description" : @"Horse Racing"
                                        },
                                @"_weatherLastUpdated" : @1401666605
                                };

    [riverVenue updateVenue:riverVenueDictionary];
    XCTAssert([riverVenue.venueName isEqualToString:venueName]);
    XCTAssert([riverVenue.venueID isEqualToString:@"97"]);
    XCTAssert([riverVenue.country isEqualToString:@"Australia"]);
    XCTAssert([riverVenue.weatherCondition isEqualToString:@"Partly Cloudy"]);
    XCTAssert([riverVenue.weatherConditionIcon isEqualToString:@"partlycloudy"]);
    XCTAssert([riverVenue.weatherWindDirection isEqualToString:@"ESE"]);
    XCTAssert(riverVenue.weatherWindSpeed.integerValue == 17);
    XCTAssert(riverVenue.weatherFeelsLike.integerValue == 34);
    XCTAssert(riverVenue.weatherTemp.integerValue == 27);
    XCTAssert(riverVenue.weatherHumidity.doubleValue == 65);
    XCTAssert([riverVenue.lastUpdated compare:[NSDate dateWithTimeIntervalSince1970:1401666605]] == NSOrderedSame);
    
    NSDictionary *colacVenueDictionary = @{
                                           @"_venueID" : @"102",
                                           @"_name" : @"Colac",
                                           @"_country" : @{
                                                   @"_countryID" : @"16",
                                                   @"_name" : @"Australia"
                                                   },
                                           @"_sport" : @{
                                                   @"_sportID" : @"1",
                                                   @"_description" : @"Horse Racing"
                                                   },
                                           };
    
    //Nothing should change since the name does not match the original.
    XCTAssert([riverVenue.venueName isEqualToString:venueName]);
    XCTAssert([riverVenue.venueID isEqualToString:@"97"]);
    XCTAssert([riverVenue.country isEqualToString:@"Australia"]);
    XCTAssert([riverVenue.weatherCondition isEqualToString:@"Partly Cloudy"]);
    XCTAssert([riverVenue.weatherConditionIcon isEqualToString:@"partlycloudy"]);
    XCTAssert([riverVenue.weatherWindDirection isEqualToString:@"ESE"]);
    XCTAssert(riverVenue.weatherWindSpeed.integerValue == 17);
    XCTAssert(riverVenue.weatherFeelsLike.integerValue == 34);
    XCTAssert(riverVenue.weatherTemp.integerValue == 27);
    XCTAssert(riverVenue.weatherHumidity.doubleValue == 65);
    XCTAssert([riverVenue.lastUpdated compare:[NSDate dateWithTimeIntervalSince1970:1401666605]] == NSOrderedSame);
    
    NSDictionary *shortRiverVenueDictionary = @{
                                                @"_venueID" : @"97",
                                                @"_name" : @"Adelaide River",
                                                @"_country" : @{
                                                        @"_countryID" : @"16",
                                                        @"_name" : @"Australia"
                                                        },
                                                @"_sport" : @{
                                                        @"_sportID" : @"1",
                                                        @"_description" : @"Horse Racing"
                                                        },
                                                };
    [riverVenue updateVenue:shortRiverVenueDictionary];
    XCTAssert([riverVenue.venueName isEqualToString:venueName]);
    XCTAssert([riverVenue.country isEqualToString:@"Australia"]);
    XCTAssert(!riverVenue.weatherConditionIcon);
    XCTAssert(!riverVenue.weatherCondition);
    XCTAssert(!riverVenue.weatherWindDirection);
    XCTAssert(!riverVenue.weatherWindSpeed);
    XCTAssert(!riverVenue.weatherFeelsLike);
    XCTAssert(!riverVenue.weatherTemp);
    XCTAssert(!riverVenue.weatherHumidity);
    XCTAssert(!riverVenue.lastUpdated);

    TM_Venue *colacVenue = [[TM_Venue alloc] initWithVenueName:@"Colac" venueID:@"102"];
    [colacVenue updateVenue:colacVenueDictionary];
    XCTAssert([colacVenue.venueName isEqualToString:@"Colac"]);
    XCTAssert([riverVenue.country isEqualToString:@"Australia"]);
    XCTAssert(!colacVenue.weatherConditionIcon);
    XCTAssert(!colacVenue.weatherCondition);
    XCTAssert(!colacVenue.weatherWindDirection);
    XCTAssert(!colacVenue.weatherWindSpeed);
    XCTAssert(!colacVenue.weatherFeelsLike);
    XCTAssert(!colacVenue.weatherTemp);
    XCTAssert(!colacVenue.weatherHumidity);
    XCTAssert(!colacVenue.lastUpdated);
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
