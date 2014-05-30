//
//  SelectionsTableViewController.m
//  ALaughABet
//
//  Created by Lar Judge on 28/05/2014.
//  Copyright (c) 2014 Lar Judge. All rights reserved.
//

#import "SelectionsTableViewController.h"
#import <RestKit/RestKit.h>

@interface SelectionsTableViewController ()

@end

@implementation SelectionsTableViewController


@synthesize currentSelectionName = _currentSelectionName;
@synthesize currentSelectionPrice = _currentSelectionPrice;
@synthesize selections = _selections;
@synthesize prices = _prices;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Selections";
    
    _selections = [NSArray arrayWithObjects:@"Brazil", @"Draw", @"Croatia", nil];
    _prices = [NSArray arrayWithObjects:@"3/10", @"4/1", @"10/1", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_selections count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }

    cell.textLabel.text = [_selections objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
    
    _currentSelectionName = [_selections objectAtIndex:indexPath.row];
    _currentSelectionPrice = [_prices objectAtIndex:indexPath.row];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Confirm Order?"
															 delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
													otherButtonTitles:@"Yes", @"No", nil];
    
	actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Placed Bet on %@", _currentSelectionName);
        
        
        
        NSURL *url = [NSURL URLWithString:@"http://10.104.98.186:5000"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"johnflan", @"username",
                                @"1234", @"password",
                                [NSString stringWithFormat:@"%@ @ %@", _currentSelectionName, _currentSelectionPrice], @"message",
                                nil];
        
        [httpClient postPath:@"/bet/1?username=johnflan" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Request Successful, response '%@'", responseStr);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        }];
        
        
    }
    
}

@end
