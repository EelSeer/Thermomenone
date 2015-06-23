//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TM_ListingSortType) {
    TM_ListingSortTypeAlphabetical,
    TM_ListingSortTypeAlphabeticalReversed,
    TM_ListingSortTypeTemperature,
    TM_ListingSortTypeTemperatureReversed,
    TM_ListingSortTypeLastUpdated
};

@interface TM_WeatherListingSearchDescriptor : NSObject

@property (nonatomic, copy) NSString *countryFilter;
@property (nonatomic, copy) NSString *conditionFilter;
@property (nonatomic, assign) TM_ListingSortType sortType;

@end