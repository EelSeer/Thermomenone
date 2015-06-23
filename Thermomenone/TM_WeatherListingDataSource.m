//
//  TM_WeatherListingDataSource.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 22/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_WeatherListingDataSource.h"
#import "Thermomenone-Swift.h"

static NSString * const kWeatherListingEndPoint = @"http://dnu5embx6omws.cloudfront.net/venues/weather.json";
static NSString * const kDataKey = @"data";

static NSString * const kVenueIDKey = @"_venueID";
static NSString * const kVenueNameKey = @"_name";

static NSString * const kCountryIDKey = @"_countryID";
static NSString * const kCountryNameKey = @"_name";
static NSString * const kCountryKey = @"_country";

@interface TM_WeatherListingDataSource ()

@property (nonatomic, weak) id<TM_WeatherListingDataSourceDelegate> delegate;

@property (nonatomic, strong) NSDictionary *countries;
@property (nonatomic, strong) TM_WeatherListingSearchDescriptor *searchDescriptor;
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;

@end

@implementation TM_WeatherListingDataSource

- (instancetype)initWithDelegate:(id<TM_WeatherListingDataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _searchDescriptor = [[TM_WeatherListingSearchDescriptor alloc] init];
    }
    return self;
}

- (void)downloadListings {
    if (!self.downloadTask) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *endpoint = [NSURL URLWithString:kWeatherListingEndPoint];
        self.downloadTask = [session dataTaskWithURL:endpoint completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                if (self.delegate) {
                    [self.delegate weatherListingDataSource:self didFailToUpdateDataWithError:error];
                }
                return;
            }
            
            NSError *jsonError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (!dictionary || jsonError) {
                [self.delegate weatherListingDataSource:self didFailToUpdateDataWithError:error];
            }
            
            self.countries = [self parseVenues:dictionary[kDataKey]];
            self.lastUpdated = [NSDate date];
            [self updateSearchResults];
            self.downloadTask = nil;
        }];
    
        [self.downloadTask resume];
    }
}

- (NSDictionary *)parseVenues:(NSArray *)venues {
    NSMutableDictionary *countryDictionary = [self.countries mutableCopy];
    if (!countryDictionary) {
        countryDictionary = [NSMutableDictionary dictionary];
    }
    
    for (NSDictionary *venueDictionary in venues) {
        NSString *countryID = venueDictionary[kCountryKey][kCountryIDKey];
        TM_Country *country = countryDictionary[countryID];
        if (!country) {
            NSString *countryName = venueDictionary[kCountryKey][kCountryNameKey];
            if (countryName) {
                country = [[TM_Country alloc] initWithCountryName:countryName countryID:countryID.integerValue];
            } else {
                continue;
            }
        }
        
        NSString *venueID = venueDictionary[kVenueIDKey];
        TM_Venue *venue = country.venues[venueID];
        if (!venue) {
            NSString *venueName = venueDictionary[kVenueNameKey];
            venue = [[TM_Venue alloc] initWithVenueName:venueName venueID:[venueID integerValue]];
        }
        [venue updateVenue:venueDictionary];
        country.venues[venueID] = venue;
        countryDictionary[countryID] = country;
    }
    
    return [countryDictionary copy];
}

- (void)updateSearchResults {
    NSMutableArray *results = nil;
    
    if (!self.searchDescriptor.countryFilter) {
        results = [NSMutableArray array];
        for (TM_Country *country in [self.countries allValues]) {
            for (TM_Venue *venue in [country.venues allValues]) {
                [results addObject:venue];
            }
        }
    } else {
        TM_Country *country = self.countries[self.searchDescriptor.countryFilter];
        if (country) {
            results = [NSMutableArray arrayWithArray:[country.venues allValues]];
        }
    }
    
    if (results.count && self.searchDescriptor.conditionFilter) {
        [results filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TM_Venue *venue, NSDictionary *bindings) {
            return [venue.weatherCondition isEqualToString:self.searchDescriptor.conditionFilter];
        }]];
    }
    
    NSArray *result = [results sortedArrayUsingComparator:^NSComparisonResult(TM_Venue *obj1, TM_Venue *obj2) {
        switch (self.searchDescriptor.sortType) {
            case TM_ListingSortTypeAlphabetical:
                return [obj1.venueName compare:obj2.venueName];
                break;
            case TM_ListingSortTypeAlphabeticalReversed:
                return [obj2.venueName compare:obj1.venueName];
                break;
            case TM_ListingSortTypeTemperature:
                return [obj1.weatherTemp compare:obj2.weatherTemp];
                break;
            case TM_ListingSortTypeTemperatureReversed:
                return [obj2.weatherTemp compare:obj1.weatherTemp];
                break;
            case TM_ListingSortTypeLastUpdated:
                return [obj1.lastUpdated compare:obj2.lastUpdated];
                break;
        }
    }];
    
    [self.delegate weatherListingDataSource:self didUpdateSearchResult:result];
}

@end
