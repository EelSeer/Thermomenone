//
//  TM_ConditionFilterTableViewController.m
//  Thermomenone
//
//  Created by Tom Rees-Lee on 23/06/2015.
//  Copyright (c) 2015 Hovercraft. All rights reserved.
//

#import "TM_ConditionFilterTableViewController.h"
#import "Thermomenone-Swift.h"

@interface TM_ConditionFilterTableViewController ()
@property (nonatomic, strong) NSArray *conditions;

@end

@implementation TM_ConditionFilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conditions = [TM_Venue weatherTypes];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [TM_Venue weatherTypes].count+1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.textLabel.text = @"All";
    } else {
        cell.textLabel.text = self.conditions[indexPath.row-1];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConditionCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.dataSource.searchDescriptor.conditionFilter = nil;
    } else {
        self.dataSource.searchDescriptor.conditionFilter = self.conditions[indexPath.row-1];
    }
    [self.delegate filterTableViewController:self didUpdateDataSource:self.dataSource];
}

@end
