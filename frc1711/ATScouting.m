//
//  ATScouting.m
//  frc1711
//
//  Created by Elijah Cobb on 11/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ATScouting.h"

@implementation ATScouting

+(void)setDatabaseForEvent:(NSString *)eventCode block:oblock{
	[ATFRC matchesAtEvent:eventCode completion:^(NSArray *matches, BOOL succeeded) {
		
	}];
}

+(void)updateDatabaseForEvent:(NSString *)eventCode block:oblock{
	[ATFRC matchesAtEvent:eventCode completion:^(NSArray *matches, BOOL succeeded) {
		
	}];
}

+(void)setResultsForTeam:(NSString *)team forAlliance:(ATAlliance)alliance forMatch:(NSString *)match block:oblock{
	
}

@end
