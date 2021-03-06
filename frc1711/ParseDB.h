//
//  ParseDB.h
//  frc1711
//
//  Created by Elijah Cobb on 1/13/17.
//  Copyright © 2017 Apollo Technology. All rights reserved.
//

#import <Parse/Parse.h>
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@interface ParseDB : NSObject

+(instancetype)data;
+(void)getScouting:(void (^)(NSError *error, BOOL succeeded))block;
+(void)getGroundScouting:(void (^)(NSError *error, BOOL succeeded))block;
+(void)provisionDatabaseForEvent:(NSString *)eventId block:(void (^)(NSError *error, BOOL succeeded))block;
+(void)getScoutingAndGroundScoutingData:(void (^)(NSError *error, BOOL succeeded))block;

@property NSArray *teams;
@property NSArray *matches;
@property NSString *eventKey;
@property NSArray *availableEventKeys;
@property NSString *userSelectedKey;

@end
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@interface PDBGSTeam : NSObject

@property NSString *name;
@property int number;

@property BOOL canShootHighGoalTeleOp;
@property BOOL canShootLowGoalTeleOp;
@property BOOL canDeliverGear;
@property int ballCarryingCapacity;
@property BOOL canScale;
@property BOOL canShootHighGoalAuton;
@property BOOL canShootLowGoalAuton;
@property BOOL canCrossBaseline;

@property PFObject *serverObject;
@property NSString *eventKey;

@property NSDate *lastUpdated;

-(void)update:(void (^)(NSError *error, BOOL succeeded))block;

@end
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@interface PDBSTeam : NSObject

//variables
@property int finalScoreTeleOp;
@property int highGoalCountTeleOp;
@property int lowGoalCountTeleOp;
@property int highGoalCountAuton;
@property int lowGoalCountAuton;
@property BOOL didCrossBaseline;
@property BOOL didScale;
@property int finalScoreAuton;

@property NSDate *lastUpdated;

@property int number;
@property NSString *eventKey;
@property int alliance;
@property PFObject *serverObject;
@property NSString *dataId;
typedef NS_ENUM(NSInteger, ATAlliance) {BlueAlliance,RedAlliance};

-(void)update:(void (^)(NSError *error, BOOL succeeded))block;

@end
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
@interface PDBSMatch : NSObject

@property NSString *eventKey;
@property int number;

@property NSDate *lastUpdated;

@property PDBSTeam *blueTeam1;
@property PDBSTeam *blueTeam2;
@property PDBSTeam *blueTeam3;
@property PDBSTeam *redTeam1;
@property PDBSTeam *redTeam2;
@property PDBSTeam *redTeam3;

@end
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

