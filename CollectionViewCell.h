//
//  CollectionViewCell.h
//  Diver's Log
//
//  Created by Elijah Cobb on 3/26/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *teamNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamNameLabel;

@end
