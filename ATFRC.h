//
//  ATFRC.h
//  ATFRC
//
//  Created by Elijah Cobb on 3/22/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATFRCTeam.h"
#import "ATFRCEvent.h"
#import "ATFRCMatch.h"
#import "ATFRCAwards.h"
#import "ATFRCMedia.h"
#import "ATFRCRobot.h"
#import "ATFRCRankings.h"

@interface ATFRC : NSObject

#pragma mark - Class Methods
@property NSString *apiKey;
+(instancetype)controller;

#pragma mark - Team Requests
+(void)teamsWithCompletion:(void (^)(NSArray *teams,BOOL succeeded))completionHandler;
+(void)teamsInPage:(NSString *)pages completion:(void (^)(NSArray *teams,BOOL succeeded))completionHandler;
+(void)teamForTeamNumber:(NSString *)teamNumber completion:(void (^)(ATFRCTeam *team, BOOL succeeded))completionHandler;
+(void)eventsForTeam:(NSString *)teamNumber inYear:(NSString *)year completion:(void (^)(NSArray *events,BOOL succeeded))completionHandler;
+(void)awardsForTeam:(NSString *)teamNumber withEventCode:(NSString *)eventCode completion:(void (^)(NSArray *awards,BOOL succeeded))completionHandler;
+(void)matchesForTeam:(NSString *)teamNumber withEventCode:(NSString *)eventCode completion:(void (^)(NSArray *matches,BOOL succeeded))completionHandler;
+(void)yearsParticipatedForTeam:(NSString *)teamNumber completion:(void (^)(NSArray *years,BOOL succeeded))completionHandler;
+(void)mediaForTeam:(NSString *)teamNumber year:(NSString *)year completion:(void (^)(NSArray *media,BOOL succeeded))completionHandler;

#pragma mark - Event Requests
+(void)eventsForCurrentYear:(void (^)(NSArray *events,BOOL succeeded))completionHandler;
+(void)eventsForYear:(NSString *)year completion:(void (^)(NSArray *events,BOOL succeeded))completionHandler;
+(void)eventForKey:(NSString *)eventKey completion:(void (^)(ATFRCEvent *event,BOOL succeeded))completionHandler;
+(void)teamsAtEvent:(NSString *)eventKey completion:(void (^)(NSArray *teams,BOOL succeeded))completionHandler;
+(void)matchesAtEvent:(NSString *)eventKey completion:(void (^)(NSArray *,BOOL succeeded))completionHandler;
+(void)rankingsForEvent:(NSString *)eventKey completion:(void (^)(NSArray *rankings,BOOL succeeded))completionHandler;
+(void)awardsForEvent:(NSString *)eventKey completion:(void (^)(NSArray *awards,BOOL succeeded))completionHandler;

#pragma mark - Match Requests
+(void)matchForKey:(NSString *)matchKey completion:(void (^)(ATFRCMatch *match,BOOL succeeded))completionHandler;

#pragma mark - District Requests
+(void)districtsForCurrentYear:(void (^)(NSArray *districts,BOOL succeeded))completionHandler;
+(void)districtsForYear:(NSString *)year completion:(void (^)(NSArray *districts,BOOL succeeded))completionHandler;
+(void)eventsForDistrict:(NSString *)districtKey year:(NSString *)year completion:(void (^)(NSArray *events,BOOL succeeded))completionHandler;
+(void)rankingsForDistrict:(NSString *)districtKey year:(NSString *)year completion:(void (^)(NSArray *rankings,BOOL succeeded))completionHandler;
+(void)teamsInDistrict:(NSString *)districtKey year:(NSString *)year completion:(void (^)(NSArray *teams,BOOL succeeded))completionHandler;
+(void)checkIfEventIsReal:(NSString *)eventKey comepletion:(void (^)(BOOL isReal,NSString *eventName))completionHandler;
+(void)checkIfTeamIsReal:(NSString *)team completion:(void (^)(BOOL isReal))completionHandler;

@end