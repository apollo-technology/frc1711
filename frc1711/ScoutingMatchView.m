//
//  ScoutingMatchView.m
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ScoutingMatchView.h"
#import "ScoutingDetailView.h"

@interface ScoutingMatchView (){
	IBOutlet UILabel *red1Label;
	IBOutlet UILabel *red2Label;
	IBOutlet UILabel *red3Label;
	IBOutlet UILabel *blue1Label;
	IBOutlet UILabel *blue2Label;
	IBOutlet UILabel *blue3Label;
	
	IBOutlet UILabel *keyLabel;
	
	IBOutlet UITableViewCell *red1Cell;
	IBOutlet UITableViewCell *red2Cell;
	IBOutlet UITableViewCell *red3Cell;
	IBOutlet UITableViewCell *blue1Cell;
	IBOutlet UITableViewCell *blue2Cell;
	IBOutlet UITableViewCell *blue3Cell;
}

@end

@implementation ScoutingMatchView

@synthesize match;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	red1Label.text = [NSString stringWithFormat:@"%i",match.redTeam1.number];
	red2Label.text = [NSString stringWithFormat:@"%i",match.redTeam2.number];
	red3Label.text = [NSString stringWithFormat:@"%i",match.redTeam3.number];
	
	blue1Label.text = [NSString stringWithFormat:@"%i",match.blueTeam1.number];
	blue2Label.text = [NSString stringWithFormat:@"%i",match.blueTeam2.number];
	blue3Label.text = [NSString stringWithFormat:@"%i",match.blueTeam3.number];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Match: %i",match.number];
	
	keyLabel.text = match.key;
	
}

-(void)segueToTeam:(ATScoutingTeam *)team{
	ScoutingDetailView *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingDetailView"];
	newView.team = team;
	newView.match = match;
	[self.navigationController pushViewController:newView animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	if (selectedCell == red1Cell) {
		[self segueToTeam:match.redTeam1];
	} else if (selectedCell == red2Cell) {
		[self segueToTeam:match.redTeam2];
	} else if (selectedCell == red3Cell) {
		[self segueToTeam:match.redTeam3];
	} else if (selectedCell == blue1Cell) {
		[self segueToTeam:match.blueTeam1];
	} else if (selectedCell == blue2Cell) {
		[self segueToTeam:match.blueTeam2];
	} else if (selectedCell == blue3Cell) {
		[self segueToTeam:match.blueTeam3];
	}
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
