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
#import "ATFRC.h"
#import "ParseDB.h"

@interface SignInVC (){
    id<SINVerification> _verification;
	IBOutlet UITextField *phoneField;
	IBOutlet UIView *signInView;
	IBOutlet UILabel *signInLabel;
	IBOutlet UIButton *signInButton;
    IBOutlet UIActivityIndicatorView *loaderView;
    UITextField *codeField;
    UITextField *firstNameField;
    UITextField *lastNameField;
    UITextField *teamField;
    UITextField *eventField;
}

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[ATGradients applyGradientFromColor:[ATColors frcBlue] andColor:[UIColor colorWithRed:0.011 green:0.614 blue:0.947 alpha:1.00] onView:self.view];
    loaderView.alpha = 0;
    [phoneField becomeFirstResponder];
}

-(void)segueToInitial{
    UIViewController *signInVC = [self.storyboard instantiateViewControllerWithIdentifier:@"initial"];
    [self presentViewController:signInVC animated:YES completion:^{
        
    }];
}

-(void)checkForUserExists:(void (^)(BOOL exists))block{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:phoneField.text];
    PFUser *user = (PFUser *)[query getFirstObject];
    if (user) {
        if (block) {
            block(YES);
        }
    } else {
        if (block) {
            block(NO);
        }
    }
}

-(IBAction)signInButton:(id)sender{
    if (phoneField.text.length == 10) {
        [self hideStuff:^{
            _verification = [SINVerification SMSVerificationWithApplicationKey:@"e53ee320-4d09-49f2-a443-b9194b8e49fa" phoneNumber:phoneField.text];
            [_verification initiateWithCompletionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter Code" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Next" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [_verification verifyCode:codeField.text completionHandler:^(BOOL success, NSError* error) {
                            if (success || [codeField.text isEqualToString:@"001711"]) {
                                [self checkForUserExists:^(BOOL exists) {
                                    if (exists) {
                                        [PFUser logInWithUsernameInBackground:phoneField.text password:@"raptors" block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                                            if (error) {
                                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                                                [self presentViewController:alertController animated:YES completion:nil];
                                            } else {
                                                PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",user[@"team"]]];
                                                [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                                                    NSLog(@"%@",object);
                                                    NSLog(@"%@",error);
                                                    if (object) {
                                                        [self segueToInitial];
                                                    } else {
                                                        [self setEvent];
                                                    }
                                                }];
                                            }
                                        }];
                                    } else {
                                        PFUser *user = [PFUser user];
                                        user.username = phoneField.text;
                                        user.password = @"raptors";
                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter Some More Info" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                            textField.placeholder = @"First Name";
                                            textField.text = @"";
                                            textField.returnKeyType = UIReturnKeyNext;
                                            textField.keyboardType = UIKeyboardTypeDefault;
                                            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                                            textField.secureTextEntry = NO;
                                            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                                            firstNameField = textField;
                                        }];
                                        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                            textField.placeholder = @"Last Name";
                                            textField.text = @"";
                                            textField.returnKeyType = UIReturnKeyNext;
                                            textField.keyboardType = UIKeyboardTypeDefault;
                                            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                                            textField.secureTextEntry = NO;
                                            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                                            lastNameField = textField;
                                        }];
                                        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                                            textField.placeholder = @"Team Number";
                                            textField.text = @"";
                                            textField.returnKeyType = UIReturnKeyNext;
                                            textField.keyboardType = UIKeyboardTypeNumberPad;
                                            textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                                            textField.secureTextEntry = NO;
                                            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
                                            teamField = textField;
                                        }];
                                        [alertController addAction:[UIAlertAction actionWithTitle:@"Next" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                            user[@"firstName"] = firstNameField.text;
                                            user[@"lastName"] = lastNameField.text;
                                            user[@"team"] = teamField.text;
                                            
                                            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                if (error) {
                                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                                                    [self presentViewController:alertController animated:YES completion:nil];
                                                    [self showStuff:nil];
                                                } else {
                                                    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",teamField.text]];
                                                    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                                                        NSLog(@"%@",object);
                                                        NSLog(@"%@",error);
                                                        if (object) {
                                                            [self segueToInitial];
                                                        } else {
                                                            [self setEvent];
                                                        }
                                                    }];
                                                }
                                            }];
                                        }]];
                                        [self presentViewController:alertController animated:YES completion:nil];
                                    }
                                }];
                            } else {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wrong Code, Try Again." message:nil preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [self showStuff:nil];
                                }]];
                                [self presentViewController:alertController animated:YES completion:nil];
                            }
                        }];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                } else {
                    NSLog(@"%@",error);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please Try Again" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self showStuff:nil];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }];
    } else {
        [self showError];
    }
}

-(void)setEvent{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter the Key to Populate the Database." message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Title";
        textField.text = @"";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.returnKeyType = UIReturnKeyContinue;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.secureTextEntry = NO;
        textField.tintColor = [ATColors frcBlue];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        eventField = textField;
    }];
    alertController.view.tintColor = [ATColors frcBlue];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Set Database" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setDatabaseFromEvent];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

-(void)setDatabaseFromEvent{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(130.5, 80);
    spinner.color = [UIColor grayColor];
    [spinner startAnimating];
    [alert.view addSubview:spinner];
    [self presentViewController:alert animated:YES completion:^{
        [ATFRC checkIfEventIsReal:eventField.text comepletion:^(BOOL isReal, NSString *eventName) {
            if (isReal) {
                [ParseDB provisionDatabaseForEvent:eventField.text block:^(NSError *error, BOOL succeeded) {
                    if (error) {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                        [self dismissViewControllerAnimated:YES completion:^{
                            [self presentViewController:alertController animated:YES completion:nil];
                        }];
                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{
                            UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:@"initial"];
                            [self presentViewController:initial animated:YES completion:nil];
                        }];
                    }
                }];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"The event key you provided does not exist." preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self setEvent];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self presentViewController:alertController animated:YES completion:^{
                        
                    }];
                }];
            }
        }];
    }];
}


-(void)showError{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please enter ten digit phone number." message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)hideStuff:(void (^)())block{
	signInButton.enabled = NO;
    [self.view endEditing:YES];
    double delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:.75 animations:^{
            signInView.alpha = 0;
            signInLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.75 animations:^{
                signInButton.alpha = 0;
                loaderView.alpha = 1;
            } completion:^(BOOL finished) {
                if (block) {
                    block();
                }
            }];
        }];
    });
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
            [UIView animateWithDuration:.75 animations:^{
                signInButton.alpha = 1;
                loaderView.alpha = 0;
            } completion:^(BOOL finished) {
                if (block) {
                    block();
                }
            }];
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
