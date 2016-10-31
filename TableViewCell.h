//
//  TableViewCell.h
//  Raptors1711
//
//  Created by Elijah Cobb on 3/30/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end
