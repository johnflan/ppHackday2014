//
//  ChatViewController.m
//  ALaughABet
//
//  Created by Lar Judge on 29/05/2014.
//  Copyright (c) 2014 Lar Judge. All rights reserved.
//

#import "ChatViewController.h"
#import <RestKit/RestKit.h>
@interface ChatViewController ()
@property(nonatomic, strong)NSValue     *keyboardRectValue;
@end

@implementation ChatViewController

@synthesize textField = _textField;
@synthesize tableView = _tableView;
@synthesize sendButton = _sendButton;
@synthesize keyboardRectValue = _keyboardRectValue;

@synthesize chatMessages = _chatMessages;

@synthesize latestTimetamp = _latestTimetamp;

@synthesize userName = _userName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
       self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stripes.png"]];
    
    
    NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *message = [fetchDefaults objectForKey:@"username"];
    
//    NSLog(@"title message %@",message);
    self.title = @"Inside Job";
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _textField.delegate = self;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(downloadMessageHistory)];
    
    [self downloadMessageHistory];
    
    [self.tableView reloadData];
}

- (void)downloadMessageHistory
{
    
     _chatMessages = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://10.104.98.186:5000/chat/1?username=johnflan&key=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             
             NSLog(@"initial download %@", greeting);
             
             NSArray *userNameArray = [greeting valueForKey:@"userName"];
             NSArray *messageArray = [greeting valueForKey:@"message"];
             NSArray *timestampArray = [greeting valueForKey:@"timestamp"];
             NSArray *infoArray = [greeting valueForKey:@"info"];
             
             NSLog(@"info value%@",[greeting valueForKey:@"info"]);
             
             
             
             
             for (int i = 0; i < [userNameArray count]; i++) {
                 ChatMessage *message = [[ChatMessage alloc] init];
                 message.username = [userNameArray objectAtIndex:i];
                 message.message = [messageArray objectAtIndex:i];
                 message.timestamp = [timestampArray objectAtIndex:i];
                 message.info = [infoArray objectAtIndex:i];
                 
                 NSLog(@"Messages %@ %@ %@", message.username, message.message, message.timestamp);
                 [_chatMessages addObject:message];
             }
             
             ChatMessage *latestMessage = [_chatMessages lastObject];
             _latestTimetamp = latestMessage.timestamp;
             
             
             [self.tableView reloadData];
             if (self.chatMessages.count > 0)
                 [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
         }
     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    
    [self.tableView reloadData];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)sendButtonPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://10.104.98.186:5000"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"johnflan", @"username",
                            @"1234", @"password",
                            _textField.text, @"message",
                            nil];
    
    [httpClient postPath:@"/chat/1?username=johnflan" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
    

    
//ChatMessage *message = [[ChatMessage alloc] init];
//    message.message = _textField.text;
    _textField.text = @"";
//    [_chatMessages addObject:message];
    
    
    [self downloadMessageHistory];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"Count count count %d", [_chatMessages count] )    ;
    return [_chatMessages count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ChatMessage *message = [_chatMessages objectAtIndex:indexPath.row];
    cell.textLabel.text = message.username;
        cell.detailTextLabel.text = message.message;
    
    if ([message.info isEqual:@"true"]) {
        cell.textColor = [UIColor purpleColor];
        cell.detailTextLabel.textColor = [UIColor purpleColor];
    }
    
    else {
        cell.textColor = [UIColor blueColor];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
    
    return cell;
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    //Add the Done button to the screen
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(hideKeyboard)];
    
//    NSDictionary *info = [aNotification userInfo];
//    _keyboardRectValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [_keyboardRectValue CGRectValue].size;
//    
//    
//    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//    _scrollView.contentInset=UIEdgeInsetsMake(keyboardSize.height,0.0,keyboardSize.height,0.0);
//    
//    
//    NSTimeInterval animationDuration = 0.300000011920929;
//    CGRect frame = self.view.frame;
//    frame.origin.y -= (keyboardSize.height-150);
//    frame.size.height += keyboardSize.height-150;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.scrollView.frame = frame;
//    [UIView commitAnimations];
    
}

//Animate the view downwards when the keyboard disappears
- (void)keyboardWasHidden:(NSNotification *)aNotification
{
    
//    NSDictionary *info = [aNotification userInfo];
//    _keyboardRectValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [_keyboardRectValue CGRectValue].size;
//    
//    
//    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//    _scrollView.contentInset=UIEdgeInsetsMake(keyboardSize.height,0.0,keyboardSize.height,0.0);
//    
//    
//    NSTimeInterval animationDuration = 0.300000011920929;
//    CGRect frame = self.view.frame;
//    frame.origin.y += (keyboardSize.height-150);
//    frame.size.height -= keyboardSize.height-150;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.scrollView.frame = frame;
//    [UIView commitAnimations];
    
}

- (void)hideKeyboard
{
    [_textField resignFirstResponder];
    //Animate the "Done" button off the screen and then make it nothing
    [UIView animateWithDuration:1.5
                     animations:^{
                         self.navigationItem.rightBarButtonItem.customView.alpha = 0;
                     }];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.tableView reloadData];
    if (self.chatMessages.count > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //Remove the Observers when the view is removed from screen
    //These are here rather than viewWillDisappear so if the user clicks Description while the keyboard is
    //showing, the view won't be all messed up scroll wise.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


@end
