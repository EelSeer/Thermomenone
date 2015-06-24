//
//  TM_RefineTableViewController.h
//  Thermomenone
//
//  Created by Tom Rees-Lee on 23/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TM_WeatherListingDataSource.h"

@interface TM_RefineTableViewController : UITableViewController

@property (strong, nonatomic) TM_WeatherListingDataSource *dataSource;
- (IBAction)clearButtonTapped:(id)sender;
@end
