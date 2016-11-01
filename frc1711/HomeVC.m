//
//  HomeVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "HomeVC.h"
#import "AppConfigs.h"
#import <Parse/Parse.h>

@interface HomeVC (){
	IBOutlet UILabel *welcomeLabel;
	IBOutlet UILabel *messageLabel;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	welcomeLabel.text = [NSString stringWithFormat:[[AppConfigs configs] homeWelcome],[[PFUser currentUser] objectForKey:@"firstName"]];
	messageLabel.text = [[AppConfigs configs] homeMessage];
	
	
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
