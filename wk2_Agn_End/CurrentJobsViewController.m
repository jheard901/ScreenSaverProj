//
//  CurrentJobsViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "CurrentJobsViewController.h"
#import "Person.h"
#import "Job.h"
#import "JobsReadOnlyViewController.h"
#import "PrimeViewController.h"


@interface CurrentJobsViewController ()

@end

@implementation CurrentJobsViewController

@synthesize delegate;
@synthesize thePerson;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)jobPickerViewController:(JobPickerViewController *)controller didAddJob:(Job *)job
{
    //for whatever reason, even when the person gets their jobs array initialized, it is still resetting to be nil. so this is the result of that
    if(self.thePerson.jobs == nil)
    {
        NSLog(@"Houston, we have a problem. The array reference is gone.");
    }
    
    //go through entire array of jobs for person to check if they already have the job being added
    for(int i = 0; i < [self.thePerson.jobs count]; i++)
    {
        if([[(Job*)[self.thePerson.jobs objectAtIndex:i] GetJobTitle] isEqualToString:[job GetJobTitle]])
        {
            //we found the job already exists, so abort adding the job
            return;
        }
    }
    
    
    [self.thePerson.jobs addObject:job];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:([self.thePerson.jobs count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData]; //can't remember if it reloads automatically when the view comes back to the table, so just gonna play it safe and delete this if I get to testing whether or not it does
}

- (IBAction)pressedBackButton:(id)sender
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetSubPrimeViewController] ResetTimer];
    
    [self.delegate currentJobsViewControllerDidBack:self];
    //[self dismissViewControllerAnimated:YES completion:nil]; //this is the code I need to use in the original viewController
}

- (IBAction)pressedAddButton:(id)sender
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetSubPrimeViewController] ResetTimer];
    
    [self performSegueWithIdentifier:@"jobPickerSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
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
    return [self.thePerson.jobs count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.thePerson.firstName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetSubPrimeViewController] ResetTimer];
    
    //trigger segue to new view when selecting that cell
    [self performSegueWithIdentifier:@"jobDescriptionSegue" sender:self];
}

//sets name of cells (with job titles)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* MyIdentifier = @"JobRoleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = [(Job*)[thePerson.jobs objectAtIndex:indexPath.row] GetJobTitle];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.thePerson.jobs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//this event is called whenever interacting with a table view (ie touch and dragging it) since it is actually a scroll view in its construction
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //for some reason, when I call GetPrimeViewController from within this class it pops up the instance of the PrimeViewController as a reference, but doesn't properly compare it as being equal to self when checking 'if(primeController == self)'. This causes a crash since it returns the wrong view controller references which is asked to call PrimeViewController's 'ResetTimer' function (the error code uses the terminology 'selector'. So, I made the opposite of that class function which checks the opposite direction, and... well it works. But I need to truly understand why. My best guess: this is caused due to a separation of two navigation controllers, or just has to do we navigation controllers being used...
    
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetSubPrimeViewController] ResetTimer];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"jobPickerSegue"])
    {
        JobPickerViewController* jobPickerViewController = segue.destinationViewController;
        
        //send thePerson reference to jobPickerViewController
        jobPickerViewController.delegate = self;
        jobPickerViewController.personRef = thePerson;  //I've reviewed the code and it looks pretty safe to remove this line, since I used it by accident
    }
    
    if([segue.identifier isEqualToString:@"jobDescriptionSegue"])
    {
        //get ref to the view controller
        JobsReadOnlyViewController* jobsReadOnlyViewController = (JobsReadOnlyViewController*)segue.destinationViewController;
                
        //set its data values (read only) | problem with nil text labels solved: http://stackoverflow.com/questions/24009728/uilabel-is-always-nil
        jobsReadOnlyViewController.firstNameRO = self.thePerson.firstName;
        jobsReadOnlyViewController.middleNameRO = self.thePerson.middleName;
        jobsReadOnlyViewController.lastNameRO = self.thePerson.lastName;
        
        //get a reference to the selected job from the table
        NSIndexPath* nRowPath = [self.tableView indexPathForSelectedRow];
        Job* theSelectedJob = (Job*)[self.thePerson.jobs objectAtIndex:nRowPath.row];
        
        //pass values of the selected job to the read only view controller
        jobsReadOnlyViewController.jobTitleRO = [theSelectedJob GetJobTitle];
        jobsReadOnlyViewController.jobDescriptionRO = [theSelectedJob GetJobDescription];
    }
}





@end





