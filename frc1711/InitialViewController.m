//
//  InitialViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 3/19/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "InitialViewController.h"
#import <Parse/Parse.h>

@interface InitialViewController ()

@end

@implementation InitialViewController

-(void)viewDidAppear:(BOOL)animated{
	PFUser *user = [PFUser currentUser];
	if (user) {
		[PFConfig getConfigInBackgroundWithBlock:^(PFConfig * _Nullable config, NSError * _Nullable error) {
			BOOL allowBoot = [config[@"allowBoot"] boolValue];
			BOOL allowOtherThen1711 = [config[@"allowOtherThen1711"] boolValue];
			NSArray *allowedVersions = config[@"allowedVersions"];
			
			if ([allowedVersions containsObject:@""]) {
				if (allowOtherThen1711) {
					if (allowBoot) {
						[self segueToHome];
					} else {
						[self showErrorWithMessage:@"Check back later, someone let a raptor out."];
					}
				} else {
					[self showErrorWithMessage:@"Check back later, someone let a raptor out."];
				}
			} else {
				[self showErrorWithMessage:@"Please update the app, we probably fixed a nasty bug."];
			}
		}];
	} else {
		[self segutToSignIn];
	}
}

-(void)segutToSignIn{
	UIViewController *signInVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signIn"];
	[self presentViewController:signInVC animated:YES completion:^{
		
	}];
}

-(void)showErrorWithMessage:(NSString *)message{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hmm." message:message preferredStyle:UIAlertControllerStyleAlert];
	[self presentViewController:alertController animated:YES completion:nil];
}

-(void)segueToHome{
    UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
    [self presentViewController:homeVC animated:YES completion:^{
		
    }];
}

@end
