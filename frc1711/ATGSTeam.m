//
//  ATGSTeam.m
//  frc1711
//
//  Created by Elijah Cobb on 10/31/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "ATGSTeam.h"
#import "ATGScouting.h"

@implementation ATGSTeam

-(void)pushUpdates:(void (^)(NSError *error, BOOL succeeded))block{
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"gS%@",[ATGScouting teamId]]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            if (block) {
                block(error,NO);
            }
        } else {
            object[@"foo"] = self.foo;
            /*
             set all of these properties like this
             */
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@",error);
                    if (block) {
                        block(error,NO);
                    }
                } else {
                    int index = (int)[[[ATGScouting data] teams] indexOfObject:self];
                    [[[ATGScouting data] teams] replaceObjectAtIndex:index withObject:self];
                    if (block) {
                        block(nil,YES);
                    }
                }
            }];
        }
    }];
}

@end
