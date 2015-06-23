//
//  TM_WeatherListingSearchDescriptor.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 22/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_WeatherListingSearchDescriptor.h"

@implementation TM_WeatherListingSearchDescriptor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.countryFilter = nil;
        self.conditionFilter = nil;
        self.sortType = TM_ListingSortTypeAlphabetical;
    }
    return self;
}

@end
