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

-(IBAction)uploadButton:(id)sender{
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

@end
