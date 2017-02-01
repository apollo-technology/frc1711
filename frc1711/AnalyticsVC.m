//
//  AnalyticsVC.m
//  frc1711
//
//  Created by Elijah Cobb on 2/1/17.
//  Copyright © 2017 Apollo Technology. All rights reserved.
//

#import "AnalyticsVC.h"
#import "ParseDB.h"
#import "ATColors.h"
#import "IonIcons.h"
#import "TeamViewController.h"
#import "AnalyticsCell.h"
#import "ATFRC.h"
#import "AnalyticObject.h"

@interface AnalyticsVC (){
    IBOutlet UIBarButtonItem *analyticsButton;
    NSArray *allTeams;
    NSArray *arryToShow;
    
    UIPickerView *picker;
    NSInteger pickedRow;
    NSArray *pickerData;
    NSString *property;
}

@end

@implementation AnalyticsVC

-(IBAction)categoryPickerAction:(id)sender{
    NSArray *attributes = @[@"General",
                            @"TeleOp Final Score",
                            @"Auton Final Score",
                            @"TeleOp High Goal",
                            @"TeleOp Low Goal",
                            @"Auton High Goal",
                            @"Auton Low Goal"];
    [self presentPickerWithData:attributes title:@"Select an Attribute" completion:^(NSString *value) {
        property = value;
        [self provisionTableForAttribute:value];
    }];
}


//elf.autonFinalScore = [team[@"autonFinalScore"] intValue];
//self.teleopFinalScore = [team[@"teleopFinalScore"] intValue];
//self.highGoalCountTeleop = [team[@"highGoalCountTeleop"] intValue];
//self.lowGoalCountTeleOp = [team[@"lowGoalCountTeleOp"] intValue];
//self.highGoalCountAuton = [team[@"highGoalCountAuton"] intValue];
//self.lowGoalCountAuton = [team[@"lowGoalCountAuton"] intValue];
//self.didScale = [team[@"didScale"] boolValue];
//self.didScaleNumber = [team[@"didScaleNumber"] boolValue];
//self.finalScore = finalScore;


-(void)provisionTableForAttribute:(NSString *)attribute{
    NSArray *keys = @[@"General",
                      @"TeleOp Final Score",
                      @"Auton Low Goal",
                      @"TeleOp High Goal",
                      @"TeleOp Low Goal",
                      @"Auton High Goal",
                      @"Auton Final Score"];
    NSArray *actualKeys = @[@"finalScore",
                            @"teleopFinalScore",
                            @"lowGoalCountAuton",
                            @"highGoalCountTeleop",
                            @"lowGoalCountTeleOp",
                            @"highGoalCountAuton",
                            @"lowGoalCountAuton"];
    NSDictionary *keyConvertDictionary = [NSDictionary dictionaryWithObjects:actualKeys forKeys:keys];
    arryToShow = [allTeams sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:[keyConvertDictionary objectForKey:attribute] ascending:YES]]];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *dBPreference = [[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"];
    NSString *userTeam = [[PFUser currentUser] objectForKey:@"team"];
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"s%@",userTeam]];
    [query whereKey:@"eventKey" equalTo:dBPreference];
    [query addAscendingOrder:@"number"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableDictionary *dataDictionary = [NSMutableDictionary new];
        for (PFObject *object in objects) {
            //runs for every match in db for key
            NSArray *teamsForMatch = @[object[@"redTeam1"],
                                       object[@"redTeam2"],
                                       object[@"redTeam3"],
                                       object[@"blueTeam1"],
                                       object[@"blueTeam2"],
                                       object[@"blueTeam3"]];
            for (NSDictionary *teamSeverObject in teamsForMatch) {
                int finalScore = [self scoreForTeam:teamSeverObject];
                AnalyticObject *analyticObject = [[AnalyticObject alloc] initWithTeam:teamSeverObject withFinalScore:finalScore];
                //runs for every team
                if ([dataDictionary objectForKey:@(analyticObject.team)]) {
                    //has team already, check for update
                    AnalyticObject *currentHighObject = [dataDictionary objectForKey:@(analyticObject.team)];
                    if (currentHighObject.finalScore < analyticObject.finalScore) {
                        //need to update
                        [dataDictionary setObject:analyticObject forKey:@(analyticObject.team)];
                    }
                } else {
                    //no team
                    [dataDictionary setObject:analyticObject forKey:@(analyticObject.team)];
                }
            }
        }
        NSMutableArray *finalConvert = [NSMutableArray new];
        for (NSString *key in [dataDictionary allKeys]) {
            AnalyticObject *object = [dataDictionary objectForKey:key];
            [finalConvert addObject:object];
        }
        allTeams = finalConvert;
        
        [self provisionTableForAttribute:@"General"];
        property = @"General";
    }];
    
    analyticsButton.image = [IonIcons imageWithIcon:ionfunnel color:[ATColors frcBlue]];
    
}

-(int)scoreForTeam:(NSDictionary *)team{
    
    int autonFinalScore = [team[@"finalScoreAuton"] intValue];
    int teleopFinalScore = [team[@"finalScoreTeleOp"] intValue];
    int highGoalCountTeleop = [team[@"highGoalCountTeleOp"] intValue];
    int lowGoalCountTeleOp = [team[@"lowGoalCountTeleOp"] intValue];
    int highGoalCountAuton = [team[@"highGoalCountAuton"] intValue];
    int lowGoalCountAuton = [team[@"lowGoalCountAuton"] intValue];
    BOOL didScale = [team[@"didScale"] boolValue];
    int didScaleNumber = 0;
    if (didScale) {
        didScaleNumber = 30;
    }
    
    int finalScore = (autonFinalScore * 2) + (teleopFinalScore * 1) + (highGoalCountTeleop * 1) + (lowGoalCountTeleOp * 1) + (highGoalCountAuton * 1) + (lowGoalCountAuton * 1) + (didScaleNumber * 1);

    return finalScore;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arryToShow.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnalyticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell..
    AnalyticObject *object = [arryToShow objectAtIndex:indexPath.row];
    cell.teamLabel.text = [NSString stringWithFormat:@"Team: %i",object.team];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnalyticObject *object = [arryToShow objectAtIndex:indexPath.row];
    [ATFRC teamForTeamNumber:[NSString stringWithFormat:@"%i",object.team] completion:^(ATFRCTeam *team, BOOL succeeded) {
        if (succeeded) {
            TeamViewController *detailViewC = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingDetail"];
            detailViewC.team = team;
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"We could not show you the team page." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
    }];
}

-(void)presentPickerWithData:(NSArray *)array title:(NSString *)title completion:(void (^)(NSString *value))completionHandler{
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n",title] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 50, 230, 140)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerData = array;
    pickedRow = 0;
    alertController.view.tintColor = [ATColors frcBlue];
    [alertController.view addSubview:pickerView];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(array[pickedRow]);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return pickerData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    pickedRow = row;
}

@end
