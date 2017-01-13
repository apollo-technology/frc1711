//
//  ScoutingTableVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/9/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ScoutingTableVC.h"
#import "IonIcons.h"
#import "ATColors.h"
#import "ScoutingCell.h"
#import "ParseDB.h"
#import "ATFRC.h"
#import "ScoutingMatchView.h"

@interface ScoutingTableVC (){
	IBOutlet UIBarButtonItem *resetButton;
	UITextField *keyField;
	UIRefreshControl *refreshControl;
}

@end

@implementation ScoutingTableVC

- (void)handleRefresh:(id)sender{
	// do your refresh here...
	[ParseDB getScouting:^(NSError *error, BOOL succeeded) {
		if (succeeded) {
			[self.tableView reloadData];
			[refreshControl endRefreshing];
		} else {
			NSString *errorDescription;
			if (error) {
				errorDescription = error.localizedDescription;
			}
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error Getting Data" message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:alertController animated:YES completion:nil];
		}
	}];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	refreshControl = [[UIRefreshControl alloc] init];
	refreshControl.tintColor = [ATColors raptorGreen];
	[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
	
	[ParseDB getScouting:^(NSError *error, BOOL succeeded) {
		[self.tableView reloadData];
		if (!succeeded) {
			NSString *errorDescription;
			if (error) {
				errorDescription = error.localizedDescription;
			}
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error Getting Data" message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:alertController animated:YES completion:nil];
		}
	}];
	
	resetButton.image = [IonIcons imageWithIcon:ioniostrashoutline color:[ATColors raptorGreen]];
	
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
    return [[[ParseDB data] matches] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoutingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
	PDBSMatch *match = [[[ParseDB data] matches] objectAtIndex:[indexPath row]];
	cell.numberLabel.text = [NSString stringWithFormat:@"Match: %i",match.number];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ScoutingMatchView *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingMatchView"];
	newView.match = [[[ParseDB data] matches] objectAtIndex:[indexPath row]];
	[self.navigationController pushViewController:newView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
