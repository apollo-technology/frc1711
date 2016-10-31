//
//  ATGSTeam.h
//  frc1711
//
//  Created by Elijah Cobb on 10/31/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATGSTeam : NSObject

@property NSString *foo;

-(void)pushUpdates:(void (^)(NSError *error, BOOL succeeded))block;

@end
