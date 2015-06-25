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

#pragma mark - Managing the detail item

- (void)setVenue:(TM_Venue *)venue {
    if (_venue != venue) {
        _venue = venue;
        [self configureView];
    }
}

- (void)configureView {
    if (self.venue) {
        [self configureTemperatureViews];
        [self configureConditionView];
        [self configureWindSpeedViews];
        [self configureHumidityView];
    }
}

- (void)configureTemperatureViews {
//    double degrees = [self.venue.weatherTemp doubleValue];
//    NSString *degreeString = @"Celsius";
//    double feelsLikeDegrees = [self.venue.weatherFeelsLike doubleValue];
//    
//    switch (self.degreeType) {
//        case TM_WeatherDetailDegreesFarhenheit:
//            degrees = [TM_Utilities celsiusToFahrenheit:degrees];
//            feelsLikeDegrees = [TM_Utilities celsiusToFahrenheit:feelsLikeDegrees];
//            degreeString = @"Fahrenheit";
//            break;
//        case TM_WeatherDetailDegreesKelvin:
//            degrees = [TM_Utilities celsiusToKelvin:degrees];
//            feelsLikeDegrees = [TM_Utilities celsiusToKelvin:feelsLikeDegrees];
//            degreeString = @"Kelvin";
//            break;
//        default:
//            break;
//    }
//    self.temperatureIsLabel.text = [NSString stringWithFormat:@"IT'S %.1f DEGREES", degrees];
//    [self.temperatureMeasurementButton setTitle:degreeString forState:UIControlStateNormal];
//    
//    if (degrees == feelsLikeDegrees) {
//        self.temperatureFeelsLikeLabel.text = @"THE THERMOMETER SAID SO";
//    } else {
//        self.temperatureFeelsLikeLabel.text = [NSString stringWithFormat:@"BUT IT FEELS LIKE %.1f DEGREES.\n SCIENCE IS WRONG AGAIN.", degrees];
//    }
}

- (void)configureConditionView {
//    if (self.venue.weatherCondition) {
//        self.conditionLabel.text = [NSString stringWithFormat:@"IT'S A %@ DAY IN %@", [self.venue.weatherCondition uppercaseString], self.venue.venueName];
//    } else {
//        self.conditionLabel.text = [NSString stringWithFormat:@"I DUNNO WHAT KIND OF DAY IT IS IN %@", self.venue.venueName];
//    }
}

- (void)configureWindSpeedViews {
//    double windspeed = [self.venue.weatherWindSpeed doubleValue];
//    NSString *windMeasurementString = @"k/ph";
//    if (!windspeed) {
//        self.windLabel.text = @"THE WIND IS YET STILL";
//        self.windSpeedMeasurementButton.hidden = YES;
//    } else {
//        switch (self.speedType) {
//            case TM_WeatherDetailSpeedMiles:
//                windspeed = [TM_Utilities kilometresToMiles:windspeed];
//                windMeasurementString = @"m/ph";
//                break;
//            case TM_WeatherDetailSpeedKnots:
//                windspeed = [TM_Utilities kilometresToKnots:windspeed];
//                windMeasurementString = @"knots";
//                break;
//            default:
//                break;
//        }
//        self.windSpeedMeasurementButton.hidden = NO;
//        self.windLabel.text = [NSString stringWithFormat:@"THE WIND IS GOING %@ AT %.1f", self.venue.weatherWindDirection, windspeed];
//        [self.windSpeedMeasurementButton setTitle:windMeasurementString forState:UIControlStateNormal];
//    }
}

- (void)configureHumidityView {
//    if (self.venue.weatherHumidity) {
//        if ([self.venue.weatherHumidity integerValue]) {
//            self.humidityLabel.text = [NSString stringWithFormat:@"THE AIR IS %.1f PERCENT WATER", self.venue.weatherHumidity.doubleValue];
//        } else {
//            self.humidityLabel.text = @"IT'S NOT HUMID";
//        }
//    }
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
