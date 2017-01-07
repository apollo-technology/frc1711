//
//  ATGSTeam.m
//  frc1711
//
//  Created by Elijah Cobb on 10/31/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ATGSTeam.h"
#import "ATGScouting.h"

@implementation ATGSTeam

-(void)pushUpdates:(void (^)(NSError *error, BOOL succeeded))block{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",[ATGScouting teamId]]];
	[query whereKey:@"number" equalTo:@(self.number)];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            if (block) {
                block(error,NO);
            }
        } else {
            object[@"name"] = self.name;
			object[@"number"] = @(self.number);
            
            object[@"canShootHighGoal"] = @(self.canShootHighGoal);
            object[@"canShootLowGoal"] = @(self.canShootLowGoal);
            object[@"canDeliverGear"] = @(self.canDeliverGear);
            object[@"ballCarryingCapacity"] = @(self.ballCarryingCapacity);
            object[@"canScale"] = @(self.canScale);
            object[@"autonCanHighGoal"] = @(self.autonCanHighGoal);
            object[@"autonCanlowGoal"] = @(self.autonCanLowGoal);
            object[@"autonCanCrossBase"] = @(self.autonCanCrossBase);
            
            /*
             set all of these properties like this
             */
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@",error);
                    if (block) {
                        block(error,NO);
                    }
                } else {
                    int index = (int)[[[ATGScouting data] teams] indexOfObject:self];
                    [[[ATGScouting data] teams] replaceObjectAtIndex:index withObject:self];
                    if (block) {
                        block(nil,YES);
                    }
                }
            }];
        }
    }];
}

-(void)destroy:(void (^)(NSError *error, BOOL succeeded))block{
	
	[[[ATGScouting data] teams] removeObject:self];
	
	PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",[ATGScouting teamId]]];
	[query whereKey:@"number" equalTo:[NSString stringWithFormat:@"%i",self.number]];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
		if (error) {
			NSLog(@"%@",error);
			if (block) {
				block(error,NO);
			}
		} else {
			[object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
				if (error) {
					NSLog(@"%@",error);
					if (block) {
						block(error,NO);
					}
				} else {
					if (block) {
						block(nil,YES);
					}
				}
			}];
		}
	}];
}

@end
