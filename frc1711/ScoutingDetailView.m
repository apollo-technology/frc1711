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
	
	if (team.alliance == BlueAlliance) {
		allianceLabel.text = @"Alliance: Blue";
	} else if (team.alliance != RedAlliance) {
		allianceLabel.text = @"Alliance: Red";
	}
<<<<<<< HEAD
    
    autonLowGoalStepper.value = team.lowGoalAutonCount;
    autonHighGoalStepper.value = team.highGoalAutonCount;
    
    teleopLowGoalStepper.value = team.lowGoalTeleopCount;
    teleopHighGoalStepper.value = team.highGoalTeleOpCount;
    
    [crossBaseLineSwitch setOn:team.didCrossBaseline];
    [scaleRopeSwitch setOn:team.didScale];
    
    [self updateSteppers:nil];
    
    autonFinalScoreField.text = [NSString stringWithFormat:@"%i",team.autonScore];
    teleopFinalScore.text = [NSString stringWithFormat:@"%i",team.scoreTeleOp];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.tableView addGestureRecognizer:tap];
    
    [[UIStepper appearanceWhenContainedInInstancesOfClasses:@[[self class]]] setTintColor:[ATColors raptorGreen]];
    [[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]] setOnTintColor:[ATColors raptorGreen]];
	
=======
	

>>>>>>> origin/master
	uploadButton.image = [IonIcons imageWithIcon:ioniosclouduploadoutline color:[ATColors raptorGreen]];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Team: %i",team.number];
}

-(IBAction)hideKeyboard:(id)sender{
	[self.view endEditing:YES];
}

-(IBAction)uploadButton:(id)sender{
	
<<<<<<< HEAD
    team.lowGoalAutonCount = (int)autonLowGoalStepper.value;
    team.highGoalAutonCount = (int)autonHighGoalStepper.value;
    team.lowGoalTeleopCount = (int)teleopLowGoalStepper.value;
    team.highGoalTeleOpCount = (int)teleopHighGoalStepper.value;
    
    team.autonScore = [autonFinalScoreField.text intValue];
    team.scoreTeleOp = [teleopFinalScore.text intValue];
    
    team.didCrossBaseline = crossBaseLineSwitch.isOn;
    team.didScale = scaleRopeSwitch.isOn;
    
=======
>>>>>>> origin/master
	
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
