//
//  ATGScouting.h
//  frc1711
//
//  Created by Elijah Cobb on 10/31/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Parse/Parse.h>
#import "ATGSTeam.h"
#import "ATFRC.h"

@interface ATGScouting : NSObject

+(instancetype)data;
+(NSString *)teamId;
+(void)getTeams:(void (^)(NSError *error, BOOL succeeded))block;
+(void)resetDataBaseForEvent:(NSString *)eventId block:(void (^)(NSError *error, BOOL succeeded))block;

@property NSMutableArray *teams;

@end
