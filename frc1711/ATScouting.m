//
//  ATScouting.m
//  frc1711
//
//  Created by Elijah Cobb on 11/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ATScouting.h"
#import "ATScoutingTeam.h"
#import "ATMatch.h"

#define ifNotError if (error) {if (block) {NSLog(@"%@",error);block(error,NO);}} else

@implementation ATScouting

+ (instancetype)data {
	static ATScouting *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[[self class] alloc] init];
	});
	return sharedManager;
}

+(NSString *)teamId{
	return [[PFUser currentUser] objectForKey:@"team"];
}

+(ATScoutingTeam *)scoutingTeamForObject:(NSDictionary *)object{
	ATScoutingTeam *team = [ATScoutingTeam new];
	
	team.number = [object[@"number"] intValue];
	
	return team;
}

+(void)getData:(void (^)(NSError *error, BOOL succeeded))block{
	PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"s%@",[self teamId]]];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		ifNotError {
			NSMutableArray *matches = [NSMutableArray new];
			for (PFObject *object in objects) {
				ATMatch *match = [ATMatch new];
				
				match.redTeam1 = [self scoutingTeamForObject:object[@"redTeam1"]];
				match.redTeam2 = [self scoutingTeamForObject:object[@"redTeam2"]];
				match.redTeam3 = [self scoutingTeamForObject:object[@"redTeam3"]];
				match.blueTeam1 = [self scoutingTeamForObject:object[@"blueTeam1"]];
				match.blueTeam2 = [self scoutingTeamForObject:object[@"blueTeam2"]];
				match.blueTeam3 = [self scoutingTeamForObject:object[@"blueTeam3"]];
				match.number = [object[@"number"] intValue];
				match.key = object[@"key"];
				
				[matches addObject:match];
			}
		}
	}];
}

+(void)setDatabaseForEvent:(NSString *)eventCode block:oblock{
	PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"s%@",[self teamId]]];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
		ifNotError {
			[PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
				if (!succeeded) {
					NSLog(@"%@",error);
					if (block) {
						block(error,NO);
					}
				} else {
					[ATFRC qualifyingMatchesAtEvent:eventCode completion:^(NSArray *matches, BOOL succeeded) {
						if (!succeeded) {
							if (block) {
								block(nil,NO);
							}
						} else {
							NSMutableArray *matchesToUpload = [NSMutableArray new];
							for (ATFRCMatch *match in matches) {
								PFObject *object = [PFObject objectWithClassName:[NSString stringWithFormat:@"s%@",[self teamId]]];
								
								object[@"key"] = match.key;
								object[@"number"] = match.setNumber;
								object[@"redTeam1"] = @{@"number" : @([[match.redTeams[0] stringByReplacingOccurrencesOfString:@"frc" withString:@""] intValue])};
								object[@"redTeam2"] = @{@"number" : @([[match.redTeams[1] stringByReplacingOccurrencesOfString:@"frc" withString:@""] intValue])};
								object[@"redTeam3"] = @{@"number" : @([[match.redTeams[2] stringByReplacingOccurrencesOfString:@"frc" withString:@""] intValue])};
								object[@"blueTeam1"] = @{@"number" : @([[match.blueTeams[0] stringByReplacingOccurrencesOfString:@"frc" withString:@""] intValue])};
								object[@"blueTeam2"] = @{@"number" : @([[match.blueTeams[1] stringByReplacingOccurrencesOfString:@"frc" withString:@""] intValue])};
								object[@"blueTeam3"] = @{@"number" : @([[match.blueTeams[2] stringByReplacingOccurrencesOfString:@"frc" withString:@""] intValue])};
								
								[matchesToUpload addObject:object];
							}
							[PFObject saveAllInBackground:matchesToUpload block:^(BOOL succeeded, NSError * _Nullable error) {
								ifNotError {
									if (block) {
										block(nil,YES);
									}
								}
							}];
						}
					}];
				}
			}];
		}
	}];
}

+(void)updateDatabaseForEvent:(NSString *)eventCode block:oblock{
	[ATFRC matchesAtEvent:eventCode completion:^(NSArray *matches, BOOL succeeded) {
		
	}];
}

+(void)setResultsForTeam:(NSString *)team forAlliance:(ATAlliance)alliance forMatch:(NSString *)match block:oblock{
	
}

+(void)get{
	
}

@end
