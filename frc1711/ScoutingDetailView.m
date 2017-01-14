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
    
    IBOutlet UIStepper *autonLowGoalStepper;
    IBOutlet UILabel *autonLowGoalLabel;
    IBOutlet UIStepper *autonHighGoalStepper;
    IBOutlet UILabel *autonHighGoalLabel;
    
    IBOutlet UIStepper *teleopLowGoalStepper;
    IBOutlet UILabel *teleopLowGoalLabel;
    IBOutlet UIStepper *teleopHighGoalStepper;
    IBOutlet UILabel *teleopHighGoalLabel;
    
    IBOutlet UITextField *autonFinalScoreField;
    IBOutlet UITextField *teleopFinalScore;
    
    IBOutlet UISwitch *crossBaseLineSwitch;
    IBOutlet UISwitch *scaleRopeSwitch;
    
    IBOutlet UILabel *dateLabel;
}

@end

@implementation ScoutingDetailView

@synthesize match, team;

-(IBAction)updateSteppers:(id)sender{
    autonLowGoalLabel.text = [NSString stringWithFormat:@"%i Low Goals",(int)autonLowGoalStepper.value];
    autonHighGoalLabel.text = [NSString stringWithFormat:@"%i High Goals",(int)autonHighGoalStepper.value];
    teleopLowGoalLabel.text = [NSString stringWithFormat:@"%i Low Goals",(int)teleopLowGoalStepper.value];
    teleopHighGoalLabel.text = [NSString stringWithFormat:@"%i High Goals",(int)teleopHighGoalStepper.value];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	teamLabel.text = [NSString stringWithFormat:@"Team: %i",team.number];
	matchLabel.text = [NSString stringWithFormat:@"Match: %i",match.number];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, M/d, h:mm a"];
    dateLabel.text = [NSString stringWithFormat:@"Last Updated: %@",[dateFormatter stringFromDate:match.lastUpdated]];
	
	if (team.alliance == BlueAlliance) {
		allianceLabel.text = @"Alliance: Blue";
	} else if (team.alliance != RedAlliance) {
		allianceLabel.text = @"Alliance: Red";
	}
    
    autonLowGoalStepper.value = team.lowGoalCountAuton;
    autonHighGoalStepper.value = team.highGoalCountAuton;
    
    teleopLowGoalStepper.value = team.lowGoalCountTeleOp;
    teleopHighGoalStepper.value = team.highGoalCountTeleOp;
    
    [crossBaseLineSwitch setOn:team.didCrossBaseline];
    [scaleRopeSwitch setOn:team.didScale];
    
    [self updateSteppers:nil];
    
    autonFinalScoreField.text = [NSString stringWithFormat:@"%i",team.finalScoreAuton];
    teleopFinalScore.text = [NSString stringWithFormat:@"%i",team.finalScoreTeleOp];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.tableView addGestureRecognizer:tap];
    
    [[UIStepper appearanceWhenContainedInInstancesOfClasses:@[[self class]]] setTintColor:[ATColors raptorGreen]];
    [[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]] setOnTintColor:[ATColors raptorGreen]];

	uploadButton.image = [IonIcons imageWithIcon:ioniosclouduploadoutline color:[ATColors raptorGreen]];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Team: %i",team.number];
}

-(IBAction)hideKeyboard:(id)sender{
	[self.view endEditing:YES];
}

-(IBAction)uploadButton:(id)sender{
	
    team.lowGoalCountAuton = (int)autonLowGoalStepper.value;
    team.highGoalCountAuton = (int)autonHighGoalStepper.value;
    team.lowGoalCountTeleOp = (int)teleopLowGoalStepper.value;
    team.highGoalCountTeleOp = (int)teleopHighGoalStepper.value;
    
    team.finalScoreAuton = [autonFinalScoreField.text intValue];
    team.finalScoreTeleOp = [teleopFinalScore.text intValue];
    
    team.didCrossBaseline = crossBaseLineSwitch.isOn;
    team.didScale = scaleRopeSwitch.isOn;
	
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
