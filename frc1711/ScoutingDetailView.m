//
//  ScoutingDetailView.m
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ScoutingDetailView.h"
#import "IonIcons.h"
#import "ATColors.h"

@interface ScoutingDetailView (){
	IBOutlet UILabel *teamLabel;
	IBOutlet UILabel *matchLabel;
	IBOutlet UILabel *allianceLabel;
	IBOutlet UIBarButtonItem *uploadButton;
	
	IBOutlet UITextField *textField;
}

@end

@implementation ScoutingDetailView

@synthesize match, team;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	teamLabel.text = [NSString stringWithFormat:@"Team: %i",team.number];
	matchLabel.text = [NSString stringWithFormat:@"Match: %i",match.number];
	
	if (team.alliance == BlueAlliance) {
		allianceLabel.text = @"Alliance: Blue";
	} else if (team.alliance != RedAlliance) {
		allianceLabel.text = @"Alliance: Red";
	}
	

	uploadButton.image = [IonIcons imageWithIcon:ioniosclouduploadoutline color:[ATColors raptorGreen]];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Team: %i",team.number];
}

-(IBAction)hideKeyboard:(id)sender{
	[self.view endEditing:YES];
}

-(IBAction)uploadButton:(id)sender{
	
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Updating\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = CGPointMake(130.5, 80);
	spinner.color = [UIColor grayColor];
	[spinner startAnimating];
	[alert.view addSubview:spinner];
	[self presentViewController:alert animated:YES completion:^{
		[team update:^(NSError *error, BOOL succeeded) {
			if (succeeded) {
				[self dismissViewControllerAnimated:YES completion:^{
					[self.navigationController popViewControllerAnimated:YES];
				}];
			} else {
				NSString *errorMessage;
				if (error) {
					errorMessage = error.localizedDescription;
				}
				[self dismissViewControllerAnimated:YES completion:^{
					UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error Updating" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
					[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
					[self presentViewController:alertController animated:YES completion:nil];
				}];
			}
		}];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

@end
