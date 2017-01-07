//
//  ATScoutingTeam.h
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATScoutingTeam : NSObject

//variables
@property int scoreTeleOp;
@property int highGoalTeleOpCount;
@property int lowGoalTeleopCount;
@property int highGoalAutonCount;
@property int lowGoalAutonCount;
@property BOOL didCrossBaseline;
@property BOOL didScale;
@property int autonScore;


//recourse
@property int number;
@property int alliance;
@property NSString *key;
@property NSString *keyIndex;
typedef NS_ENUM(NSInteger, ATAlliance) {BlueAlliance,RedAlliance,};

//method
-(void)update:(void (^)(NSError *error, BOOL succeeded))block;

@end
