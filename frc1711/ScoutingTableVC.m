//
//  ScoutingTableVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/9/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ScoutingTableVC.h"
#import "IonIcons.h"
#import "ATColors.h"
#import "ScoutingCell.h"
#import "ParseDB.h"
#import "ATFRC.h"
#import "ScoutingMatchView.h"

@interface ScoutingTableVC (){
	IBOutlet UIBarButtonItem *resetButton;
	UITextField *keyField;
	UIRefreshControl *refreshControl;
    
    UIPickerView *picker;
    NSInteger pickedRow;
    NSArray *pickerData;
}

@end

@implementation ScoutingTableVC

-(void)showEventPicker{
    [self presentPickerWithData:[[ParseDB data] availableEventKeys] title:@"Select an Event" completion:^(NSString *value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"sTeamKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

- (void)handleRefresh:(id)sender{
	// do your refresh here...
	[ParseDB getScouting:^(NSError *error, BOOL succeeded) {
		if (succeeded) {
			[self.tableView reloadData];
			[refreshControl endRefreshing];
		} else {
			NSString *errorDescription;
			if (error) {
				errorDescription = error.localizedDescription;
			}
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error Getting Data" message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:alertController animated:YES completion:nil];
		}
	}];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	refreshControl = [[UIRefreshControl alloc] init];
	refreshControl.tintColor = [ATColors raptorGreen];
	[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sTeamKey"]) {
        
    } else {
        [self showEventPicker];
    }
	
	resetButton.image = [IonIcons imageWithIcon:ioniostrashoutline color:[ATColors raptorGreen]];
	
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
    return [[[ParseDB data] matches] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoutingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
	PDBSMatch *match = [[[ParseDB data] matches] objectAtIndex:[indexPath row]];
	cell.numberLabel.text = [NSString stringWithFormat:@"Match: %i",match.number];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ScoutingMatchView *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingMatchView"];
	newView.match = [[[ParseDB data] matches] objectAtIndex:[indexPath row]];
	[self.navigationController pushViewController:newView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)presentPickerWithData:(NSArray *)array title:(NSString *)title completion:(void (^)(NSString *value))completionHandler{
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n",title] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 50, 230, 140)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerData = array;
    pickedRow = 0;
    [alertController.view addSubview:pickerView];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(array[pickedRow]);
    }]];
    [self presentViewController:alertController animated:YES completion:^{
    }];
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
