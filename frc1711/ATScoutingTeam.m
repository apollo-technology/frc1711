//
//  ATScoutingTeam.m
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ATScoutingTeam.h"
#import "ATScouting.h"
#import <Parse/Parse.h>

#define ifNotError if (error) {if (block) {NSLog(@"%@",error);block(error,NO);}} else


@implementation ATScoutingTeam

-(void)update:(void (^)(NSError *error, BOOL succeeded))block{
	PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"s%@",[[PFUser currentUser] objectForKey:@"team"]]];
	[query whereKey:@"key" equalTo:self.key];
	[query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
		ifNotError {
			NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:object[self.keyIndex]];
			
			/*
			 key
			 */
            [data setObject:@(self.scoreTeleOp) forKey:scoreTeleOpKey];
            [data setObject:@(self.highGoalTeleOpCount) forKey:highGoalTeleOpCountKey];
            [data setObject:@(self.lowGoalTeleopCount) forKey:lowGoalTeleopCountKey];
            [data setObject:@(self.highGoalAutonCount) forKey:highGoalAutonCountKey];
            [data setObject:@(self.lowGoalAutonCount) forKey:lowGoalAutonCountKey];
            [data setObject:@(self.didCrossBaseline) forKey:didCrossBaselineKey];
            [data setObject:@(self.didScale) forKey:didScaleKey];
            [data setObject:@(self.autonScore) forKey:autonScoreKey];

			
			object[self.keyIndex] = data;
			
			[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
				ifNotError {
					[ATScouting getData:^(NSError *error, BOOL succeeded) {
						ifNotError {
							if (block) {
								block(nil,YES);
							}
						}
					}];
				}
			}];
		}
	}];
}

@end
