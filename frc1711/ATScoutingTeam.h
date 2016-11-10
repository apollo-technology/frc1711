//
//  ATScoutingTeam.h
//  frc1711
//
//  Created by Elijah Cobb on 11/10/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATScoutingTeam : NSObject

typedef NS_ENUM(NSInteger, ATAlliance) {
	BlueAlliance,
	RedAlliance,
};

@property int number;
@property int alliance;

@end
