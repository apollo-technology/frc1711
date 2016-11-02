//
//  ATScouting.h
//  frc1711
//
//  Created by Elijah Cobb on 11/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Parse/Parse.h>
#import "ATFRC.h"

#define oblock (void (^)(NSError *error, BOOL succeeded))block

@interface ATScouting : NSObject

typedef NS_ENUM(NSInteger, ATAlliance) {
	BlueAlliance,
	RedAlliance,
};

+(void)setDatabaseForEvent:(NSString *)eventCode block:oblock;
+(void)setResultsForTeam:(NSString *)team forAlliance:(ATAlliance)alliance forMatch:(NSString *)match block:oblock;

@end
