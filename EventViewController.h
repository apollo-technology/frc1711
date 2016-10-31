//
//  EventViewController.h
//  Raptors1711
//
//  Created by Elijah Cobb on 4/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATFRC.h"

@interface EventViewController : UITableViewController{
    ATFRCEvent *event;
}

@property ATFRCEvent *event;

@end
