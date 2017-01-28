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
    NSArray *dataArray;
}

@property (nonatomic, strong) id previewingContext;

@end

@implementation ScoutingTableVC

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id)previewingContext viewControllerForLocation:(CGPoint)location{
    if ([self.presentedViewController isKindOfClass:[ScoutingMatchView class]]) {
        return nil;
    }
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cellPostion];
    ScoutingMatchView *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingMatchView"];
    newView.match = [dataArray objectAtIndex:[indexPath row]];
    return newView;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

-(void)showEventPicker{
    [self presentPickerWithData:[[ParseDB data] availableEventKeys] title:@"Select an Event" completion:^(NSString *value) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventKey == %@", value];
        dataArray = [[[ParseDB data] matches] filteredArrayUsingPredicate:predicate];
        PDBSMatch *match = [dataArray objectAtIndex:0];
        self.navigationItem.title = [NSString stringWithFormat:@"Scouting | %@",match.eventKey];
        [[NSUserDefaults standardUserDefaults] setObject:match.eventKey forKey:@"dbPreference"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
}

-(IBAction)selectDB:(id)sender{
    [self showEventPicker];
}

- (void)handleRefresh:(id)sender{
	// do your refresh here...
	[ParseDB getScouting:^(NSError *error, BOOL succeeded) {
		if (succeeded) {
            if ([[[ParseDB data] matches] count] > 1) {
                NSLog(@"3");
                PDBSMatch *match1 = [[[ParseDB data] matches] objectAtIndex:0];
                PDBSMatch *match2 = [[[ParseDB data] matches] objectAtIndex:1];
                if (match1.number == match2.number) {
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventKey == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]];
                        dataArray = [[[ParseDB data] matches] filteredArrayUsingPredicate:predicate];
                        PDBSMatch *match = [dataArray objectAtIndex:0];
                        self.navigationItem.title = [NSString stringWithFormat:@"Scouting | %@",match.eventKey];
                        [self.tableView reloadData];
                        [refreshControl endRefreshing];
                    } else {
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]) {
                            dataArray = [[ParseDB data] matches];
                            PDBSMatch *match = [dataArray objectAtIndex:0];
                            self.navigationItem.title = [NSString stringWithFormat:@"Scouting | %@",match.eventKey];
                            [self.tableView reloadData];
                            [refreshControl endRefreshing];
                        } else {
                            [self showEventPicker];
                        }
                    }
                } else {
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]) {
                        dataArray = [[ParseDB data] matches];
                        PDBSMatch *match = [dataArray objectAtIndex:0];
                        self.navigationItem.title = [NSString stringWithFormat:@"Scouting | %@",match.eventKey];
                        [self.tableView reloadData];
                        [refreshControl endRefreshing];
                    } else {
                        [self showEventPicker];
                    }
                }
            } else {
                NSLog(@"21");
                [refreshControl endRefreshing];
            }
		} else {
            NSLog(@"12e");
			NSString *errorDescription;
			if (error) {
				errorDescription = error.localizedDescription;
			}
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error Getting Data" message:errorDescription preferredStyle:UIAlertControllerStyleAlert];
            alertController.view.tintColor = [ATColors raptorGreen];
			[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:alertController animated:YES completion:nil];
		}
	}];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[[ParseDB data] matches] count] > 1) {
        NSLog(@"111");
        PDBSMatch *match1 = [[[ParseDB data] matches] objectAtIndex:0];
        PDBSMatch *match2 = [[[ParseDB data] matches] objectAtIndex:1];
        if (match1.number == match2.number) {
            NSLog(@"19");
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventKey == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]];
                dataArray = [[[ParseDB data] matches] filteredArrayUsingPredicate:predicate];
                PDBSMatch *match = [dataArray objectAtIndex:0];
                self.navigationItem.title = [NSString stringWithFormat:@"Scouting | %@",match.eventKey];
                [self.tableView reloadData];
                [refreshControl endRefreshing];
            } else {
                [self showEventPicker];
            }
        } else {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]) {
                dataArray = [[ParseDB data] matches];
                PDBSMatch *match = [dataArray objectAtIndex:0];
                self.navigationItem.title = [NSString stringWithFormat:@"Scouting | %@",match.eventKey];
                [self.tableView reloadData];
                [refreshControl endRefreshing];
            } else {
                [self showEventPicker];
            }
        }
    } else {
        NSLog(@"'");
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
	
	
	refreshControl = [[UIRefreshControl alloc] init];
	//refreshControl.tintColor = [ATColors raptorGreen];
	[refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
	
	resetButton.image = [IonIcons imageWithIcon:ioniosalbumsoutline color:[ATColors frcBlue]];
	
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
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoutingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
	PDBSMatch *match = [dataArray objectAtIndex:[indexPath row]];
	cell.numberLabel.text = [NSString stringWithFormat:@"Match: %i",match.number];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ScoutingMatchView *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingMatchView"];
	newView.match = [dataArray objectAtIndex:[indexPath row]];
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
