//
//  ATGradients.h
//  ApolloGradients
//
//  Created by Elijah Cobb on 4/7/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATColors.h"

@interface ATGradients : NSObject

typedef NS_ENUM(NSInteger, ATGradientType) {
    NightHawk,
};

+(void)applyGradient:(ATGradientType *)gradient onView:(UIView *)view;

+(void)applyGradientFromColor:(UIColor *)color1 andColor:(UIColor *)color2 onView:(UIView *)view;

@end
