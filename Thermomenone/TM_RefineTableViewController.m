//
//  TM_RefineTableViewController.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 23/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_RefineTableViewController.h"

typedef NS_ENUM(NSUInteger, TM_RefineTableSections) {
    TMRefineTableSortSection,
    TMRefineTableFilterSection
};

typedef NS_ENUM(NSUInteger, TM_RefineTableFilterRows) {
    TMRefineTableFilterCountryRow,
    TMRefineTableFilterConditionRow
};


@interface TM_RefineTableViewController ()
@property (nonatomic, strong) NSIndexPath *selectedSortIndex;
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
            break;
    }
    
    return cell;
}

@end
