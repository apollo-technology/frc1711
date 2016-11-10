//
//  ScoutingDetailView.h
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATScouting.h"

@interface ScoutingDetailView : UITableViewController{
	ATMatch *match;
	ATScoutingTeam *team;
}

@property ATMatch *match;
@property ATScoutingTeam *team;

@end
