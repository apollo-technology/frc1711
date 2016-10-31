//
//  RankingsTableViewController.h
//  Raptors1711
//
//  Created by Elijah Cobb on 4/4/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATFRC.h"

@interface RankingsTableViewController : UITableViewController{
    NSMutableArray *rankings;
    ATFRCEvent *event;
}

@property NSMutableArray *rankings;
@property ATFRCEvent *event;

@end
