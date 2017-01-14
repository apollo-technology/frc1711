//
//  ParseDB.m
//  frc1711
//
//  Created by Elijah Cobb on 1/13/17.
//  Copyright © 2017 Apollo Technology. All rights reserved.
//

#import "ParseDB.h"
#import "ATFRC.h"
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@implementation ParseDB

+(instancetype)data{
    static ParseDB *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

+(NSString *)teamId{
    return [[PFUser currentUser] objectForKey:@"team"];
}

+(void)getInfo:(void (^)(NSError *error, BOOL succeeded))block{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"i%@",[ParseDB teamId]]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            if (block) {
                block(error,NO);
            }
        } else {
            [[ParseDB data] setEventKey:object[@"eventKey"]];
            if (block) {
                block(nil,YES);
            }
        }
    }];
}

+(PDBSTeam *)scoutingTeamForObject:(NSDictionary *)object pFObject:(PFObject *)serverObject alliacnce:(int)alliance{
    PDBSTeam *team = [PDBSTeam new];
    
    team.number = [object[@"number"] intValue];
    team.serverObject = serverObject;
    team.eventKey = serverObject[@"eventKey"];
    team.alliance = alliance;
    
    team.lastUpdated = serverObject.updatedAt;
    
    team.finalScoreAuton = [object[@"finalScoreAuton"] intValue];
    team.finalScoreTeleOp = [object[@"finalScoreTeleOp"] intValue];
    team.highGoalCountTeleOp = [object[@"highGoalCountTeleOp"] intValue];
    team.lowGoalCountTeleOp = [object[@"lowGoalCountTeleOp"] intValue];
    team.highGoalCountAuton = [object[@"highGoalCountAuton"] intValue];
    team.lowGoalCountAuton = [object[@"lowGoalCountAuton"] intValue];
    team.didCrossBaseline = [object[@"didCrossBaseline"] boolValue];
    team.didScale = [object[@"didScale"] boolValue];
    
    return team;
}

+(void)getScouting:(void (^)(NSError *error, BOOL succeeded))block{
    [ParseDB getInfo:^(NSError *error, BOOL succeeded) {
        if (error) {
            if (block) {
                block(error, NO);
            }
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"s%@",[ParseDB teamId]]);
            PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"s%@",[ParseDB teamId]]];
            [query whereKey:@"eventKey" equalTo:[[ParseDB data] eventKey]];
            [query addAscendingOrder:@"number"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error) {
                    if (block) {
                        block(error, NO);
                    }
                } else {
                    NSMutableArray *objectsTemp = [NSMutableArray new];
                    for (PFObject *object in objects) {
                        PDBSMatch *match = [PDBSMatch new];
                        match.redTeam1 = [ParseDB scoutingTeamForObject:object[@"redTeam1"] pFObject:object alliacnce:RedAlliance];
                        match.redTeam2 = [ParseDB scoutingTeamForObject:object[@"redTeam2"] pFObject:object alliacnce:RedAlliance];
                        match.redTeam3 = [ParseDB scoutingTeamForObject:object[@"redTeam3"] pFObject:object alliacnce:RedAlliance];
                        
                        match.blueTeam1 = [ParseDB scoutingTeamForObject:object[@"blueTeam1"] pFObject:object alliacnce:BlueAlliance];
                        match.blueTeam2 = [ParseDB scoutingTeamForObject:object[@"blueTeam2"] pFObject:object alliacnce:BlueAlliance];
                        match.blueTeam3 = [ParseDB scoutingTeamForObject:object[@"blueTeam3"] pFObject:object alliacnce:BlueAlliance];
                        
                        match.lastUpdated = object.updatedAt;
                        
                        match.eventKey = object[@"eventKey"];
                        match.number = [object[@"number"] intValue];
                        
                        [objectsTemp addObject:match];
                    }
                    [[ParseDB data] setMatches:objectsTemp];
                    if (block) {
                        block(nil,YES);
                    }
                }
            }];
        }
    }];
}

+(void)getGroundScouting:(void (^)(NSError *error, BOOL succeeded))block{
    [ParseDB getInfo:^(NSError *error, BOOL succeeded) {
        if (error) {
            if (block) {
                block(error, NO);
            }
        } else {
            PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",[ParseDB teamId]]];
            [query whereKey:@"eventKey" equalTo:[[ParseDB data] eventKey]];
            [query addAscendingOrder:@"number"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error) {
                    if (block) {
                        block(error, NO);
                    }
                } else {
                    NSMutableArray *objectsTemp = [NSMutableArray new];
                    for (PFObject *object in objects) {
                        PDBGSTeam *team = [PDBGSTeam new];
                        team.name = object[@"name"];
                        team.serverObject = object;
                        team.number = [object[@"number"] intValue];
                        team.lastUpdated = object.updatedAt;
                        
                        team.canShootHighGoalTeleOp = [object[@"canShootHighGoalTeleOp"] boolValue];
                        team.canShootLowGoalTeleOp = [object[@"canShootLowGoalTeleOp"] boolValue];
                        team.canDeliverGear = [object[@"canDeliverGear"] boolValue];
                        team.ballCarryingCapacity = [object[@"ballCarryingCapacity"] intValue];
                        team.canScale = [object[@"canScale"] boolValue];
                        team.canShootHighGoalAuton = [object[@"canShootHighGoalAuton"] boolValue];
                        team.canShootLowGoalAuton = [object[@"canShoowLowGoalAuton"] boolValue];
                        team.canCrossBaseline = [object[@"canCrossBaseline"] boolValue];
                        
                        [objectsTemp addObject:team];
                    }
                    [[ParseDB data] setTeams:objectsTemp];
                    if (block) {
                        block(nil,YES);
                    }
                }
            }];
        }
    }];
}

+(void)provisionDatabaseForEvent:(NSString *)eventId block:(void (^)(NSError *error, BOOL succeeded))block{
    [ATFRC teamsAtEvent:eventId completion:^(NSArray *teams, BOOL succeeded) {
        if (!succeeded) {
            if (block) {
                block(nil,NO);
            }
        } else {
            NSMutableArray *objectsToSave = [NSMutableArray new];
            for (ATFRCTeam *frcTeam in teams) {
                PFObject *object = [PFObject objectWithClassName:[NSString stringWithFormat:@"gS1711"]];
                object[@"name"] = frcTeam.nickname;
                object[@"number"] = frcTeam.number;
                object[@"eventKey"] = eventId;
                [objectsToSave addObject:object];
            }
            [PFObject saveAllInBackground:objectsToSave block:^(BOOL succeeded, NSError * _Nullable error) {
                if (!succeeded) {
                    if (block) {
                        block(error,NO);
                    }
                } else {
                    [ATFRC matchesAtEvent:eventId completion:^(NSArray *matches, BOOL succeeded) {
                        if (!succeeded) {
                            if (block) {
                                block(nil,NO);
                            }
                        } else {
                            NSMutableArray *objectsToSave = [NSMutableArray new];
                            for (ATFRCMatch *frcMatch in matches) {
                                PFObject *object = [PFObject objectWithClassName:[NSString stringWithFormat:@"s1711"]];
                                object[@"number"] = @([matches indexOfObject:frcMatch]+1    ) ;
                                object[@"eventKey"] = eventId;
                                object[@"key"] = frcMatch.eventKey;
                                object[@"blueTeam1"] = @{@"number" : [frcMatch.blueTeams[0] stringByReplacingOccurrencesOfString:@"frc" withString:@""]};
                                object[@"blueTeam2"] = @{@"number" : [frcMatch.blueTeams[1] stringByReplacingOccurrencesOfString:@"frc" withString:@""]};
                                object[@"blueTeam3"] = @{@"number" : [frcMatch.blueTeams[2] stringByReplacingOccurrencesOfString:@"frc" withString:@""]};
                                object[@"redTeam1"] = @{@"number" : [frcMatch.redTeams[0] stringByReplacingOccurrencesOfString:@"frc" withString:@""]};
                                object[@"redTeam2"] = @{@"number" : [frcMatch.redTeams[1] stringByReplacingOccurrencesOfString:@"frc" withString:@""]};
                                object[@"redTeam3"] = @{@"number" : [frcMatch.redTeams[2] stringByReplacingOccurrencesOfString:@"frc" withString:@""]};
                                [objectsToSave addObject:object];
                            }
                            [PFObject saveAllInBackground:objectsToSave block:^(BOOL succeeded, NSError * _Nullable error) {
                                if (!succeeded) {
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
            }];
        }
    }];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@implementation PDBSTeam

-(void)update:(void (^)(NSError *error, BOOL succeeded))block{
    [self.serverObject fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            if (block) {
                block(error,NO);
            }
        } else {
            /*
             [data setObject:@(self.scoreTeleOp) forKey:scoreTeleOpKey];
             [data setObject:@(self.highGoalTeleOpCount) forKey:highGoalTeleOpCountKey];
             [data setObject:@(self.lowGoalTeleopCount) forKey:lowGoalTeleopCountKey];
             [data setObject:@(self.highGoalAutonCount) forKey:highGoalAutonCountKey];
             [data setObject:@(self.lowGoalAutonCount) forKey:lowGoalAutonCountKey];
             [data setObject:@(self.didCrossBaseline) forKey:didCrossBaselineKey];
             [data setObject:@(self.didScale) forKey:didScaleKey];
             [data setObject:@(self.autonScore) forKey:autonScoreKey];
             */
        }
    }];
}

@end
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@implementation PDBGSTeam

-(void)update:(void (^)(NSError *error, BOOL succeeded))block{
    NSLog(@"%@",self.serverObject.objectId);
    [self.serverObject fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            if (block) {
                block(error,NO);
            }
        } else {
            object[@"canShootLowGoalTeleOp"] = @(self.canShootLowGoalTeleOp);
            object[@"canShootHighGoalTeleOp"] = @(self.canShootHighGoalTeleOp);
            object[@"canDeliverGear"] = @(self.canDeliverGear);
            object[@"ballCarryingCapacity"] = @(self.ballCarryingCapacity);
            object[@"canScale"] = @(self.canScale);
            object[@"canShootHighGoalAuton"] = @(self.canShootHighGoalAuton);
            object[@"canShoowLowGoalAuton"] = @(self.canShootLowGoalAuton);
            object[@"canCrossBaseline"] = @(self.canCrossBaseline);
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
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
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@implementation PDBSMatch

@end
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
