//
//  ScoutingMatchView.h
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseDB.h"

@interface ScoutingMatchView : UITableViewController{
	PDBSMatch *match;
}

@property PDBSMatch *match;

@end
