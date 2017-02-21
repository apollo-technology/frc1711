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

+(PDBSTeam *)scoutingTeamForObject:(NSDictionary *)object pFObject:(PFObject *)serverObject alliacnce:(int)alliance dataId:(NSString *)dataId{
    PDBSTeam *team = [PDBSTeam new];
    
    team.number = [object[@"number"] intValue];
    team.serverObject = serverObject;
    team.eventKey = serverObject[@"eventKey"];
    team.alliance = alliance;
    team.dataId = dataId;
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

+(void)getScoutingAndGroundScoutingData:(void (^)(NSError *error, BOOL succeeded))block{
    [ParseDB getScouting:^(NSError *error, BOOL succeeded) {
        if (error) {
            if (block) {
                block(error,NO);
            }
        } else {
            [ParseDB getGroundScouting:^(NSError *error, BOOL succeeded) {
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

+(void)getScouting:(void (^)(NSError *error, BOOL succeeded))block{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"s%@",[ParseDB teamId]]];
    [query addAscendingOrder:@"number"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            if (block) {
                block(error, NO);
            }
        } else {
            NSMutableArray *objectsTemp = [NSMutableArray new];
            NSMutableArray *keys = [NSMutableArray new];
            for (PFObject *object in objects) {
                PDBSMatch *match = [PDBSMatch new];
                match.redTeam1 = [ParseDB scoutingTeamForObject:object[@"redTeam1"] pFObject:object alliacnce:RedAlliance dataId:@"redTeam1"];
                match.redTeam2 = [ParseDB scoutingTeamForObject:object[@"redTeam2"] pFObject:object alliacnce:RedAlliance dataId:@"redTeam2"];
                match.redTeam3 = [ParseDB scoutingTeamForObject:object[@"redTeam3"] pFObject:object alliacnce:RedAlliance dataId:@"redTeam3"];
                
                match.blueTeam1 = [ParseDB scoutingTeamForObject:object[@"blueTeam1"] pFObject:object alliacnce:BlueAlliance dataId:@"blueTeam1"];
                match.blueTeam2 = [ParseDB scoutingTeamForObject:object[@"blueTeam2"] pFObject:object alliacnce:BlueAlliance dataId:@"blueTeam2"];
                match.blueTeam3 = [ParseDB scoutingTeamForObject:object[@"blueTeam3"] pFObject:object alliacnce:BlueAlliance dataId:@"blueTeam3"];
                
                match.lastUpdated = object.updatedAt;
                
                match.eventKey = object[@"eventKey"];
                match.number = [object[@"number"] intValue];
                
                [objectsTemp addObject:match];
                
                if (![keys containsObject:object[@"eventKey"]]) {
                    [keys addObject:object[@"eventKey"]];
                }
            }
            [[ParseDB data] setMatches:objectsTemp];
            [[ParseDB data] setAvailableEventKeys:keys];
            if (block) {
                block(nil,YES);
            }
        }
    }];
}

+(void)getGroundScouting:(void (^)(NSError *error, BOOL succeeded))block{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",[ParseDB teamId]]];
    [query addAscendingOrder:@"number"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            if (block) {
                block(error, NO);
            }
        } else {
            NSMutableArray *objectsTemp = [NSMutableArray new];
            NSMutableArray *keys = [NSMutableArray new];
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
                team.eventKey = object[@"eventKey"];
                
                if (![keys containsObject:object[@"eventKey"]]) {
                    [keys addObject:object[@"eventKey"]];
                }
                
                [objectsTemp addObject:team];
            }
            [[ParseDB data] setAvailableEventKeys:keys];
            [[ParseDB data] setTeams:objectsTemp];
            if (block) {
                block(nil,YES);
            }
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
                PFObject *object = [PFObject objectWithClassName:[NSString stringWithFormat:@"gS%@",[self teamId]]];
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
                    [ATFRC qualifyingMatchesAtEvent:eventId completion:^(NSArray *matches, BOOL succeeded) {
                        if (!succeeded) {
                            if (block) {
                                block(nil,NO);
                            }
                        } else {
                            NSMutableArray *objectsToSave = [NSMutableArray new];
                            for (ATFRCMatch *frcMatch in matches) {
                                PFObject *object = [PFObject objectWithClassName:[NSString stringWithFormat:@"s%@",[self teamId]]];
                                object[@"number"] = @([matches indexOfObject:frcMatch]+1);
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
                            [[NSUserDefaults standardUserDefaults] setObject:objectsToSave[0][@"eventKey"] forKey:@"dbPreference"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
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
            
            NSDictionary *dictionary = @{@"number" : @(self.number),
                                         @"highGoalCountTeleOp" : @(self.highGoalCountTeleOp),
                                         @"lowGoalCountTeleOp" : @(self.lowGoalCountTeleOp),
                                         @"highGoalCountAuton" : @(self.highGoalCountAuton),
                                         @"lowGoalCountAuton" : @(self.lowGoalCountAuton),
                                         @"didCrossBaseline" : @(self.didCrossBaseline),
                                         @"didScale" : @(self.didScale),
                                         @"finalScoreAuton" : @(self.finalScoreAuton),
                                         @"finalScoreTeleOp" : @(self.finalScoreTeleOp),};
            object[self.dataId] = dictionary;
            
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
@implementation PDBGSTeam

-(void)update:(void (^)(NSError *error, BOOL succeeded))block{
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
