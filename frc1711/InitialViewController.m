//
//  InitialViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 3/19/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "InitialViewController.h"
#import <Parse/Parse.h>
#import "AppConfigs.h"
#import "ParseDB.h"

#define ifNotError if (error) {if (block) {NSLog(@"%@",error);block(error,NO);}} else

@interface InitialViewController (){
	IBOutlet UIActivityIndicatorView *loaderView;
	IBOutlet UIImageView *iconImageView;
	BOOL doneDownloading;
	UIImageView *cirleView;
}

@end

@implementation InitialViewController

-(void)viewDidLoad{
	[super viewDidLoad];
	loaderView.alpha = 0;
}

-(void)animateEverything{
	cirleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launchCircle.png"]];
	cirleView.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 160, 160);
	cirleView.center = iconImageView.center;
	cirleView.alpha = 0;
	[self.view addSubview:cirleView];
	[self.view sendSubviewToBack:cirleView];
	self.view.backgroundColor = [UIColor whiteColor];
	[UIView animateWithDuration:0.75 animations:^{
		cirleView.alpha = 1;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1 animations:^{
			CGRect rect = cirleView.frame;
			rect.size.width = self.view.frame.size.height*1.25;
			rect.size.height = self.view.frame.size.height*1.25;
			cirleView.frame = rect;
			cirleView.center = iconImageView.center;
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				CGRect rect = cirleView.frame;
				rect.size.width = 170;
				rect.size.height = 170;
				cirleView.frame = rect;
				cirleView.center = iconImageView.center;
			} completion:^(BOOL finished) {
                doneDownloading = YES;
				double delayInSeconds = 1;
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
					// do something
                    
					[UIView animateWithDuration:1 animations:^{
						loaderView.alpha = 1;
					}];
				});
			}];
		}];
	}];
}

-(void)viewDidAppear:(BOOL)animated{
	
	doneDownloading = NO;
	
	[self performSelector:@selector(animateEverything) withObject:nil afterDelay:0.25];
    
	
	__block PFUser *user = [PFUser currentUser];
	if (user) {
		[[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
			if (error) {
				[self showErrorWithMessage:error.localizedDescription];
			} else {
                [ParseDB getScoutingAndGroundScoutingData:^(NSError *error, BOOL succeeded) {
                    if (error) {
                        NSLog(@"%@",error);
                    } else {
                        [PFConfig getConfigInBackgroundWithBlock:^(PFConfig * _Nullable config, NSError * _Nullable error) {
                            
                            [[AppConfigs configs] setAllowBoot:[config[@"allowBoot"] boolValue]];
                            [[AppConfigs configs] setAllowedVersions:config[@"allowedVersions"]];
                            [[AppConfigs configs] setHomeWelcome:config[@"home_welcome"]];
                            [[AppConfigs configs] setHomeMessage:config[@"home_message"]];
                            [[AppConfigs configs] setConstructionMessage:config[@"other_constructionMessage"]];
                            [[AppConfigs configs] setRaptorEmail:config[@"raptorEmail"]];
                            [[AppConfigs configs] setApolloEmail:config[@"apolloEmail"]];
                            [[AppConfigs configs] setRaptorWebsite:config[@"raptorWebsite"]];
                            
                            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                            NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                            [[AppConfigs configs] setAppBuild:[NSString stringWithFormat:@"%@",version]];
                            
                            if ([[[AppConfigs configs] allowedVersions] containsObject:[[AppConfigs configs] appBuild]]) {
                                NSLog(@"Aewfewf");
                                if ([[AppConfigs configs] allowBoot]) {
                                    [self segueToHome];
                                } else {
                                    [self showErrorWithMessage:@"Check back later, someone let a raptor out."];
                                }
                            } else {
                                [self showErrorWithMessage:@"Please update the app, we probably fixed a nasty bug."];
                            }
                        }];
                    }
                }];
			}
		}];
	} else {
		[self segutToSignIn];
	}
}

-(void)showController:(UIViewController *)viewController{
	if (doneDownloading) {
		[self presentViewController:viewController animated:NO completion:nil];
	} else {
		double delayInSeconds = 0.1;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self showController:viewController];
		});
	}
}

-(void)segueToSelf{
	UIViewController *signInVC = [self.storyboard instantiateInitialViewController];
	[self showController:signInVC];
}
-(void)segutToSignIn{
	UIViewController *signInVC = [self.storyboard instantiateViewControllerWithIdentifier:@"signIn"];
	[self showController:signInVC];
}

-(void)showErrorWithMessage:(NSString *)message{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hmm." message:message preferredStyle:UIAlertControllerStyleAlert];
	[self presentViewController:alertController animated:YES completion:nil];
}

-(void)segueToHome{
    UIViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
	[self showController:homeVC];
}

@end
