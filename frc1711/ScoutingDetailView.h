//
//  ScoutingDetailView.h
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseDB.h"

@interface ScoutingDetailView : UITableViewController{
	PDBSMatch *match;
	PDBSTeam *team;
}

@property PDBSMatch *match;
@property PDBSTeam *team;

@end
