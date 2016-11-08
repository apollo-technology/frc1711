//
//  GSScoutingDetailVC.h
//  frc1711
//
//  Created by Elijah Cobb on 11/8/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ATGScouting.h"
#import "ATFRC.h"
#import "ATColors.h"
#import "IonIcons.h"

@interface GSScoutingDetailVC : UITableViewController{
	ATGSTeam *team;
}

@property ATGSTeam *team;

@end
