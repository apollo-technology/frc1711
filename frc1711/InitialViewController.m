//
//  InitialViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 3/19/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "InitialViewController.h"
#import <Parse/Parse.h>
#import "ATFRC.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

-(void)viewDidAppear:(BOOL)animated{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // do something
        [self segueToHome];
    });
}

-(void)segueToHome{
    UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
    [self presentViewController:homeVC animated:YES completion:^{
        
    }];
}

@end
