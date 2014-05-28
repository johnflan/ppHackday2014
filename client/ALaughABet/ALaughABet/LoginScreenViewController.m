//
//  LoginScreenViewController.m
//  ALaughABet
//
//  Created by Lar Judge on 29/05/2014.
//  Copyright (c) 2014 Lar Judge. All rights reserved.
//

#import "LoginScreenViewController.h"
#import <RestKit/RestKit.h>

@interface LoginScreenViewController ()

@end

@implementation LoginScreenViewController

@synthesize nameField = _nameField;
@synthesize passwordField = _passwordField;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButtonPressed:(id)sender
{
    [self postRequest];
    
    
    if(true) {
         [self performSegueWithIdentifier:@"loginSegue" sender:nil]; 
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     NSLog(@"Preparing for segue");
    if ([[segue identifier] isEqualToString:@"loginSegue"]){

    }
}

- (void)postRequest
{
    NSLog(@"You've just sent a post request on login");
    NSURL *url = [NSURL URLWithString:@"http://10.104.98.186:5000"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _nameField.text, @"username",
                            _passwordField.text, @"password",
                            nil];
    
    [httpClient postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

@end
