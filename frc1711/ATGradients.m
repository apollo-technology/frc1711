//
//  ATGradients.m
//  ApolloGradients
//
//  Created by Elijah Cobb on 4/7/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ATGradients.h"

@implementation ATGradients

+(void)applyGradientFromColor:(UIColor *)color1 andColor:(UIColor *)color2 onView:(UIView *)view{
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)color1.CGColor, (id)color2.CGColor, nil];
    theViewGradient.frame = view.bounds;
    [view.layer insertSublayer:theViewGradient atIndex:0];
}

+(void)applyGradient:(ATGradientType *)gradient onView:(UIView *)view{
    
}

@end
