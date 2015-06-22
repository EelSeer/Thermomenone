//
//  MasterViewController.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "TM_WeatherListingDataSource.h"
#import "Thermomenone-Swift.h"

@interface MasterViewController ()<TM_WeatherListingDataSourceDelegate, UIAlertViewDelegate>

@property NSMutableArray *objects;
@property (nonatomic, strong) TM_WeatherListingDataSource *dataSource;
@property (nonatomic, strong) UIAlertView *alert;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.dataSource = [[TM_WeatherListingDataSource alloc] initWithDelegate:self];
    [self.dataSource downloadListings];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TM_Venue *venue = self.objects[indexPath.row];
    cell.textLabel.text = venue.venueName;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - TMWeatherListingDataSourceDelegate Methods

- (void)weatherListingDataSource:(TM_WeatherListingDataSource *)dataSource didUpdateSearchResult:(NSMutableArray *)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.objects = result;
        [self.tableView reloadData];
    });
}

- (void)weatherListingDataSource:(TM_WeatherListingDataSource *)dataSource didFailToUpdateDataWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
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

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alert = nil;
}

@end
