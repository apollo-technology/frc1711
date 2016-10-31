//
//  ATFRCEvent.h
//  ATFRC
//
//  Created by Elijah Cobb on 3/22/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFRCEvent : NSObject

@property NSString *key;
@property NSString *name;
@property NSString *shortName;
@property NSString *code;
@property NSString *type;
@property NSString *district;
@property NSString *year;
@property NSString *location;
@property NSString *address;
@property NSString *website;
@property BOOL isOfficial;
@property NSDictionary *webcast;
@property NSDictionary *alliances;
@property NSString *startDateString;
@property NSString *endDateString;
@property NSDate *startDate;
@property NSDate *endDate;

@end
