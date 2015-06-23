//
//  TM_WeatherListingDataSource.h
//  Thermomenone
//
//  Created by Tom Rees-Lee on 22/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TM_WeatherListingSearchDescriptor.h"

@protocol TM_WeatherListingDataSourceDelegate;

@interface TM_WeatherListingDataSource : NSObject

- (instancetype)initWithDelegate:(id<TM_WeatherListingDataSourceDelegate>)delegate;


- (void)updateListings:(BOOL)fetchNewFeed;

@property (nonatomic, strong, readonly) TM_WeatherListingSearchDescriptor *searchDescriptor;
@property (nonatomic, strong, readonly) NSDictionary *countries;
@property (nonatomic, strong) NSDate *lastUpdated;


@end

@protocol TM_WeatherListingDataSourceDelegate <NSObject>

- (void)weatherListingDataSource:(TM_WeatherListingDataSource *)dataSource didUpdateSearchResult:(NSArray *)result;
- (void)weatherListingDataSource:(TM_WeatherListingDataSource *)dataSource didFailToUpdateDataWithError:(NSError *)error;

@end