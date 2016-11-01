//
//  AppConfigs.h
//  frc1711
//
//  Created by Elijah Cobb on 11/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfigs : NSObject

+(instancetype)configs;

@property NSArray *allowedVersions;
@property BOOL allowBoot;
@property BOOL allowOtherThen1711;
@property NSString *homeWelcome;
@property NSString *homeMessage;
@property NSString *constructionMessage;


@end
