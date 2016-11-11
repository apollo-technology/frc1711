//
//  GSScoutingDetailVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/8/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "GSScoutingDetailVC.h"

@interface GSScoutingDetailVC (){
	UIBarButtonItem *updateButton;
}

@end

@implementation GSScoutingDetailVC

@synthesize team;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.navigationItem.title = [NSString stringWithFormat:@"%@ - %i",team.name,team.number];
	
	UIImage *uploadIcon = [IonIcons imageWithIcon:ioniosclouduploadoutline color:[ATColors raptorGreen]];
	updateButton = [[UIBarButtonItem alloc] initWithImage:uploadIcon style:UIBarButtonItemStyleDone target:self action:@selector(updateTeam)];
	self.navigationItem.rightBarButtonItem = updateButton;
}

-(void)updateTeam{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Updating\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.center = CGPointMake(130.5, 80);
	spinner.color = [UIColor grayColor];
	[spinner startAnimating];
	[alert.view addSubview:spinner];
	[self presentViewController:alert animated:YES completion:^{
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
