//
//  TM_CountryFilterTableViewController.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 23/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_CountryFilterTableViewController.h"
#import "Thermomenone-Swift.h"
@interface TM_CountryFilterTableViewController ()<UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSArray *countries;
@property (nonatomic, strong) NSArray *searchedCountries;

@end

@implementation TM_CountryFilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.dataSource, @"No datasource passed to country filter table");
    self.countries = [[self.dataSource.countries allValues] sortedArrayUsingComparator:^NSComparisonResult(TM_Country *obj1, TM_Country *obj2) {
        return [obj1.countryName compare:obj2.countryName];
    }];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Configure the search bar with scope buttons and add it to the table view header
    self.searchController.searchBar.scopeButtonTitles = @[];
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        return self.countries.count;
    } else {
        return self.searchedCountries.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    if (!self.searchController.active) {
//        TM_Country *country = self.countries[indexPath.row];
//        if (self.dataSource.searchDescriptor.countryFilter.length) {
//            if ([self.dataSource.searchDescriptor.countryFilter isEqualToString:country.countryID]) {
//                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
//            }
//        }
//    }
//    return cell;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TM_Country *country = nil;
    if (!self.searchController.active) {
        country = self.countries[indexPath.row];
    } else {
        country = self.searchedCountries[indexPath.row];
    }
    cell.textLabel.text = country.countryName;
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TM_Country *country = nil;
    if (!self.searchController.active) {
        country = self.countries[indexPath.row];
    } else {
        country = self.searchedCountries[indexPath.row];
    }
    
    self.dataSource.searchDescriptor.countryFilter = country.countryID;
    [self.delegate filterTableViewController:self didUpdateDataSource:self.dataSource];
}

#pragma mark - UISearchResultsUpdating Methods

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    self.searchedCountries = [self.countries filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(TM_Country *country, NSDictionary *bindings) {
        return [[country.countryName lowercaseString] hasPrefix:[searchString lowercaseString]];
    }]];
    [self.tableView reloadData];
}

@end
