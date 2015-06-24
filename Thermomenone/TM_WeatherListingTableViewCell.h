//
//  TM_WeatherListingTableViewCell.h
//  Thermomenone
//
//  Created by Tom Rees-Lee on 24/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TM_WeatherListingTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *weatherIconView;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *countryLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdatedLabel;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@end
