//
//  TM_RefineTableViewController.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 23/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_RefineTableViewController.h"
#import "Thermomenone-Swift.h"

#import "TM_FilterTableViewController.h"

typedef NS_ENUM(NSUInteger, TM_RefineTableSections) {
    TMRefineTableSortSection,
    TMRefineTableFilterSection
};

typedef NS_ENUM(NSUInteger, TM_RefineTableFilterRows) {
    TMRefineTableFilterCountryRow,
    TMRefineTableFilterConditionRow
};


@interface TM_RefineTableViewController ()<TM_FilterTableViewControllerDelegate>
@property (nonatomic, strong) NSIndexPath *selectedSortIndex;
@property (nonatomic, assign) TM_RefineTableFilterRows selectedFilterRow;
@end

@implementation TM_RefineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.dataSource updateListings:NO];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case TMRefineTableSortSection:
            if (indexPath.row != self.dataSource.searchDescriptor.sortType) {
                UITableViewCell *priorSelected = [tableView cellForRowAtIndexPath:self.selectedSortIndex];
                priorSelected.accessoryType = UITableViewCellAccessoryNone;
                self.selectedSortIndex = indexPath;
                self.dataSource.searchDescriptor.sortType = indexPath.row;
                selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        case TMRefineTableFilterSection:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case TMRefineTableSortSection:
            if (indexPath.row == self.dataSource.searchDescriptor.sortType) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.selectedSortIndex = indexPath;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        case TMRefineTableFilterSection:
            if (indexPath.row == TMRefineTableFilterCountryRow) {
                NSString *countryID = self.dataSource.searchDescriptor.countryFilter;
                if (countryID.length) {
                    TM_Country *country = self.dataSource.countries[countryID];
                    cell.detailTextLabel.text = country.countryName;
                } else {
                    cell.detailTextLabel.text = @"All";
                }
            } else if (indexPath.row == TMRefineTableFilterConditionRow) {
                NSString *conditionFilter = self.dataSource.searchDescriptor.conditionFilter;
                if (conditionFilter.length) {
                    cell.detailTextLabel.text = conditionFilter;
                } else {
                    cell.detailTextLabel.text = @"All";
                }
            }
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showCondition"] ||
        [[segue identifier] isEqualToString:@"showCountry"]) {
        TM_FilterTableViewController *controller = (TM_FilterTableViewController *)[segue destinationViewController];
        controller.dataSource = self.dataSource;
        controller.delegate = self;
    }
}

- (void)dismissPicker {
    [UIView animateWithDuration:0.6f animations:^{
    }];
}

#pragma mark - TM_FilterTableViewController Delegate

- (void)filterTableViewController:(TM_FilterTableViewController *)filterTableViewController didUpdateDataSource:(TM_WeatherListingDataSource *)dataSource {
    [self.tableView reloadData];
}


//// returns the # of rows in each component..
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    switch (self.selectedFilterRow) {
//        case TMRefineTableFilterCountryRow:
//            return [self.countries count]+1;
//            break;
//        case TMRefineTableFilterConditionRow:
//            return [TM_Venue weatherTypes].count+1;
//            break;
//    }
//}
//
//#pragma mark - UIPickerViewDelegate
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    switch (self.selectedFilterRow) {
//        case TMRefineTableFilterCountryRow:
//            self.dataSource.searchDescriptor.countryFilter = (row == 0) ? nil : [self.countries[row-1] countryID];
//            break;
//        case TMRefineTableFilterConditionRow:
//            self.dataSource.searchDescriptor.conditionFilter = (row == 0) ? nil : [TM_Venue weatherTypes][row-1];
//            break;
//    }
//}
//
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    switch (self.selectedFilterRow) {
//        case TMRefineTableFilterCountryRow:
//            if (row == 0) {
//                return @"All";
//            }
//            return [self.countries[row-1] countryName];
//            break;
//        case TMRefineTableFilterConditionRow:
//            if (row == 0) {
//                return @"All";
//            }
//            return [TM_Venue weatherTypes][row-1];
//            break;
//    }
//}


@end
