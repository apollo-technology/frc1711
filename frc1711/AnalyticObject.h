//
//  AnalyticObject.h
//  frc1711
//
//  Created by Elijah Cobb on 2/1/17.
//  Copyright © 2017 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticObject : NSObject

@property int team;
@property int finalScore;

@property int autonFinalScore;
@property int teleopFinalScore;
@property int highGoalCountTeleop;
@property int lowGoalCountTeleOp;
@property int highGoalCountAuton;
@property int lowGoalCountAuton;
@property BOOL didScale;
@property int didScaleNumber;

-(id)initWithTeam:(NSDictionary *)team withFinalScore:(int)finalScore;

@end
