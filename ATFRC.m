//
//  ATFRC.m
//  ATFRC
//
//  Created by Elijah Cobb on 3/22/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.a
//

#import "ATFRC.h"

@implementation ATFRC


#pragma mark - Class Methods
+ (instancetype)controller{
    static ATFRC *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

+(void)getDictionaryForURL:(NSString *)urlString completion:(void (^)(NSDictionary *dictionary,BOOL succeeded))completionHandler{
    NSError *error;
    NSDictionary *contentData;
    NSString *stringToSend = [NSString stringWithFormat:@"http://www.thebluealliance.com%@?X-TBA-App-Id=1711:dataApp:2",urlString];
    NSData *recievedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringToSend]];
    if (recievedData) {
        contentData = [NSJSONSerialization JSONObjectWithData:recievedData options:0 error:&error];
        if (error) {
            completionHandler(contentData,NO);
        } else {
            completionHandler(contentData,YES);
        }
    } else {
        completionHandler(contentData,NO);
    }
}

+(void)getArrayForURL:(NSString *)urlString completion:(void (^)(NSArray *array,BOOL succeeded))completionHandler{
    NSError *error;
    NSString *stringToSend = [NSString stringWithFormat:@"http://www.thebluealliance.com%@?X-TBA-App-Id=1711:dataApp:2",urlString];
    NSData *recievedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringToSend]];
    NSArray *contentData;
    if (recievedData) {
        contentData = [NSJSONSerialization JSONObjectWithData:recievedData options:0 error:&error];
        if (error) {
            completionHandler(contentData,NO);
        } else {
            completionHandler(contentData,YES);
        }
    } else {
        completionHandler(contentData,NO);
    }
}

#pragma mark - Team Requests
+(void)teamsWithCompletion:(void (^)(NSArray *teams,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:@"/api/v2/teams/0" completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *teams = [NSMutableArray new];
            for (NSDictionary *teamDictionary in array) {
                ATFRCTeam *newTeam = [ATFRCTeam new];
                newTeam.country = [teamDictionary objectForKey:@"contry_name"];
                newTeam.key = [teamDictionary objectForKey:@"key"];
                newTeam.city = [teamDictionary objectForKey:@"locality"];
                newTeam.location = [teamDictionary objectForKey:@"location"];
                newTeam.motto = [teamDictionary objectForKey:@"motto"];
                newTeam.nickname = [teamDictionary objectForKey:@"nickname"];
                newTeam.name = [teamDictionary objectForKey:@"name"];
                newTeam.state = [teamDictionary objectForKey:@"region"];
                newTeam.rookieYear = [teamDictionary objectForKey:@"rookie_year"];
                newTeam.number = [teamDictionary objectForKey:@"team_number"];
                newTeam.websiteURL = [teamDictionary objectForKey:@"website"];
                [teams addObject:newTeam];
            }
            completionHandler(teams,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)teamsInPage:(NSString *)pages completion:(void (^)(NSArray *teams,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/teams/%@",pages] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *teams = [NSMutableArray new];
            for (NSDictionary *teamDictionary in array) {
                ATFRCTeam *newTeam = [ATFRCTeam new];
                newTeam.country = [teamDictionary objectForKey:@"contry_name"];
                newTeam.key = [teamDictionary objectForKey:@"key"];
                newTeam.city = [teamDictionary objectForKey:@"locality"];
                newTeam.location = [teamDictionary objectForKey:@"location"];
                newTeam.motto = [teamDictionary objectForKey:@"motto"];
                newTeam.nickname = [teamDictionary objectForKey:@"nickname"];
                newTeam.name = [teamDictionary objectForKey:@"name"];
                newTeam.state = [teamDictionary objectForKey:@"region"];
                newTeam.rookieYear = [teamDictionary objectForKey:@"rookie_year"];
                newTeam.number = [teamDictionary objectForKey:@"team_number"];
                newTeam.websiteURL = [teamDictionary objectForKey:@"website"];
                [teams addObject:newTeam];
            }
            completionHandler(teams,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)teamForTeamNumber:(NSString *)teamNumber completion:(void (^)(ATFRCTeam *team, BOOL succeeded))completionHandler{
    [ATFRC getDictionaryForURL:[NSString stringWithFormat:@"/api/v2/team/frc%@",teamNumber] completion:^(NSDictionary *dictionary, BOOL succeeded) {
        if (succeeded) {
            ATFRCTeam *newTeam = [ATFRCTeam new];
            newTeam.country = [dictionary objectForKey:@"country_name"];
            newTeam.key = [dictionary objectForKey:@"key"];
            newTeam.city = [dictionary objectForKey:@"locality"];
            newTeam.location = [dictionary objectForKey:@"location"];
            newTeam.motto = [dictionary objectForKey:@"motto"];
            newTeam.nickname = [dictionary objectForKey:@"nickname"];
            newTeam.name = [dictionary objectForKey:@"name"];
            newTeam.state = [dictionary objectForKey:@"region"];
            newTeam.rookieYear = [dictionary objectForKey:@"rookie_year"];
            newTeam.number = [dictionary objectForKey:@"team_number"];
            newTeam.websiteURL = [dictionary objectForKey:@"website"];
            completionHandler(newTeam,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)eventsForTeam:(NSString *)teamNumber inYear:(NSString *)year completion:(void (^)(NSArray *events,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/team/frc%@/%@/events",teamNumber,year] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *events = [NSMutableArray new];
            for (NSDictionary *eventDictionary in array) {
                ATFRCEvent *newEvent = [ATFRCEvent new];
                newEvent.key = eventDictionary[@"key"];
                newEvent.name = eventDictionary[@"name"];
                newEvent.shortName = eventDictionary[@"short_name"];
                newEvent.code = eventDictionary[@"event_code"];
                newEvent.type = eventDictionary[@"event_type_string"];
                newEvent.district = eventDictionary[@"event_district_string"];
                newEvent.year = eventDictionary[@"year"];
                newEvent.location = eventDictionary[@"location"];
                newEvent.address = eventDictionary[@"venue_address"];
                newEvent.website = eventDictionary[@"website"];
                newEvent.isOfficial = [eventDictionary[@"official"] boolValue];
                newEvent.webcast = eventDictionary[@"webcast"];
                newEvent.startDateString = [ATFRC fixDateFromString:eventDictionary[@"start_date"]];
                newEvent.endDateString = [ATFRC fixDateFromString:eventDictionary[@"end_date"]];
                newEvent.startDate = [ATFRC dateFromString:eventDictionary[@"start_date"]];
                newEvent.endDate = [ATFRC dateFromString:eventDictionary[@"end_date"]];
                [events addObject:newEvent];
            }
            completionHandler(events,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)awardsForTeam:(NSString *)teamNumber withEventCode:(NSString *)eventCode completion:(void (^)(NSArray *awards,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/team/frc%@/event/%@/awards",teamNumber,eventCode] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *awards = [NSMutableArray new];
            for (NSDictionary *awardDictionary in array) {
                ATFRCAwards *newAward = [ATFRCAwards new];
                newAward.name = awardDictionary[@"name"];
                newAward.eventKey = awardDictionary[@"event_key"];
                newAward.year = awardDictionary[@"year"];
                NSArray *recipients = awardDictionary[@"recipient_list"];
                NSMutableArray *recipientTeamNumbers = [NSMutableArray new];
                for (NSDictionary *currentRecipient in recipients) {
                    [recipientTeamNumbers addObject:currentRecipient[@"team_number"]];
                }
                newAward.recipientList = recipientTeamNumbers;
                [awards addObject:newAward];
            }
            completionHandler(awards,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)matchesForTeam:(NSString *)teamNumber withEventCode:(NSString *)eventCode completion:(void (^)(NSArray *matches,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/team/frc%@/event/%@/matches",teamNumber,eventCode] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *matches = [NSMutableArray new];
            for (NSDictionary *matchDictionary in array) {
                ATFRCMatch *newMatch = [ATFRCMatch new];
                newMatch.key = matchDictionary[@"key"];
                newMatch.competitionLevel = matchDictionary[@"comp_level"];
                newMatch.setNumber = matchDictionary[@"set_number"];
                newMatch.blueTeams = matchDictionary[@"alliances"][@"blue"][@"teams"];
                newMatch.redTeams = matchDictionary[@"alliances"][@"red"][@"teams"];
                newMatch.eventKey = matchDictionary[@"key"];
                newMatch.videos = matchDictionary[@"videos"];
                newMatch.time = matchDictionary[@"time"];
                newMatch.timeReadable = matchDictionary[@"time_string"];
                [matches addObject:newMatch];
            }
            completionHandler(matches,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)yearsParticipatedForTeam:(NSString *)teamNumber completion:(void (^)(NSArray *years,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/team/frc%@/years_participated",teamNumber] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            completionHandler(array,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)mediaForTeam:(NSString *)teamNumber year:(NSString *)year completion:(void (^)(NSArray *media,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/team/frc%@/%@/media",teamNumber,year] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *media = [NSMutableArray new];
            for (NSDictionary *mediaDictionary in array) {
                ATFRCMedia *newMedia = [ATFRCMedia new];
                newMedia.type = mediaDictionary[@"type"];
                newMedia.details = mediaDictionary[@"details"];
                newMedia.foreignKey = mediaDictionary[@"foreign_key"];
                [media addObject:newMedia];
            }
            completionHandler(media,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}


#pragma mark - Event Requests
+(void)eventsForCurrentYear:(void (^)(NSArray *events,BOOL succeeded))completionHandler{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];

    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/events/%@",stringFromDate] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *events = [NSMutableArray new];
            for (NSDictionary *eventDictionary in array) {
                ATFRCEvent *newEvent = [ATFRCEvent new];
                newEvent.key = eventDictionary[@"key"];
                newEvent.name = eventDictionary[@"name"];
                newEvent.shortName = eventDictionary[@"short_name"];
                newEvent.code = eventDictionary[@"event_code"];
                newEvent.type = eventDictionary[@"event_type_string"];
                newEvent.district = eventDictionary[@"event_district_string"];
                newEvent.year = eventDictionary[@"year"];
                newEvent.location = eventDictionary[@"location"];
                newEvent.address = eventDictionary[@"venue_address"];
                newEvent.website = eventDictionary[@"website"];
                newEvent.isOfficial = [eventDictionary[@"official"] boolValue];
                newEvent.webcast = eventDictionary[@"webcast"];
                newEvent.alliances = eventDictionary[@"alliances"];
                newEvent.startDateString = [ATFRC fixDateFromString:eventDictionary[@"start_date"]];
                newEvent.endDateString = [ATFRC fixDateFromString:eventDictionary[@"end_date"]];
                newEvent.startDate = [ATFRC dateFromString:eventDictionary[@"start_date"]];
                newEvent.endDate = [ATFRC dateFromString:eventDictionary[@"end_date"]];
                [events addObject:newEvent];
            }
            completionHandler(events,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)eventsForYear:(NSString *)year completion:(void (^)(NSArray *events,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/events/%@",year] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *events = [NSMutableArray new];
            for (NSDictionary *eventDictionary in array) {
                ATFRCEvent *newEvent = [ATFRCEvent new];
                newEvent.key = eventDictionary[@"key"];
                newEvent.name = eventDictionary[@"name"];
                newEvent.shortName = eventDictionary[@"short_name"];
                newEvent.code = eventDictionary[@"event_code"];
                newEvent.type = eventDictionary[@"event_type_string"];
                newEvent.district = eventDictionary[@"event_district_string"];
                newEvent.year = eventDictionary[@"year"];
                newEvent.location = eventDictionary[@"location"];
                newEvent.address = eventDictionary[@"venue_address"];
                newEvent.website = eventDictionary[@"website"];
                newEvent.isOfficial = [eventDictionary[@"official"] boolValue];
                newEvent.webcast = eventDictionary[@"webcast"];
                newEvent.alliances = eventDictionary[@"alliances"];
                newEvent.startDateString = [ATFRC fixDateFromString:eventDictionary[@"start_date"]];
                newEvent.endDateString = [ATFRC fixDateFromString:eventDictionary[@"end_date"]];
                newEvent.startDate = [ATFRC dateFromString:eventDictionary[@"start_date"]];
                newEvent.endDate = [ATFRC dateFromString:eventDictionary[@"end_date"]];
                [events addObject:newEvent];
            }
            completionHandler(events,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)eventForKey:(NSString *)eventKey completion:(void (^)(ATFRCEvent *event,BOOL succeeded))completionHandler{
    [ATFRC getDictionaryForURL:[NSString stringWithFormat:@"/api/v2/event/%@",eventKey] completion:^(NSDictionary *eventDictionary, BOOL succeeded) {
        ATFRCEvent *newEvent = [ATFRCEvent new];
        if (succeeded) {
            newEvent.key = eventDictionary[@"key"];
            newEvent.name = eventDictionary[@"name"];
            newEvent.shortName = eventDictionary[@"short_name"];
            newEvent.code = eventDictionary[@"event_code"];
            newEvent.type = eventDictionary[@"event_type_string"];
            newEvent.district = eventDictionary[@"event_district_string"];
            newEvent.year = eventDictionary[@"year"];
            newEvent.location = eventDictionary[@"location"];
            newEvent.address = eventDictionary[@"venue_address"];
            newEvent.website = eventDictionary[@"website"];
            newEvent.isOfficial = [eventDictionary[@"official"] boolValue];
            newEvent.webcast = eventDictionary[@"webcast"];
            newEvent.alliances = eventDictionary[@"alliances"];
            newEvent.startDateString = [ATFRC fixDateFromString:eventDictionary[@"start_date"]];
            newEvent.endDateString = [ATFRC fixDateFromString:eventDictionary[@"end_date"]];
            newEvent.startDate = [ATFRC dateFromString:eventDictionary[@"start_date"]];
            newEvent.endDate = [ATFRC dateFromString:eventDictionary[@"end_date"]];
            completionHandler(newEvent,YES);
        } else {
            completionHandler(newEvent,NO);
        }
    }];
}

+(NSDate *)dateFromString:(NSString *)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+(NSString *)fixDateFromString:(NSString *)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM/dd/yy"];
    NSString *stringFromDate = [formatter2 stringFromDate:date];
    
    return stringFromDate;
}

+(void)teamsAtEvent:(NSString *)eventKey completion:(void (^)(NSArray *teams,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/event/%@/teams",eventKey] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *teams = [NSMutableArray new];
            for (NSDictionary *teamDictionary in array) {
                ATFRCTeam *newTeam = [ATFRCTeam new];
                newTeam.country = [teamDictionary objectForKey:@"contry_name"];
                newTeam.key = [teamDictionary objectForKey:@"key"];
                newTeam.city = [teamDictionary objectForKey:@"locality"];
                newTeam.location = [teamDictionary objectForKey:@"location"];
                newTeam.motto = [teamDictionary objectForKey:@"motto"];
                newTeam.nickname = [teamDictionary objectForKey:@"nickname"];
                newTeam.name = [teamDictionary objectForKey:@"name"];
                newTeam.state = [teamDictionary objectForKey:@"region"];
                newTeam.rookieYear = [teamDictionary objectForKey:@"rookie_year"];
                newTeam.number = [teamDictionary objectForKey:@"team_number"];
                newTeam.websiteURL = [teamDictionary objectForKey:@"website"];
                [teams addObject:newTeam];
            }
            completionHandler(teams,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)matchesAtEvent:(NSString *)eventKey completion:(void (^)(NSArray *matches,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/event/%@/matches",eventKey] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *matches = [NSMutableArray new];
            for (NSDictionary *matchDictionary in array) {
                ATFRCMatch *newMatch = [ATFRCMatch new];
                newMatch.key = matchDictionary[@"key"];
                newMatch.competitionLevel = matchDictionary[@"comp_level"];
                newMatch.setNumber = matchDictionary[@"match_number"];
                newMatch.blueTeams = matchDictionary[@"alliances"][@"blue"][@"teams"];
                newMatch.redTeams = matchDictionary[@"alliances"][@"red"][@"teams"];
                newMatch.eventKey = matchDictionary[@"key"];
                newMatch.videos = matchDictionary[@"videos"];
                newMatch.time = matchDictionary[@"time"];
                newMatch.timeReadable = matchDictionary[@"time_string"];
				[matches addObject:newMatch];
            }
            completionHandler(matches,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)qualifyingMatchesAtEvent:(NSString *)eventKey completion:(void (^)(NSArray *, BOOL))completionHandler{
	[ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/event/%@/matches",eventKey] completion:^(NSArray *array, BOOL succeeded) {
        if (array.count == 0) {
            completionHandler(nil,NO);
        } else {
            if (succeeded) {
                NSMutableArray *matches = [NSMutableArray new];
                for (NSDictionary *matchDictionary in array) {
                    ATFRCMatch *newMatch = [ATFRCMatch new];
                    newMatch.key = matchDictionary[@"key"];
                    newMatch.competitionLevel = matchDictionary[@"comp_level"];
                    newMatch.setNumber = matchDictionary[@"match_number"];
                    newMatch.blueTeams = matchDictionary[@"alliances"][@"blue"][@"teams"];
                    newMatch.redTeams = matchDictionary[@"alliances"][@"red"][@"teams"];
                    newMatch.eventKey = matchDictionary[@"key"];
                    newMatch.videos = matchDictionary[@"videos"];
                    newMatch.time = matchDictionary[@"time"];
                    newMatch.timeReadable = matchDictionary[@"time_string"];
                    if ([matchDictionary[@"comp_level"] isEqualToString:@"qm"]) {
                        [matches addObject:newMatch];
                    }
                }
                completionHandler(matches,YES);
            } else {
                completionHandler(nil,NO);
            }
        }
	}];
}

+(void)rankingsForEvent:(NSString *)eventKey completion:(void (^)(NSArray *rankings,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/event/%@/rankings",eventKey] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            completionHandler(array,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)awardsForEvent:(NSString *)eventKey completion:(void (^)(NSArray *awards,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/event/%@/awards",eventKey] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *awards = [NSMutableArray new];
            for (NSDictionary *awardDictionary in array) {
                ATFRCAwards *newAward = [ATFRCAwards new];
                newAward.name = awardDictionary[@"name"];
                newAward.eventKey = awardDictionary[@"event_key"];
                newAward.year = awardDictionary[@"year"];
                NSArray *recipients = awardDictionary[@"recipient_list"];
                NSMutableArray *recipientTeamNumbers = [NSMutableArray new];
                for (NSDictionary *currentRecipient in recipients) {
                    [recipientTeamNumbers addObject:currentRecipient[@"team_number"]];
                }
                newAward.recipientList = recipientTeamNumbers;
                [awards addObject:newAward];
            }
            completionHandler(awards,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}


#pragma mark - Match Requests
+(void)matchForKey:(NSString *)matchKey completion:(void (^)(ATFRCMatch *match,BOOL succeeded))completionHandler{
    [ATFRC getDictionaryForURL:[NSString stringWithFormat:@"/api/v2/match/%@",matchKey] completion:^(NSDictionary *matchDictionary, BOOL succeeded) {
        ATFRCMatch *newMatch = [ATFRCMatch new];
        if (succeeded) {
            newMatch.key = matchDictionary[@"key"];
            newMatch.competitionLevel = matchDictionary[@"comp_level"];
            newMatch.setNumber = matchDictionary[@"set_number"];
            newMatch.blueTeams = matchDictionary[@"alliances"][@"blue"][@"teams"];
            newMatch.redTeams = matchDictionary[@"alliances"][@"red"][@"teams"];
            newMatch.eventKey = matchDictionary[@"key"];
            newMatch.videos = matchDictionary[@"videos"];
            newMatch.time = matchDictionary[@"time"];
            newMatch.timeReadable = matchDictionary[@"time_string"];
            completionHandler(newMatch,YES);
        } else {
            completionHandler(newMatch,NO);
        }
    }];
}


#pragma mark - District Requests
+(void)districtsForCurrentYear:(void (^)(NSArray *districts,BOOL succeeded))completionHandler{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/districts/%@",stringFromDate] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            completionHandler(array,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)districtsForYear:(NSString *)year completion:(void (^)(NSArray *districts,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/districts/%@",year] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            completionHandler(array,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)eventsForDistrict:(NSString *)districtKey year:(NSString *)year completion:(void (^)(NSArray *events,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/district/%@/%@/events",districtKey,year] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *events = [NSMutableArray new];
            for (NSDictionary *eventDictionary in array) {
                ATFRCEvent *newEvent = [ATFRCEvent new];
                newEvent.key = eventDictionary[@"key"];
                newEvent.name = eventDictionary[@"name"];
                newEvent.shortName = eventDictionary[@"short_name"];
                newEvent.code = eventDictionary[@"event_code"];
                newEvent.type = eventDictionary[@"event_type_string"];
                newEvent.district = eventDictionary[@"event_district_string"];
                newEvent.year = eventDictionary[@"year"];
                newEvent.location = eventDictionary[@"location"];
                newEvent.address = eventDictionary[@"venue_address"];
                newEvent.website = eventDictionary[@"website"];
                newEvent.isOfficial = [eventDictionary[@"official"] boolValue];
                newEvent.webcast = eventDictionary[@"webcast"];
                newEvent.alliances = eventDictionary[@"alliances"];
                newEvent.startDateString = [ATFRC fixDateFromString:eventDictionary[@"start_date"]];
                newEvent.endDateString = [ATFRC fixDateFromString:eventDictionary[@"end_date"]];
                newEvent.startDate = [ATFRC dateFromString:eventDictionary[@"start_date"]];
                newEvent.endDate = [ATFRC dateFromString:eventDictionary[@"end_date"]];
                [events addObject:newEvent];
            }
            completionHandler(events,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)rankingsForDistrict:(NSString *)districtKey year:(NSString *)year completion:(void (^)(NSArray *rankings,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/district/%@/%@/rankings",districtKey,year] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            completionHandler(array,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)teamsInDistrict:(NSString *)districtKey year:(NSString *)year completion:(void (^)(NSArray *teams,BOOL succeeded))completionHandler{
    [ATFRC getArrayForURL:[NSString stringWithFormat:@"/api/v2/district/%@/%@/teams",districtKey,year] completion:^(NSArray *array, BOOL succeeded) {
        if (succeeded) {
            NSMutableArray *events = [NSMutableArray new];
            for (NSDictionary *eventDictionary in array) {
                ATFRCEvent *newEvent = [ATFRCEvent new];
                newEvent.key = eventDictionary[@"key"];
                newEvent.name = eventDictionary[@"name"];
                newEvent.shortName = eventDictionary[@"short_name"];
                newEvent.code = eventDictionary[@"event_code"];
                newEvent.type = eventDictionary[@"event_type_string"];
                newEvent.district = eventDictionary[@"event_district_string"];
                newEvent.year = eventDictionary[@"year"];
                newEvent.location = eventDictionary[@"location"];
                newEvent.address = eventDictionary[@"venue_address"];
                newEvent.website = eventDictionary[@"website"];
                newEvent.isOfficial = [eventDictionary[@"official"] boolValue];
                newEvent.webcast = eventDictionary[@"webcast"];
                newEvent.startDateString = [ATFRC fixDateFromString:eventDictionary[@"start_date"]];
                newEvent.endDateString = [ATFRC fixDateFromString:eventDictionary[@"end_date"]];
                newEvent.startDate = [ATFRC dateFromString:eventDictionary[@"start_date"]];
                newEvent.endDate = [ATFRC dateFromString:eventDictionary[@"end_date"]];
                [events addObject:newEvent];
            }
            completionHandler(events,YES);
        } else {
            completionHandler(nil,NO);
        }
    }];
}

+(void)checkIfEventIsReal:(NSString *)eventKey comepletion:(void (^)(BOOL isReal,NSString *eventName))completionHandler{
    NSString *stringToSend = [NSString stringWithFormat:@"http://www.thebluealliance.com/api/v2/event/%@?X-TBA-App-Id=frc1711:scouting-system:v01",eventKey];
    NSData *recievedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringToSend]];
    if (recievedData) {
        NSDictionary *contentData = [NSJSONSerialization JSONObjectWithData:recievedData options:0 error:nil];
        NSString *eventName = contentData[@"short_name"];
        completionHandler(YES,eventName);
    } else {
        completionHandler(NO,@"");
    }
}

+(void)checkIfTeamIsReal:(NSString *)team completion:(void (^)(BOOL isReal))completionHandler{
    NSString *stringToSend = [NSString stringWithFormat:@"http://www.thebluealliance.com/api/v2/team/frc%@?X-TBA-App-Id=frc1711:scouting-system:v01",team];
    NSData *recievedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringToSend]];
    if (recievedData) {
        completionHandler(YES);
    } else {
        completionHandler(NO);
    }
}

@end
