//
//  GSScoutingTableVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/8/16. WHOA hi buddy!
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "GSScoutingTableVC.h"
#import "ParseDB.h"
#import "IonIcons.h"
#import "ATColors.h"
#import "GSScoutingCell.h"
#import "GSScoutingDetailVC.h"

@interface GSScoutingTableVC (){
	IBOutlet UIBarButtonItem *resetButton;
	IBOutlet UIBarButtonItem *exportButton;
	
	UITextField *keyField;
	
	UIRefreshControl *refreshControl;
}

@end

@implementation GSScoutingTableVC

- (void)handleRefresh:(id)sender{
	// do your refresh here...
	[ParseDB getScouting:^(NSError *error, BOOL succeeded) {
		[self.tableView reloadData];
		[refreshControl endRefreshing];
	}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	[ParseDB getScouting:^(NSError *error, BOOL succeeded) {
		[self.tableView reloadData];
	}];
	
	refreshControl = [[UIRefreshControl alloc] init];
	refreshControl.tintColor = [ATColors raptorGreen];
	[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
	
	resetButton.image = [IonIcons imageWithIcon:ioniostrashoutline color:[ATColors raptorGreen]];
	exportButton.image = [IonIcons imageWithIcon:ioniosflaskoutline color:[ATColors raptorGreen]];
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
    return [[[ParseDB data] teams] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GSScoutingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
	PDBGSTeam *team = [[[ParseDB data] teams] objectAtIndex:indexPath.row];
	cell.teamNumberLabel.text = [NSString stringWithFormat:@"%i",team.number];
	cell.teamNameLabel.text = team.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	GSScoutingDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
	detailVC.team = [[[ParseDB data] teams] objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
