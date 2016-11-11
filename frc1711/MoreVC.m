//
//  MoreVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/2/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//
#import "MoreVC.h"

@interface MoreVC (){
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *teamLabel;
	IBOutlet UILabel *phoneLabel;
	IBOutlet UITableViewCell *signOutCell;
	IBOutlet UITableViewCell *emailCell;
	IBOutlet UITableViewCell *websiteCell;
	IBOutlet UITableViewCell *bugCell;
	IBOutlet UITableViewCell *usersCell;
	MFMailComposeViewController *composerVC;
}

@end

@implementation MoreVC

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

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
	} else if (selectedCell == emailCell) {
		composerVC = [[MFMailComposeViewController alloc] init];
		[composerVC setToRecipients:@[[[AppConfigs configs] raptorEmail]]];
		[composerVC setMessageBody:@"" isHTML:NO];
		[composerVC setSubject:@""];
		[composerVC setMailComposeDelegate:self];
		[self presentViewController:composerVC animated:YES completion:^{
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}];
	} else if (selectedCell == bugCell) {
		composerVC = [[MFMailComposeViewController alloc] init];
		[composerVC setToRecipients:@[[[AppConfigs configs] apolloEmail]]];
		[composerVC setMessageBody:@"" isHTML:NO];
		[composerVC setSubject:@""];
		[composerVC setMailComposeDelegate:self];
		[self presentViewController:composerVC animated:YES completion:^{
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}];
	} else if (selectedCell == websiteCell) {
		SFSafariViewController *browserVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[[AppConfigs configs] raptorWebsite]]];
		[self presentViewController:browserVC animated:YES completion:^{
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}];
	} else if (selectedCell == usersCell) {
		UIViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"teamInitiation"];
		[self.navigationController pushViewController:newView animated:YES];
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
