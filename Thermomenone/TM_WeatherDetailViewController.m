//
//  DetailViewController.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 21/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_WeatherDetailViewController.h"

typedef NS_ENUM(NSUInteger, TM_WeatherDetailDegreesType) {
    TM_WeatherDetailDegreesCelsius,
    TM_WeatherDetailDegreesFarhenheit,
    TM_WeatherDetailDegreesKelvin
};

typedef NS_ENUM(NSUInteger, TM_WeatherDetailSpeedType) {
    TM_WeatherDetailSpeedKilometres,
    TM_WeatherDetailSpeedMiles,
    TM_WeatherDetailSpeedKnots
};

@interface TM_WeatherDetailViewController ()
@property (nonatomic, assign) TM_WeatherDetailDegreesType degreeType;
@property (nonatomic, assign) TM_WeatherDetailSpeedType speedType;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation TM_WeatherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
//    [self.temperatureMeasurementButton setTitle:@"k/ph" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"d/M/yyyy h:mma";
    }
    return _dateFormatter;
}

#pragma mark - Managing the detail item

- (void)setVenue:(TM_Venue *)venue {
    if (_venue != venue) {
        _venue = venue;
        [self configureView];
    }
}

- (void)configureView {
    if (self.venue) {
        self.navigationItem.title = self.venue.venueName;
        [self configureTemperatureViews];
        [self configureConditionView];
        [self configureWindSpeedViews];
        [self configureHumidityView];
        if (self.venue.lastUpdated) {
            self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [self.dateFormatter stringFromDate:self.venue.lastUpdated]];
        } else {
            self.lastUpdatedLabel.text = @"Unknown";
        }
    } else {
        self.temperatureIsLabel.text = @"";
        self.temperatureFeelsLikeLabel.text = @"";
        self.windLabel.text = @"";
        self.conditionLabel.text = @"";
        self.humidityLabel.text = @"";
        self.lastUpdatedLabel.text = @"";
    }
}

- (void)configureTemperatureViews {
    if (self.venue.weatherTemp) {
        double degrees = [self.venue.weatherTemp doubleValue];
        double feelsLikeDegrees = [self.venue.weatherFeelsLike doubleValue];
        
        NSString *tempType = @"C";
        switch (self.degreeType) {
            case TM_WeatherDetailDegreesFarhenheit:
                degrees = [TM_Utilities celsiusToFahrenheit:degrees];
                feelsLikeDegrees = [TM_Utilities celsiusToFahrenheit:feelsLikeDegrees];
                tempType = @"F";
                break;
            case TM_WeatherDetailDegreesKelvin:
                degrees = [TM_Utilities celsiusToKelvin:degrees];
                feelsLikeDegrees = [TM_Utilities celsiusToKelvin:feelsLikeDegrees];
                tempType = @"K";
                break;
            default:
                break;
        }
        
        self.temperatureIsLabel.text = [NSString stringWithFormat:@"TEMP %.1f°%@", degrees, tempType];
        self.temperatureFeelsLikeLabel.text = [NSString stringWithFormat:@"FEELS %.1f°%@", feelsLikeDegrees, tempType];
    } else {
        self.temperatureIsLabel.text = @"Unknown";
        self.temperatureFeelsLikeLabel.text = @"";
    }
}

- (void)configureConditionView {
    if (self.venue.weatherCondition) {
        self.conditionLabel.text = [self.venue.weatherCondition uppercaseString];
    } else {
        self.conditionLabel.text = @"Unknown";
    }
    
    if (self.venue.weatherConditionIcon) {
        self.conditionImageView.image = [UIImage imageNamed:self.venue.weatherConditionIcon];
    } else {
        self.conditionImageView.image = [UIImage imageNamed:@"sunny"];
    }
}

- (void)configureWindSpeedViews {
    if (self.venue.weatherWindSpeed) {
        double windspeed = [self.venue.weatherWindSpeed doubleValue];
        NSString *windMeasurementString = @"k/ph";
        if (!windspeed) {
            self.windLabel.text = @"Still";
        } else {
//            switch (self.speedType) {
//                case TM_WeatherDetailSpeedMiles:
//                    windspeed = [TM_Utilities kilometresToMiles:windspeed];
//                    windMeasurementString = @"m/ph";
//                    break;
//                case TM_WeatherDetailSpeedKnots:
//                    windspeed = [TM_Utilities kilometresToKnots:windspeed];
//                    windMeasurementString = @"knots";
//                    break;
//                default:
//                    break;
//            }
            self.windLabel.text = [NSString stringWithFormat:@"%@ %.1f %@", self.venue.weatherWindDirection, windspeed, windMeasurementString];
        }
    } else {
        self.windLabel.text = @"Unknown";
    }
    
}

- (void)configureHumidityView {
    if (self.venue.weatherHumidity) {
        if ([self.venue.weatherHumidity integerValue]) {
            self.humidityLabel.text = [NSString stringWithFormat:@"%.1f%%", [self.venue.weatherHumidity doubleValue]];
        } else {
            self.humidityLabel.text = @"0%%";
        }
    } else {
        self.humidityLabel.text = @"Unknown";
    }
}

- (IBAction)didTapTemperatureMeasurementButton:(id)sender {
    if (self.degreeType == TM_WeatherDetailDegreesKelvin) {
        self.degreeType = TM_WeatherDetailDegreesCelsius;
    } else {
        self.degreeType++;
    }
    [self configureTemperatureViews];
}

- (IBAction)didTapWindSpeedMeasurementButton:(id)sender {
    if (self.speedType == TM_WeatherDetailSpeedMiles) {
        self.speedType = TM_WeatherDetailSpeedKilometres;
    } else {
        self.speedType++;
    }
    [self configureWindSpeedViews];
}

@end
