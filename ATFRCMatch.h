//
//  ATFRCMatch.h
//  ATFRC
//
//  Created by Elijah Cobb on 3/22/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFRCMatch : NSObject

@property NSString *key;
@property NSString *competitionLevel;
@property NSString *setNumber;
@property NSArray *blueTeams;
@property NSArray *redTeams;
@property NSString *eventKey;
@property NSDictionary *videos;
@property NSString *time;
@property NSString *timeReadable;

@end
