//
//  DBAnalytics.h
//  frc1711
//
//  Created by Elijah Cobb on 1/13/17.
//  Copyright © 2017 Apollo Technology. All rights reserved.
//

#import <Parse/Parse.h>

@interface DBAnalytic : NSObject

@end

@interface DBAnalyticsManager : NSObject

+(void)analyticsForTeam:(int)team block:(void (^)(NSError *error, DBAnalytic *analytic))block;

@end
