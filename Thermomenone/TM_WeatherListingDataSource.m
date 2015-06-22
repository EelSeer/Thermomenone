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
static NSString * const kVenueNameKey = @"_venueName";

static NSString * const kCountryIDKey = @"_countryID";
static NSString * const kCountryNameKey = @"_countryName";
static NSString * const kCountryKey = @"_country";

@interface TM_WeatherListingDataSource ()

@property (nonatomic, weak) id<TM_WeatherListingDataSourceDelegate> delegate;
@property (nonatomic, strong) TM_WeatherListingSearchDescriptor *searchDescriptor;

@property (nonatomic, strong) NSDictionary *countries;

@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;

@end

@implementation TM_WeatherListingDataSource

- (instancetype)initWithDelegate:(id<TM_WeatherListingDataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
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
        NSNumber *countryID = venueDictionary[kCountryKey][kCountryIDKey];
        TM_Country *country = countryDictionary[countryID];
        if (!country) {
            NSString *countryName = venueDictionary[kCountryNameKey];
            if (countryName) {
                country = [[TM_Country alloc] initWithCountryName:countryName countryID:countryID.integerValue];
            } else {
                continue;
            }
        }
        
        NSNumber *venueID = venueDictionary[kVenueIDKey];
        TM_Venue *venue = country.venues[venueID];
        if (!venue) {
            NSString *venueName = venueDictionary[kVenueNameKey];
            venue = [[TM_Venue alloc] initWithVenueName:venueName venueID:[venueID integerValue]];
        }
        [venue updateVenue:venueDictionary];
        country.venues[venueID] = venue;
    }
    
    return [countryDictionary copy];
}

- (void)updateSearchResults {
    //not using sort descriptor yet. Just wanna test perf and feedfetcher.
    NSMutableArray *results = [NSMutableArray array];
    for (TM_Country *country in self.countries) {
        for (TM_Venue *venue in [country.venues allValues]) {
            [results addObject:venue];
        }
    }
    
    [self.delegate weatherListingDataSource:self didUpdateSearchResult:results];
}

- (void)setSearchDescriptor:(TM_WeatherListingSearchDescriptor *)searchDescriptor {
    _searchDescriptor = searchDescriptor;
    [self updateSearchResults];
}

@end
