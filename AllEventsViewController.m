//
//  AllEventsViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 3/31/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "AllEventsViewController.h"
#import "ATFRC.h"
#import "TableViewCell.h"
#import "EventViewController.h"

@interface AllEventsViewController (){
    BOOL isSameYear;
    IBOutlet UIBarButtonItem *todayButton;
}

@end

@implementation AllEventsViewController

@synthesize events;

-(IBAction)today:(id)sender{
    ATFRCEvent *closestObject;
    NSTimeInterval closestInterval = DBL_MAX;
    
    for (ATFRCEvent *myObject in events) {
        NSTimeInterval interval = ABS([myObject.startDate timeIntervalSinceDate:[NSDate date]]);
        if (interval < closestInterval) {
            closestInterval = interval;
            closestObject = myObject;
        }
    }
    
    NSInteger row = [events indexOfObject:closestObject];
    
    //NSLog(@"%@",closestObject.shortName);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(BOOL)date:(NSDate *)date andDate2AreInTheSameYear:(NSDate*)date2{
    NSString *string1;
    NSString *string2;
    
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        string1 = [formatter stringFromDate:date];
    }
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        string2 = [formatter stringFromDate:date2];
    }
    
    return [string1 isEqualToString:string2];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    newView.event = events[indexPath.row];
    [self.navigationController pushViewController:newView animated:YES];
}

- (void)viewDidLoad {
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = newBackButton;
    
    ATFRCEvent *last = [events lastObject];
    NSDate *date = last.startDate;
    NSDate *currentDate = [NSDate date];
    
    isSameYear = [self date:date andDate2AreInTheSameYear:currentDate];
    
    if (!isSameYear) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (isSameYear) {
        [self today:nil];
    }
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    ATFRCEvent *currentEvent = [ATFRCEvent new];
    currentEvent = events[indexPath.row];
    // Configure the cell
    cell.eventNameLabel.text = [NSString stringWithFormat:@"%@",currentEvent.name];
    cell.eventDateLabel.text = [NSString stringWithFormat:@"%@",currentEvent.startDateString];
    return cell;
}

@end
