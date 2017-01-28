//
//  DatabaseViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 3/30/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "DatabaseViewController.h"
#import "ATFRC.h"
#import "TeamViewController.h"
#import "AllTeamsViewController.h"
#import "EventViewController.h"
#import "AllEventsViewController.h"
#import "RankingsTableViewController.h"
#import "ATColors.h"
#import <Parse/Parse.h>

@interface DatabaseViewController (){
    IBOutlet UITableViewCell *allEventsCell;
    IBOutlet UITableViewCell *allTeamsCell;
    IBOutlet UITableViewCell *searchTeamCell;
    IBOutlet UITableViewCell *searchEventCell;
    IBOutlet UITableViewCell *rankingsCell;
    IBOutlet UITableViewCell *raptorsTeamCell;
    IBOutlet UITableViewCell *raptorsEventsCell;
    IBOutlet UITableViewCell *raprotrsRankingCell;
    UITextField *searchField;
    UIPickerView *contentPicker;
    NSArray *pickerDisplayData;
    NSArray *pickerActualData;
    NSString *pickerSelection;
}

@end

@implementation DatabaseViewController

- (void)viewDidLoad {
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = newBackButton;
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} 

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerDisplayData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerSelection = pickerActualData[row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerDisplayData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell == allEventsCell) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(130.5, 80);
        spinner.color = [UIColor grayColor];
        [spinner startAnimating];
        [alert.view addSubview:spinner];
        [self presentViewController:alert animated:YES completion:^{
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy"];
            [ATFRC eventsForYear:[dateFormatter stringFromDate:[NSDate date]] completion:^(NSArray *events, BOOL succeeded) {
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDateString" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedArray = [events sortedArrayUsingDescriptors:sortDescriptors];
                AllEventsViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsTable"];
                newViewController.events = sortedArray;
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController pushViewController:newViewController animated:YES];
                }];
            }];
        }];
        
    } else if (selectedCell == searchTeamCell){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Search for a Team" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Team Number";
            textField.text = @"";
            textField.returnKeyType = UIReturnKeyNext;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            textField.secureTextEntry = NO;
            textField.autocorrectionType = UITextAutocorrectionTypeDefault;
            searchField = textField;
        }];
        alertController.view.tintColor = [ATColors frcBlue];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Searching\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            spinner.center = CGPointMake(130.5, 80);
            spinner.color = [UIColor grayColor];
            [spinner startAnimating];
            [alert.view addSubview:spinner];
            [self presentViewController:alert animated:YES completion:^{
                [ATFRC checkIfTeamIsReal:searchField.text completion:^(BOOL isReal) {
                    if (isReal) {
                        [ATFRC teamForTeamNumber:searchField.text completion:^(ATFRCTeam *team, BOOL succeeded) {
                            [self dismissViewControllerAnimated:YES completion:^{
                                 TeamViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"teamDetail"];
                                newViewController.team = team;
                                [self.navigationController pushViewController:newViewController animated:YES];
                            }];
                        }];
                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Team does not exist." message:@"Please try a different number." preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                            }]];
                            alertController.view.tintColor = [ATColors frcBlue];
                            [self presentViewController:alertController animated:YES completion:^{
                                alertController.view.tintColor = [ATColors frcBlue];
                            }];
                        }];
                    }
                }];
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            alertController.view.tintColor = [ATColors frcBlue];
        }];
        
    } else if (selectedCell == rankingsCell){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View Rankings" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Event Key";
            textField.text = @"";
            textField.returnKeyType = UIReturnKeyNext;
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.secureTextEntry = NO;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            searchField = textField;
        }];
        alertController.view.tintColor = [ATColors frcBlue];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            spinner.center = CGPointMake(130.5, 80);
            spinner.color = [UIColor grayColor];
            [spinner startAnimating];
            [alert.view addSubview:spinner];
            [self presentViewController:alert animated:YES completion:^{
                [ATFRC checkIfEventIsReal:searchField.text comepletion:^(BOOL isReal,NSString *eventName) {
                    if (isReal) {
                        [ATFRC rankingsForEvent:searchField.text completion:^(NSArray *rankings, BOOL succeeded) {
                            RankingsTableViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rankingDetail"];
                            if (rankings.count > 1) {
                                newViewController.rankings = [[NSMutableArray alloc] initWithArray:rankings];
                                [newViewController.rankings removeObjectAtIndex:0];
                            } else {
                                newViewController.rankings = [NSMutableArray new];
                            }
                            [ATFRC eventForKey:searchField.text completion:^(ATFRCEvent *event, BOOL succeeded) {
                                newViewController.event = event;
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [self.navigationController pushViewController:newViewController animated:YES];
                                }];
                            }];
                        }];
                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Event does not exist." message:@"Please try a different key." preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                            }]];
                            alertController.view.tintColor = [ATColors frcBlue];
                            [self presentViewController:alertController animated:YES completion:^{
                                alertController.view.tintColor = [ATColors frcBlue];
                            }];
                        }];
                    }
                }];
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            alertController.view.tintColor = [ATColors frcBlue];
        }];
    } else if (selectedCell == searchEventCell){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Search for an Event" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Event Key";
            textField.text = @"";
            textField.returnKeyType = UIReturnKeyNext;
            textField.keyboardType = UIKeyboardTypeASCIICapable;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.secureTextEntry = NO;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            searchField = textField;
        }];
        alertController.view.tintColor = [ATColors frcBlue];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Searching\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            spinner.center = CGPointMake(130.5, 80);
            spinner.color = [UIColor grayColor];
            [spinner startAnimating];
            [alert.view addSubview:spinner];
            alertController.view.tintColor = [ATColors frcBlue];
            [self presentViewController:alert animated:YES completion:^{
                alertController.view.tintColor = [ATColors frcBlue];
                [ATFRC checkIfEventIsReal:searchField.text comepletion:^(BOOL isReal,NSString *eventName) {
                    if (isReal) {
                        [ATFRC eventForKey:searchField.text completion:^(ATFRCEvent *event, BOOL succeeded) {
                            [self dismissViewControllerAnimated:YES completion:^{
                                EventViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
                                newViewController.event = event;
                                [self.navigationController pushViewController:newViewController animated:YES];
                            }];
                        }];
                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Event does not exist." message:@"Please try a different key." preferredStyle:UIAlertControllerStyleAlert];
                            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                
                            }]];
                            alertController.view.tintColor = [ATColors frcBlue];
                            [self presentViewController:alertController animated:YES completion:^{
                                alertController.view.tintColor = [ATColors frcBlue];
                            }];
                        }];
                    }
                }];
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            alertController.view.tintColor = [ATColors frcBlue];
        }];
    } else if (selectedCell == raptorsTeamCell){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(130.5, 80);
        spinner.color = [UIColor grayColor];
        [spinner startAnimating];
        [alert.view addSubview:spinner];
        [self presentViewController:alert animated:YES completion:^{
            [ATFRC teamForTeamNumber:@"1711" completion:^(ATFRCTeam *team, BOOL succeeded) {
                TeamViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"teamDetail"];
                newViewController.team = team;
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController pushViewController:newViewController animated:YES];
                }];
            }];
        }];
    } else if (selectedCell == raptorsEventsCell){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(130.5, 80);
        spinner.color = [UIColor grayColor];
        [spinner startAnimating];
        [alert.view addSubview:spinner];
        [self presentViewController:alert animated:YES completion:^{
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
            NSString *stringFromDate = [formatter stringFromDate:date];
            [ATFRC eventsForTeam:@"1711" inYear:stringFromDate completion:^(NSArray *events, BOOL succeeded) {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDateString" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedArray = [events sortedArrayUsingDescriptors:sortDescriptors];
                AllEventsViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsTable"];
                newViewController.events = sortedArray;
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController pushViewController:newViewController animated:YES];
                }];
            }];
        }];
    } else if (selectedCell == raprotrsRankingCell){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(130.5, 80);
        spinner.color = [UIColor grayColor];
        [spinner startAnimating];
        [alert.view addSubview:spinner];
        [self presentViewController:alert animated:YES completion:^{
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
            NSString *stringFromDate = [formatter stringFromDate:date];
            [ATFRC eventsForTeam:@"1711" inYear:stringFromDate completion:^(NSArray *events, BOOL succeeded) {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDateString" ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedArray = [events sortedArrayUsingDescriptors:sortDescriptors];
                ATFRCEvent *event = [sortedArray lastObject];
                [ATFRC rankingsForEvent:event.key completion:^(NSArray *rankings, BOOL succeeded) {
                    RankingsTableViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rankingDetail"];
                    if (rankings.count > 1) {
                        newViewController.rankings = [[NSMutableArray alloc] initWithArray:rankings];
                        [newViewController.rankings removeObjectAtIndex:0];
                    } else {
                        newViewController.rankings = [NSMutableArray new];
                    }
                    newViewController.event = event;
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.navigationController pushViewController:newViewController animated:YES];
                    }];
                }];
            }];
        }];
    }
}

@end
