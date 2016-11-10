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
#import "ATScouting.h"
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
	[self.tableView reloadData];
	[refreshControl endRefreshing];
}

-(void)resetTheDangDB{
	[ATScouting setDatabaseForEvent:keyField.text block:^(NSError *error, BOOL succeeded) {
		if (!succeeded) {
			NSString *errorMessage;
			if (error) {
				errorMessage = error.localizedDescription;
			}
			[self dismissViewControllerAnimated:YES completion:^{
				UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error, Try again!" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
				[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
				[self presentViewController:alertController animated:YES completion:nil];
			}];
		} else {
			[self dismissViewControllerAnimated:YES completion:^{
				[self.tableView reloadData];
			}];
		}
	}];
}

-(IBAction)resetButton:(id)sender{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please enter the Event Key" message:@"Event Keys are found on an event page in the database tab of the app!" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = @"Event Key";
		textField.text = @"";
		textField.returnKeyType = UIReturnKeyNext;
		textField.keyboardType = UIKeyboardTypeDefault;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField.secureTextEntry = NO;
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.spellCheckingType = UITextSpellCheckingTypeNo;
		keyField = textField;
	}];
	[alertController addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.center = CGPointMake(130.5, 80);
		spinner.color = [UIColor grayColor];
		[spinner startAnimating];
		[alert.view addSubview:spinner];
		[self presentViewController:alert animated:YES completion:^{
			[ATFRC checkIfEventIsReal:keyField.text comepletion:^(BOOL isReal, NSString *eventName) {
				if (isReal) {
					[self resetTheDangDB];
				} else {
					[self dismissViewControllerAnimated:YES completion:^{
						UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"That event key is not valid!" preferredStyle:UIAlertControllerStyleAlert];
						[alertController addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
							[self resetButton:nil];
						}]];
						[self presentViewController:alertController animated:YES completion:nil];
					}];
				}
			}];
		}];
	}]];
	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}]];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	refreshControl = [[UIRefreshControl alloc] init];
	refreshControl.tintColor = [ATColors raptorGreen];
	[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
	
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
    return [[[ATScouting data] matches] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoutingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
	cell.matchNumber.text = [NSString stringWithFormat:@"Match: %i",];
    return cell;
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
