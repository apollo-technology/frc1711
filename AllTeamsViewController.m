//
//  AllTeamsViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 3/30/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "AllTeamsViewController.h"
#import "CollectionViewCell.h"
#import "ATFRC.h"
#import "TeamViewController.h"

@interface AllTeamsViewController (){
    IBOutlet UICollectionView *theCollection;
}

@end

@implementation AllTeamsViewController

@synthesize teams;

- (void)viewDidLoad {
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = newBackButton;
    
    theCollection.dataSource = self;
    theCollection.delegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return teams.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    ATFRCTeam *currentTeam = [ATFRCTeam new];
    currentTeam = teams[indexPath.row];
    // Configure the cell
    cell.teamNameLabel.text = [NSString stringWithFormat:@"%@",currentTeam.nickname];
    cell.teamNumberLabel.text = [NSString stringWithFormat:@"%@",currentTeam.number];
    
    if ([cell.teamNameLabel.text isEqualToString:@" "]) {
        cell.teamNameLabel.text = [NSString stringWithFormat:@"Team %@",currentTeam.number];
    }
    
    if ([cell.teamNameLabel.text isEqualToString:@""]) {
        cell.teamNameLabel.text = [NSString stringWithFormat:@"Team %@",currentTeam.number];
    }
    
    if ([cell.teamNameLabel.text isEqualToString:@"<null>"]) {
        cell.teamNameLabel.text = [NSString stringWithFormat:@"Team %@",currentTeam.number];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ATFRCTeam *teamToPass = [ATFRCTeam new];
    teamToPass = teams[indexPath.row];
    TeamViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"teamDetail"];
    newView.team = teamToPass;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:newView animated:YES];
}



@end
