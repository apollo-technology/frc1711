//
//  ATScouting.h
//  frc1711
//
//  Created by Elijah Cobb on 11/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Parse/Parse.h>
#import "ATFRC.h"
#import "ATScoutingTeam.h"
#import "ATMatch.h"

#define scoreTeleOpKey @"scoreTeleOp"
#define highGoalTeleOpCountKey @"highGoalTeleOpCount"
#define lowGoalTeleopCountKey @"lowGoalTeleopCount"
#define highGoalAutonCountKey @"highGoalAutonCount"
#define lowGoalAutonCountKey @"lowGoalAutonCount"
#define didCrossBaselineKey @"didCrossBaseline"
#define didScaleKey @"didScale"
#define autonScoreKey @"autonScore"

#define oblock (void (^)(NSError *error, BOOL succeeded))block

@interface ATScouting : NSObject

//variables
@property NSMutableArray *matches;

//methods
+(instancetype)data;
+(void)setDatabaseForEvent:(NSString *)eventCode block:oblock;
+(void)getData:oblock;
+(void)setResultsForTeam:(NSString *)team forAlliance:(ATAlliance)alliance forMatch:(NSString *)match block:oblock;

@end
