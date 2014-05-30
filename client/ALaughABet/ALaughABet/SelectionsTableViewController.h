//
//  SelectionsTableViewController.h
//  ALaughABet
//
//  Created by Lar Judge on 28/05/2014.
//  Copyright (c) 2014 Lar Judge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionsTableViewController : UITableViewController


@property NSString *currentSelectionName;
@property NSString *currentSelectionPrice;

@property NSArray *selections;
@property NSArray *prices;

@end
