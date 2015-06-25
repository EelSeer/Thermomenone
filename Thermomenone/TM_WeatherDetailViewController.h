//
//  DetailViewController.h
//  Thermomenone
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thermomenone-Swift.h"
@interface TM_WeatherDetailViewController : UIViewController

@property (strong, nonatomic) TM_Venue *venue;

@property (weak, nonatomic) IBOutlet UILabel *temperatureIsLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureFeelsLikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
//@property (weak, nonatomic) IBOutlet UIButton *temperatureMeasurementButton;
//@property (weak, nonatomic) IBOutlet UIButton *windSpeedMeasurementButton;

- (IBAction)didTapTemperatureMeasurementButton:(id)sender;
- (IBAction)didTapWindSpeedMeasurementButton:(id)sender;

@end

