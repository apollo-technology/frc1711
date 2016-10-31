//
//  RankingsTableViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 4/4/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "RankingsTableViewController.h"
#import "TableViewCell.h"
#import "ATFRC.h"
#import <Parse/Parse.h>

@interface RankingsTableViewController (){
    UIRefreshControl *refreshControl;
}

@end

@implementation RankingsTableViewController

@synthesize rankings,event;

- (void)handleRefresh:(id)sender{
    // do your refresh here...
    [ATFRC rankingsForEvent:event.key completion:^(NSArray *data, BOOL succeeded) {
        if (data.count > 1) {
            rankings = [[NSMutableArray alloc] initWithArray:data];
            [rankings removeObjectAtIndex:0];
            [self.tableView reloadData];
        }
        [refreshControl endRefreshing];
    }];
}

-(void)goToRaptors{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = newBackButton;
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:0.400 green:0.694 blue:0.294 alpha:1.00];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UIBarButtonItem *raptorsButton = [[UIBarButtonItem alloc] initWithTitle:@"Raptors" style:UIBarButtonItemStylePlain target:self action:@selector(goToRaptors)];
    self.navigationItem.rightBarButtonItem = raptorsButton;
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
    return rankings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    NSString *rank = rankings[indexPath.row][0];
    NSString *team = rankings[indexPath.row][1];
    NSString *played = rankings[indexPath.row][2];
    NSString *seedingScore = rankings[indexPath.row][3];
    NSString *hanging = rankings[indexPath.row][5];
    
    // Configure the cell...
    cell.rankLabel.text = [NSString stringWithFormat:@"%@",rank];
    cell.teamLabel.text = [NSString stringWithFormat:@"Team: %@",team];
    cell.infoLabel.text = [NSString stringWithFormat:@"Played: %@\nSeeding Score: %@\nScaling Points: %@",played,seedingScore,hanging];
    PFUser *currentUser = [PFUser currentUser];
    if ([team isEqualToString:currentUser[@"team"]]) {
        cell.backgroundColor = [UIColor colorWithRed:0.400 green:0.694 blue:0.294 alpha:1.00];
        cell.rankLabel.textColor = [UIColor whiteColor];
        cell.teamLabel.textColor = [UIColor whiteColor];
        cell.infoLabel.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor clearColor];
        cell.rankLabel.textColor = [UIColor blackColor];
        cell.teamLabel.textColor = [UIColor blackColor];
        cell.infoLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

@end
