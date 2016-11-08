//
//  GSScoutingCell.h
//  frc1711
//
//  Created by Elijah Cobb on 11/8/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSScoutingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *progressView;

@end
