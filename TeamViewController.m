//
//  TeamViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 3/30/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "TeamViewController.h"
#import <SafariServices/SafariServices.h>
#import "AllEventsViewController.h"

@interface TeamViewController (){
    IBOutlet UILabel *teamNameLabel;
    IBOutlet UILabel *teamNumberLabel;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *mottoLabel;
    IBOutlet UILabel *sponsorsLabel;
    IBOutlet UILabel *teamIDLabel;
    IBOutlet UITableViewCell *websiteCell;
    IBOutlet UITableViewCell *eventsCell;
}

@end

@implementation TeamViewController

-(BOOL)teamHasNickname{
    if ([[NSString stringWithFormat:@"%@",_team.nickname] isEqualToString:@"<null>"]) {
        return NO;
    } else if ([[NSString stringWithFormat:@"%@",_team.nickname] isEqualToString:@" "]){
        return NO;
    } else if ([[NSString stringWithFormat:@"%@",_team.nickname] isEqualToString:@""]){
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)teamHasMotto{
    if ([[NSString stringWithFormat:@"%@",_team.motto] isEqualToString:@"<null>"]) {
        return NO;
    } else if ([[NSString stringWithFormat:@"%@",_team.motto] isEqualToString:@" "]){
        return NO;
    } else if ([[NSString stringWithFormat:@"%@",_team.motto] isEqualToString:@""]){
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)teamHasLocation{
    if ([[NSString stringWithFormat:@"%@",_team.location] isEqualToString:@"<null>"]) {
        return NO;
    } else if ([[NSString stringWithFormat:@"%@",_team.location] isEqualToString:@" "]){
        return NO;
    } else if ([[NSString stringWithFormat:@"%@",_team.location] isEqualToString:@""]){
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)teamHasWebsite{
    if ([[NSString stringWithFormat:@"%@",_team.websiteURL] isEqualToString:@"<null>"]) {
        return NO;
    } else if ([[NSString stringWithFormat:@"%@",_team.websiteURL] isEqualToString:@" "]){
        return NO;
    } else if ([[NSString stringWithFormat:@"%@",_team.websiteURL] isEqualToString:@""]){
        return NO;
    } else {
        return YES;
    }
}

- (void)viewDidLoad {
    if ([self teamHasNickname]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@",_team.nickname];
        teamNameLabel.text = [NSString stringWithFormat:@"%@",_team.nickname];
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"Team %@",_team.number];
        teamNameLabel.text = @"no nickname";
    }
    
    if ([self teamHasMotto]) {
        mottoLabel.text = [NSString stringWithFormat:@"%@",_team.motto];
    } else {
        mottoLabel.text = @"no motto";
    }
    teamNumberLabel.text = [NSString stringWithFormat:@"%@",_team.number];
    
    if ([self teamHasLocation]) {
        locationLabel.text = [NSString stringWithFormat:@"%@",_team.location];
    } else {
        locationLabel.text = @"location unknown";
    }
    teamIDLabel.text = [NSString stringWithFormat:@"%@",_team.key];
    
    if (![self teamHasWebsite]) {
        websiteCell.hidden = YES;
    }
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = newBackButton;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell == websiteCell) {
        SFSafariViewController *browser = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:_team.websiteURL]];
        browser.view.tintColor = [UIColor colorWithRed:0.400 green:0.694 blue:0.298 alpha:1.00];
        [self presentViewController:browser animated:YES completion:^{
            
        }];
    } else if (selectedCell == eventsCell){
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
            [ATFRC eventsForTeam:_team.number inYear:stringFromDate completion:^(NSArray *events, BOOL succeeded) {
                AllEventsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsTable"];
                newView.events = events;
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController pushViewController:newView animated:YES];
                }];
            }];
        }];
    }
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
