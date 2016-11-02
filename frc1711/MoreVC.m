//
//  MoreVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/2/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//
#import <Parse/Parse.h>
#import "MoreVC.h"

@interface MoreVC (){
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *teamLabel;
	IBOutlet UILabel *phoneLabel;
	IBOutlet UITableViewCell *signOutCell;
}

@end

@implementation MoreVC

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	if (selectedCell == signOutCell) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Signing Out\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.center = CGPointMake(130.5, 80);
		spinner.color = [UIColor grayColor];
		[spinner startAnimating];
		[alert.view addSubview:spinner];
		[self presentViewController:alert animated:YES completion:^{
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			[PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
				[self dismissViewControllerAnimated:YES completion:^{
					UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:@"signIn"];
					[self presentViewController:initial animated:YES completion:nil];
				}];
			}];
		}];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	PFUser *user = [PFUser currentUser];
	nameLabel.text = [NSString stringWithFormat:@"%@ %@",user[@"firstName"],user[@"lastName"]];
	teamLabel.text = user[@"team"];
	NSString *phone = user.username;
	phoneLabel.text = [NSString stringWithFormat:@"(%@) %@-%@",[phone substringWithRange:NSMakeRange(0, 3)],[phone substringWithRange:NSMakeRange(3, 3)],[phone substringWithRange:NSMakeRange(6, 4)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
