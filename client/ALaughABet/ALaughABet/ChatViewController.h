//
//  ChatViewController.h
//  ALaughABet
//
//  Created by Lar Judge on 29/05/2014.
//  Copyright (c) 2014 Lar Judge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView   *scrollView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) IBOutlet UITextField *textField;



- (IBAction) sendButtonPressed:(id)sender;

@end
