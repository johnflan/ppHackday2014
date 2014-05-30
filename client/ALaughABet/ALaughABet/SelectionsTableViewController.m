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

@synthesize selections2 = _selections2;
@synthesize prices2 = _prices2;

@synthesize selections3 = _selections3;
@synthesize prices3 = _prices3;

@synthesize selections4 = _selections4;
@synthesize prices4 = _prices4;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"diamonds.png"]];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Selections";
    
    _selections = [NSArray arrayWithObjects:@"Brazil", @"Draw", @"Croatia", nil];
    _prices = [NSArray arrayWithObjects:@"3/10", @"4/1", @"10/1", nil];
    
    _selections2 = [NSArray arrayWithObjects:@"Mexico", @"Draw", @"Cameroon", nil];
    _prices2 = [NSArray arrayWithObjects:@"11/10", @"9/4", @"13/5", nil];
    
    _selections3 = [NSArray arrayWithObjects:@"Spain", @"Draw", @"Holland", nil];
    _prices3 = [NSArray arrayWithObjects:@"10/11", @"23/10", @"10/3 ", nil];
    
    _selections4 = [NSArray arrayWithObjects:@"Chile", @"Draw", @"Australia", nil];
    _prices4 = [NSArray arrayWithObjects:@"1/2", @"3/1", @"13/2", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
    
    switch (indexPath.section) {
            
            
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@\t%@",[_selections objectAtIndex:indexPath.row], [_prices objectAtIndex:indexPath.row]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@\t%@",[_selections2 objectAtIndex:indexPath.row], [_prices2 objectAtIndex:indexPath.row]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@\t%@",[_selections3 objectAtIndex:indexPath.row], [_prices3 objectAtIndex:indexPath.row]];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"%@\t%@",[_selections4 objectAtIndex:indexPath.row], [_prices4 objectAtIndex:indexPath.row]];
            break;
            
            
            
    }
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
    
    switch (indexPath.section) {
        case 0:
            _currentSelectionName = [_selections objectAtIndex:indexPath.row];
            _currentSelectionPrice = [_prices objectAtIndex:indexPath.row];
            break;
        case 1:
            _currentSelectionName = [_selections2 objectAtIndex:indexPath.row];
            _currentSelectionPrice = [_prices2 objectAtIndex:indexPath.row];
            break;
        case 2:
            _currentSelectionName = [_selections3 objectAtIndex:indexPath.row];
            _currentSelectionPrice = [_prices3 objectAtIndex:indexPath.row];
            break;
        case 3:
            _currentSelectionName = [_selections4 objectAtIndex:indexPath.row];
            _currentSelectionPrice = [_prices4 objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Confirm Bet %@ @ %@", _currentSelectionName, _currentSelectionPrice]
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Brazil vs Croatia 12th June 21:00", @"mySectionName");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Mexico vs Cameroon 13th June 17:00", @"sec2");
            break;
        case 2:
            sectionName = NSLocalizedString(@"Spain vs Holland 13th June 20:00", @"sec3");
            break;
        case 3:
            sectionName = NSLocalizedString(@"Chile vs Australia 13th June 23:00", @"sec4");
            break;
            
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Set the background color of our header/footer.
//    header.contentView.backgroundColor = [UIColor blackColor];
    
    // You can also do this to set the background color of our header/footer,
    //    but the gradients/other effects will be retained.
    // view.tintColor = [UIColor blackColor];
}

@end
