//
//  GSScoutingTableVC.m
//  frc1711
//
//  Created by Elijah Cobb on 11/8/16. WHOA hi buddy!
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "GSScoutingTableVC.h"
#import "ParseDB.h"
#import "IonIcons.h"
#import "ATColors.h"
#import "GSScoutingCell.h"
#import "GSScoutingDetailVC.h"

@interface GSScoutingTableVC (){
	IBOutlet UIBarButtonItem *resetButton;
	IBOutlet UIBarButtonItem *exportButton;
    UIRefreshControl *refreshControl;
    UITextField *keyField;

    UIPickerView *pickerView;
    NSInteger pickedRow;
    NSArray *pickerData;
    NSArray *dataArray;
	
	
}

@property (nonatomic, strong) id previewingContext;

@end

@implementation GSScoutingTableVC

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id)previewingContext viewControllerForLocation:(CGPoint)location{
    if ([self.presentedViewController isKindOfClass:[GSScoutingDetailVC class]]) {
        return nil;
    }
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cellPostion];
    GSScoutingDetailVC *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    newView.team = [dataArray objectAtIndex:[indexPath row]];
    return newView;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (void)handleRefresh:(id)sender{
    // do your refresh here...
    [ParseDB getGroundScouting:^(NSError *error, BOOL succeeded) {
        if (succeeded) {
            if ([self hasDuplicates]) {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventKey == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]];
                    dataArray = [[[ParseDB data] teams] filteredArrayUsingPredicate:predicate];
                    PDBGSTeam *team = [dataArray objectAtIndex:0];
                    self.navigationItem.title = [NSString stringWithFormat:@"Ground Scouting | %@",team.eventKey];
                    [self.tableView reloadData];
                    [refreshControl endRefreshing];
                } else {
                    [self showEventPicker];
                    [refreshControl endRefreshing];
                }
                
            }
        } else {
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

-(BOOL)hasDuplicates{
    NSMutableArray *testArray = [NSMutableArray new];
    for (PDBGSTeam *team in [[ParseDB data] teams]) {
        if ([testArray containsObject:@(team.number)]) {
            return YES;
            break;
        } else {
            [testArray addObject:@(team.number)];
        }
    }
    return NO;
}

-(void)viewDidAppear:(BOOL)animated{
    if ([self hasDuplicates]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventKey == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"dbPreference"]];
            dataArray = [[[ParseDB data] teams] filteredArrayUsingPredicate:predicate];
            PDBGSTeam *team = [dataArray objectAtIndex:0];
            self.navigationItem.title = [NSString stringWithFormat:@"Ground Scouting | %@",team.eventKey];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        } else {
            [self showEventPicker];
        }
    } else {
        PDBGSTeam *team = [dataArray objectAtIndex:0];
        self.navigationItem.title = [NSString stringWithFormat:@"Ground Scouting | %@",team.eventKey];
    }
}

-(void)showEventPicker{
    [self presentPickerWithData:[[ParseDB data] availableEventKeys] title:@"Select an Event" completion:^(NSString *value) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventKey == %@", value];
        dataArray = [[[ParseDB data] teams] filteredArrayUsingPredicate:predicate];
        PDBGSTeam *teams = [dataArray objectAtIndex:0];
        self.navigationItem.title = [NSString stringWithFormat:@"Ground Scouting | %@",teams.eventKey];
        [[NSUserDefaults standardUserDefaults] setObject:teams.eventKey forKey:@"dbPreference"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
}

-(IBAction)selectDB:(id)sender{
    [self showEventPicker];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
	
//	[ParseDB getGroundScouting:^(NSError *error, BOOL succeeded) {
//		[self.tableView reloadData];
//	}];
	
	refreshControl = [[UIRefreshControl alloc] init];
	refreshControl.tintColor = [ATColors frcBlue];
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
    GSScoutingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
	PDBGSTeam *team = [dataArray objectAtIndex:indexPath.row];
	cell.teamNumberLabel.text = [NSString stringWithFormat:@"%i",team.number];
	cell.teamNameLabel.text = team.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	GSScoutingDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
	detailVC.team = [dataArray objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)presentPickerWithData:(NSArray *)array title:(NSString *)title completion:(void (^)(NSString *value))completionHandler{
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n",title] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 50, 230, 140)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
