//
//  MasterViewController.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_WeatherListingViewController.h"
#import "TM_WeatherDetailViewController.h"
#import "TM_RefineTableViewController.h"
#import "TM_WeatherListingTableViewCell.h"

#import "TM_WeatherListingDataSource.h"
#import "Thermomenone-Swift.h"

@interface TM_WeatherListingViewController ()<TM_WeatherListingDataSourceDelegate, UIAlertViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIToolbarDelegate>

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) NSArray *searchedObjects;

@property (nonatomic, strong) TM_WeatherListingDataSource *dataSource;
@property (nonatomic, strong) UIAlertView *alert;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) UIAlertController *sortAlertController;

@end

@implementation TM_WeatherListingViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (TM_WeatherDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(considerRefreshingData:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Configure the search bar with scope buttons and add it to the table view header
    self.searchController.searchBar.scopeButtonTitles = @[];
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlPulled:) forControlEvents:UIControlEventValueChanged];
    
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"h:mma";
    }
    
    self.dataSource = [[TM_WeatherListingDataSource alloc] initWithDelegate:self];
    [self.dataSource updateListings:YES];
    
}

- (void)refreshControlPulled:(UIRefreshControl *)sender {
    [self.dataSource updateListings:YES];
}

- (void)considerRefreshingData:(NSNotification *)notification {
    NSDate *date = [NSDate date];
    if (date.timeIntervalSince1970 - self.dataSource.lastUpdated.timeIntervalSince1970 > 300) {
        [self.dataSource updateListings:YES];
    }
}

- (void)updateCurrentVenue {
    if (self.detailViewController.venue) {
        NSString *venueID = self.detailViewController.venue.venueID;
        NSString *countryID = self.detailViewController.venue.countryID;
        TM_Country *country = self.dataSource.countries[countryID];
        if (country) {
            TM_Venue *venue = country.venues[venueID];
            if (venue) {
                self.detailViewController.venue = venue;
            }
        }
    } else {
        self.detailViewController.venue = [self.objects firstObject];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TM_Venue *venue = self.objects[indexPath.row];
        TM_WeatherDetailViewController *controller = (TM_WeatherDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setVenue:venue];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.navigationItem.title = venue.venueName
        ;
    }
    
    if ([[segue identifier] isEqualToString:@"showRefine"]) {
        TM_RefineTableViewController *controller = (TM_RefineTableViewController *)[segue destinationViewController];
        controller.dataSource = self.dataSource;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        return self.objects.count;
    } else {
        return self.searchedObjects.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TM_Venue *venue = self.objects[indexPath.row];
    if (!self.searchController.active) {
        venue = self.objects[indexPath.row];
    } else {
        venue = self.searchedObjects[indexPath.row];
    }
    
    TM_WeatherListingTableViewCell *listingCell = (TM_WeatherListingTableViewCell *)cell;
    listingCell.locationLabel.text = venue.venueName;
    listingCell.countryLabel.text = venue.country;
    if (venue.weatherTemp) {
        listingCell.temperatureLabel.text = [NSString stringWithFormat:@"%ld°C", [venue.weatherTemp longValue]];
    } else {
        listingCell.temperatureLabel.text = @"-";
    }
    
    if (venue.lastUpdated) {
        NSString *dateString = [self.dateFormatter stringFromDate:venue.lastUpdated];
        listingCell.lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", dateString];
    }
    
    if (venue.weatherConditionIcon) {
        listingCell.weatherIconView.image = [UIImage imageNamed:venue.weatherConditionIcon];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - TMWeatherListingDataSourceDelegate Methods

- (void)weatherListingDataSourceWillFetchData:(TM_WeatherListingDataSource *)dataSource {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl beginRefreshing];
    });
}


- (void)weatherListingDataSource:(TM_WeatherListingDataSource *)dataSource didUpdateSearchResult:(NSMutableArray *)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        self.objects = result;
        NSString *dateString = [[self.dateFormatter stringFromDate:self.dataSource.lastUpdated] lowercaseString];
        self.navItem.title = [NSString stringWithFormat:@"Last Updated: %@", dateString];
        [self updateCurrentVenue];
        [self.tableView reloadData];
    });
}

- (void)weatherListingDataSource:(TM_WeatherListingDataSource *)dataSource didFailToUpdateDataWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        if (!self.alert) {
            self.alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong."
                                                    message:@"We weren't able to update the weather for you. Please try again later."
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
            [self.alert show];
        }
    });
}

#pragma mark - UISearchResultsUpdating Methods

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    self.searchedObjects = [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TM_Venue *venue, NSDictionary *bindings) {
        return [[venue.venueName lowercaseString] hasPrefix:[searchString lowercaseString]];
    }]];
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alert = nil;
}

@end
