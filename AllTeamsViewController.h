//
//  AllTeamsViewController.h
//  Raptors1711
//
//  Created by Elijah Cobb on 3/30/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllTeamsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>{
    NSArray *teams;
}

@property NSArray *teams;

@end
