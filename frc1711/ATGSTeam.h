//
//  ATGSTeam.h
//  frc1711
//
//  Created by Elijah Cobb on 10/31/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATGSTeam : NSObject

@property NSString *name;
@property int number;

@property BOOL canShootHighGoal;
@property BOOL canShootLowGoal;
@property BOOL canDeliverGear;
@property int ballCarryingCapacity;
@property BOOL canScale;
@property BOOL autonCanHighGoal;
@property BOOL autonCanLowGoal;
@property BOOL autonCanCrossBase;

/*
 Add all properties here
 */

-(void)pushUpdates:(void (^)(NSError *error, BOOL succeeded))block;
-(void)destroy:(void (^)(NSError *error, BOOL succeeded))block;


@end
