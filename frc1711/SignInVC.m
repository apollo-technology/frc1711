//
//  SignInVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "SignInVC.h"
#import "ATGradients.h"
#import <Parse/Parse.h>
#import <SinchVerification/SinchVerification.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface SignInVC (){
    id<SINVerification> _verification;
	IBOutlet UITextField *teamNumberField;
	IBOutlet UITextField *firstNameField;
	IBOutlet UITextField *lastNameField;
	IBOutlet UITextField *phoneField;
	IBOutlet UIView *signInView;
	IBOutlet UILabel *signInLabel;
	IBOutlet UIButton *signInButton;
    UITextField *codeField;
}

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[ATGradients applyGradientFromColor:[UIColor colorWithRed:0.400 green:0.694 blue:0.298 alpha:1.00] andColor:[UIColor colorWithRed:0.537 green:0.910 blue:0.424 alpha:1.00] onView:self.view];
}

-(void)segueToInitial{
    UIViewController *signInVC = [self.storyboard instantiateViewControllerWithIdentifier:@"initial"];
    [self presentViewController:signInVC animated:YES completion:^{
        
    }];
}

-(IBAction)signInButton:(id)sender{
	[self hideStuff:^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Preparing Two-Step Verification\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(130.5, 80);
        spinner.color = [UIColor grayColor];
        [spinner startAnimating];
        [alert.view addSubview:spinner];
        [self presentViewController:alert animated:YES completion:^{
            if (phoneField.text.length > 0) {
                if (firstNameField.text.length > 0) {
                    if (lastNameField.text.length > 0) {
                        if (teamNumberField.text.length > 0) {
                            _verification = [SINVerification SMSVerificationWithApplicationKey:@"5ed9928a-36c4-4d3b-a012-a4cc1d05cb79" phoneNumber:phoneField.text];
                            [_verification initiateWithCompletionHandler:^(BOOL success, NSError *error) {
                                [self dismissViewControllerAnimated:YES completion:^{
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter Verification Code" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                        textField.placeholder = @"Code";
                                        textField.text = @"";
                                        textField.returnKeyType = UIReturnKeyNext;
                                        textField.keyboardType = UIKeyboardTypeNumberPad;
                                        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                                        textField.secureTextEntry = NO;
                                        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                                        codeField = textField;
                                    }];
                                    [alertController addAction:[UIAlertAction actionWithTitle:@"Verify" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        [_verification verifyCode:codeField.text completionHandler:^(BOOL success, NSError* error) {
                                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Signing In\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
                                            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                                            spinner.center = CGPointMake(130.5, 80);
                                            spinner.color = [UIColor grayColor];
                                            [spinner startAnimating];
                                            [alert.view addSubview:spinner];
                                            [self presentViewController:alert animated:YES completion:^{
                                                if (success) {
                                                    PFQuery *query = [PFQuery queryWithClassName:@"User"];
                                                    [query whereKey:@"username" equalTo:phoneField.text];
                                                    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                                                        if (objects.count > 0) {
                                                            [PFUser logInWithUsernameInBackground:phoneField.text password:@"raptors" block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                                                                if (error) {
                                                                    [self dismissViewControllerAnimated:YES completion:^{
                                                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                                        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                                                                        [self presentViewController:alertController animated:YES completion:nil];
                                                                    }];
                                                                } else {
                                                                    [self dismissViewControllerAnimated:YES completion:^{
                                                                        [self segueToInitial];
                                                                    }];
                                                                }
                                                            }];
                                                        } else {
                                                            PFUser *user = [PFUser user];
                                                            user[@"firstName"] = firstNameField.text;
                                                            user[@"lastName"] = lastNameField.text;
                                                            user[@"team"] = teamNumberField.text;
                                                            user.username = phoneField.text;
                                                            user.password = @"raptors";
                                                            user.email = @"nope";
                                                            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                                if (error) {
                                                                    [self dismissViewControllerAnimated:YES completion:^{
                                                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                                        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                                                                        [self presentViewController:alertController animated:YES completion:nil];
                                                                    }];
                                                                } else {
                                                                    [self segueToInitial];
                                                                }
                                                            }];
                                                        }
                                                    }];
                                                } else {
                                                    [self dismissViewControllerAnimated:YES completion:^{
                                                        [self showStuff:^{
                                                            
                                                        }];
                                                    }];
                                                }
                                            }];
                                        }];
                                    }]];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                }];
                            }];
                        } else {
                            [self showError];
                        }
                    } else {
                        [self showError];
                    }
                } else {
                    [self showError];
                }
            } else {
                [self showError];
            }
        }];
    }];
}

-(void)showError{
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please enter correct information." message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

-(void)hideStuff:(void (^)())block{
	signInButton.enabled = NO;
	[UIView animateWithDuration:.75 animations:^{
		signInView.alpha = 0;
		signInLabel.alpha = 0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:.75 animations:^{
			signInButton.alpha = 0;
		} completion:^(BOOL finished) {
			if (block) {
				block();
			}
		}];
	}];
}

-(void)showStuff:(void (^)())block{
	signInButton.enabled = YES;
	[UIView animateWithDuration:.75 animations:^{
		signInButton.alpha = 1;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:.75 animations:^{
            signInView.alpha = 1;
            signInLabel.alpha = 1;
		} completion:^(BOOL finished) {
			if (block) {
				block();
			}
		}];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
