//
//  DetailViewController.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_WeatherDetailViewController.h"

@interface TM_WeatherDetailViewController ()

@end

@implementation TM_WeatherDetailViewController

#pragma mark - Managing the detail item

- (void)setVenue:(TM_Venue *)venue {
    if (_venue != venue) {
        venue = venue;
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.venue) {
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
