//
//  AnalyticObject.m
//  frc1711
//
//  Created by Elijah Cobb on 2/1/17.
//  Copyright © 2017 Apollo Technology. All rights reserved.
//

#import "AnalyticObject.h"

@implementation AnalyticObject

-(id)initWithTeam:(NSDictionary *)team withFinalScore:(int)finalScore{
    self = [AnalyticObject new];
    self.team = [team[@"number"] intValue];
    self.autonFinalScore = [team[@"autonFinalScore"] intValue];
    self.teleopFinalScore = [team[@"teleopFinalScore"] intValue];
    self.highGoalCountTeleop = [team[@"highGoalCountTeleop"] intValue];
    self.lowGoalCountTeleOp = [team[@"lowGoalCountTeleOp"] intValue];
    self.highGoalCountAuton = [team[@"highGoalCountAuton"] intValue];
    self.lowGoalCountAuton = [team[@"lowGoalCountAuton"] intValue];
    self.didScale = [team[@"didScale"] boolValue];
    self.didScaleNumber = [team[@"didScaleNumber"] boolValue];
    self.finalScore = finalScore;
    return self;
}

@end
