//
//  AppConfigs.h
//  frc1711
//
//  Created by Elijah Cobb on 11/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppConfigs : NSObject

+(instancetype)configs;

@property NSArray *allowedVersions;
@property BOOL allowBoot;
@property NSString *homeWelcome;
@property NSString *homeMessage;
@property NSString *constructionMessage;
@property NSString *appBuild;
@property NSString *apolloEmail;
@property NSString *raptorEmail;
@property NSString *raptorWebsite;


@end
