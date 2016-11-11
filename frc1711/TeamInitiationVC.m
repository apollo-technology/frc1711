//
//  TeamInitiationVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/11/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "TeamInitiationVC.h"
#import <Parse/Parse.h>

@interface TeamInitiationVC (){
	NSArray *arrayToShow;
}

@end

@implementation TeamInitiationVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
	PFQuery *query = [PFQuery queryWithClassName:@"userInitiation"];
	[query whereKey:@"number" equalTo:[NSString stringWithFormat:@"%@",[[PFUser currentUser] objectForKey:@"team"]]];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		if (error) {
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				
			}]];
			[self presentViewController:alertController animated:YES completion:nil];
		} else {
			arrayToShow = objects;
			[self.tableView reloadData];
		}
	}];
	
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
    return arrayToShow.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
	PFUser *user = arrayToShow[indexPath.row][@"user"];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",user[@"firstName"],user[@"lastName"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UIAlertControllerStyle style;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		style = UIAlertControllerStyleAlert;
	} else {
		style = UIAlertControllerStyleActionSheet;
	}
	
	PFUser *user = arrayToShow[indexPath.row][@"user"];
	
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Would you like to accept this user?" message:nil preferredStyle:style];
	[alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.center = CGPointMake(130.5, 80);
		spinner.color = [UIColor grayColor];
		[spinner startAnimating];
		[alert.view addSubview:spinner];
		[self presentViewController:alert animated:YES completion:^{
			user[@"team"] = [[PFUser currentUser] objectForKey:@"team"];
			[user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
				[self dismissViewControllerAnimated:YES completion:^{
					if (error) {
						UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
						[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
							
						}]];
						[self presentViewController:alertController animated:YES completion:nil];
					} else {
						[self.navigationController popToRootViewControllerAnimated:YES];
					}
				}];
			}];
		}];
	}]];
	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}]];
	[self presentViewController:alertController animated:YES completion:^{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}];
}

@end
