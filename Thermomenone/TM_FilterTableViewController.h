//
//  TMFilterTableViewController.h
//  Thermomenone
//
//  Created by Tom Rees-Lee on 23/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TM_WeatherListingDataSource.h"

@protocol TM_FilterTableViewControllerDelegate;

@interface TM_FilterTableViewController : UITableViewController

@property (nonatomic, strong) TM_WeatherListingDataSource *dataSource;
@property (nonatomic, weak) id<TM_FilterTableViewControllerDelegate> delegate;
@end

@protocol TM_FilterTableViewControllerDelegate <NSObject>

- (void)filterTableViewController:(TM_FilterTableViewController *)filterTableViewController didUpdateDataSource:(TM_WeatherListingDataSource *)dataSource;

@end