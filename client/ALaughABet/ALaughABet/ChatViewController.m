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
    
    self.title = @"something";
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _textField.delegate = self;
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
    NSLog(@"You've just sent a post request on login");
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

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text = @"Chat Message";
    
    return cell;
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    //Add the Done button to the screen
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(hideKeyboard)];
    
    NSDictionary *info = [aNotification userInfo];
    _keyboardRectValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [_keyboardRectValue CGRectValue].size;
    
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.contentInset=UIEdgeInsetsMake(keyboardSize.height,0.0,keyboardSize.height,0.0);
    
    
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.view.frame;
    frame.origin.y -= (keyboardSize.height-150);
    frame.size.height += keyboardSize.height-150;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.scrollView.frame = frame;
    [UIView commitAnimations];

}

//Animate the view downwards when the keyboard disappears
- (void)keyboardWasHidden:(NSNotification *)aNotification
{

    NSDictionary *info = [aNotification userInfo];
    _keyboardRectValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [_keyboardRectValue CGRectValue].size;
    
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.contentInset=UIEdgeInsetsMake(keyboardSize.height,0.0,keyboardSize.height,0.0);
    
    
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.view.frame;
    frame.origin.y += (keyboardSize.height-150);
    frame.size.height -= keyboardSize.height-150;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.scrollView.frame = frame;
    [UIView commitAnimations];

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
}

@end
