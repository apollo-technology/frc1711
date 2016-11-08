//
//  ATGScouting.m
//  frc1711
//
//  Created by Elijah Cobb on 10/31/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ATGScouting.h"

@implementation ATGScouting

+ (instancetype)data {
    static ATGScouting *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

+(NSString *)teamId{
	return [[PFUser currentUser] objectForKey:@"team"];
}

+(void)getTeams:(void (^)(NSError *error, BOOL succeeded))block{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",[self teamId]]];
    [query setLimit:1000];
	[query addAscendingOrder:@"number"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            if (block) {
                block(error,NO);
            }
        } else {
            NSMutableArray *teams = [NSMutableArray new];
            for (PFObject *object in objects) {
                ATGSTeam *team = [ATGSTeam new];
                team.name = object[@"name"];
				team.number = [object[@"number"] intValue];
                /*
                 add all information from PFObjects stored in the server. Make sure to add them as @properties in "ATGSTeam.h" file.
                 */
                
                [teams addObject:team];
            }
            [ATGScouting data].teams = [[NSMutableArray alloc] initWithArray:teams];
            if (block) {
                block(nil,YES);
            }
        }
    }];
}

+(void)resetDataBaseForEvent:(NSString *)eventId block:(void (^)(NSError *error, BOOL succeeded))block{
    [ATFRC teamsAtEvent:eventId completion:^(NSArray *teams, BOOL succeeded) {
        if (!succeeded) {
            if (block) {
                block(nil,NO);
            }
        } else {
            PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",[self teamId]]];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error) {
                    if (block) {
                        NSLog(@"%@",error);
                        block(error,NO);
                        
                    }
                } else {
                    [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
                        if (!succeeded) {
                            NSLog(@"%@",error);
                            if (block) {
                                block(error,NO);
                            }
                        } else {
                            ATFRCTeam *lastTeam = [teams lastObject];
                            NSString *lastKey = lastTeam.key;
                            
                            for (ATFRCTeam *team in teams) {
                                PFObject *object = [PFObject objectWithClassName:[NSString stringWithFormat:@"gS%@",[self teamId]]];
                                object[@"name"] = team.nickname;
								object[@"number"] = team.number;
                                
                                
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                    if ([team.key isEqualToString:lastKey]) {
                                        if (!succeeded) {
                                            NSLog(@"%@",error);
                                            if (block) {
                                                block(error,NO);
                                            }
                                        } else {
                                            [self getTeams:^(NSError *error, BOOL succeeded) {
                                                if (block) {
                                                    block(error,YES);
                                                }
                                            }];
                                        }
                                    }
                                }];
                            }
                        }
                    }];
                }
            }];
        }
    }];
}

@end
