//
//  MasterViewController.h
//  Thermomenone
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TM_WeatherDetailViewController;

@interface TM_WeatherListingViewController : UITableViewController

@property (strong, nonatomic) TM_WeatherDetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end

