//
//  ATMatch.h
//  frc1711
//
//  Created by Elijah Cobb on 11/4/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATScoutingTeam.h"

@interface ATMatch : NSObject

@property NSString *key;
@property int number;

@property ATScoutingTeam *blueTeam1;
@property ATScoutingTeam *blueTeam2;
@property ATScoutingTeam *blueTeam3;
@property ATScoutingTeam *redTeam1;
@property ATScoutingTeam *redTeam2;
@property ATScoutingTeam *redTeam3;

@end
