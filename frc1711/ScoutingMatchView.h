//
//  ScoutingMatchView.h
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMatch.h"
#import "ATScoutingTeam.h"
#import "ATScouting.h"

@interface ScoutingMatchView : UITableViewController{
	ATMatch *match;
}

@property ATMatch *match;

@end
