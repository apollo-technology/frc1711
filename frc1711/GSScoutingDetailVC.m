//
//  GSScoutingDetailVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/8/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "GSScoutingDetailVC.h"
#import "ATFRC.h"
#import "TeamViewController.h"

@interface GSScoutingDetailVC (){
	UIBarButtonItem *updateButton;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *numberLabel;
    IBOutlet UITextField *textField;
    IBOutlet UITableViewCell *moreDataCell;
}

@end

@implementation GSScoutingDetailVC

@synthesize team;

- (IBAction)textField:(id)sender {
    [self.view endEditing:YES];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell == moreDataCell) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(130.5, 80);
        spinner.color = [UIColor grayColor];
        [spinner startAnimating];
        [alert.view addSubview:spinner];
        [self presentViewController:alert animated:YES completion:^{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [ATFRC teamForTeamNumber:[NSString stringWithFormat:@"%i", team.number] completion:^(ATFRCTeam *team2, BOOL succeeded) {
                if (succeeded) {
                    TeamViewController *teamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"teamDetail"];
                    teamVC.team = team2;
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.navigationController pushViewController:teamVC animated:YES];
                    }];
                } else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Data Not Founded" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self presentViewController:alert animated:YES completion:nil];
                    }];
                }
            }];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.navigationItem.title = [NSString stringWithFormat:@"%@ - %i",team.name,team.number];
	
	UIImage *uploadIcon = [IonIcons imageWithIcon:ioniosclouduploadoutline color:[ATColors raptorGreen]];
	updateButton = [[UIBarButtonItem alloc] initWithImage:uploadIcon style:UIBarButtonItemStyleDone target:self action:@selector(updateTeam)];
	self.navigationItem.rightBarButtonItem = updateButton;
    
    textField.text = team.foo;
    nameLabel.text = [NSString stringWithFormat:@"Name: %@", team.name];
    numberLabel.text = [NSString stringWithFormat:@"Number: %i", team.number];
}

-(void)updateTeam{
    
    team.foo = textField.text;
    [self.view endEditing:YES];
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Updating\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = CGPointMake(130.5, 80);
	spinner.color = [UIColor grayColor];
	[spinner startAnimating];
	[alert.view addSubview:spinner];
	[self presentViewController:alert animated:YES completion:^{
        [team pushUpdates:^(NSError *error, BOOL succeeded) {
            if (succeeded) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            } else {
                NSString *errorString;
                if (error) {
                    errorString = error.localizedDescription;
                }
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self presentViewController:alert animated:YES completion:nil];
                }];
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
