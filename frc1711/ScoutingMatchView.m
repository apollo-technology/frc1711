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
    
    IBOutlet UILabel *dateLabel;
}

@property (nonatomic, strong) id previewingContext;

@end

@implementation ScoutingMatchView

@synthesize match;

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id)previewingContext viewControllerForLocation:(CGPoint)location{
    if ([self.presentedViewController isKindOfClass:[ScoutingMatchView class]]) {
        return nil;
    }
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:cellPostion]];
    ScoutingDetailView *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingDetailView"];
    newView.match = match;
    if (selectedCell == red1Cell) {
        newView.team = match.redTeam1;
    } else if (selectedCell == red2Cell) {
        newView.team = match.redTeam2;
    } else if (selectedCell == red3Cell) {
        newView.team = match.redTeam3;
    } else if (selectedCell == blue1Cell) {
        newView.team = match.blueTeam1;
    } else if (selectedCell == blue2Cell) {
        newView.team = match.blueTeam2;
    } else if (selectedCell == blue3Cell) {
        newView.team = match.blueTeam3;
    }
    return newView;
}




- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self isForceTouchAvailable]) {
        if (!self.previewingContext) {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    } else {
        if (self.previewingContext) {
            [self unregisterForPreviewingWithContext:self.previewingContext];
            self.previewingContext = nil;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	red1Label.text = [NSString stringWithFormat:@"%i",match.redTeam1.number];
	red2Label.text = [NSString stringWithFormat:@"%i",match.redTeam2.number];
	red3Label.text = [NSString stringWithFormat:@"%i",match.redTeam3.number];
	
	blue1Label.text = [NSString stringWithFormat:@"%i",match.blueTeam1.number];
	blue2Label.text = [NSString stringWithFormat:@"%i",match.blueTeam2.number];
	blue3Label.text = [NSString stringWithFormat:@"%i",match.blueTeam3.number];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Match: %i",match.number];
    
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, M/d, h:mm a"];
    dateLabel.text = [NSString stringWithFormat:@"Last Updated: %@",[dateFormatter stringFromDate:match.lastUpdated]];
	
	//keyLabel.text = match.event;
	
}

-(void)segueToTeam:(PDBSTeam *)team{
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

@end
