//
//  JobViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "JobViewController.h"
#import "Person.h"
#import "PersonCell.h"
#import "PrimeViewController.h"


@interface JobViewController ()

@end



//NOTES:
//If I want this class to call ResetTimer on swiping a cell (ie popping up the delete option for a cell) then I assume I need to do something with putting in UISwipeGestureRecognizer to be able to detect those events.



@implementation JobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.persons = [NSMutableArray array];
    
    [self.tableView reloadData];
}

- (void)addPersonViewControllerDidCancel:(AddPersonViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//do I need to pass the data back for the job of a person? I think so... so we'll figure that out later
- (void) currentJobsViewControllerDidBack:(CurrentJobsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)addPersonViewController:(AddPersonViewController *)controller didAddPerson:(Person *)person
{
    [self.persons addObject:person];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:([self.persons count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.persons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    Person* person = [self.persons objectAtIndex:indexPath.row];
    
    //custom cell labels
    cell.firstNameLabel.text = person.firstName;
    cell.middleNameLabel.text = person.middleName;
    cell.lastNameLabel.text = person.lastName;
    cell.personImageView.image = [UIImage imageNamed:@"ds_frame"]; //person.personImage;    //using a default image for testing
    
    //change the highlighted color of a cell (from that awkward default gray; answer found here: http://stackoverflow.com/questions/1998775/uitableview-cell-selected-color
    //UIView *bgColorView = [[UIView alloc] init];
    //bgColorView.backgroundColor = [UIColor blueColor];
    //[cell setSelectedBackgroundView:bgColorView];
    
    // Configure the cell...
    
    return cell;
}


//triggers when a row from a table is selected | info from: http://stackoverflow.com/questions/22759167/how-to-make-a-push-segue-when-a-uitableviewcell-is-selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
    
    //trigger segue to new view when selecting that cell | side note: consistency of naming segues is dropping
    [self performSegueWithIdentifier:@"jobsSegue" sender:self];
    
    //after selecting a cell, for some reason the jobs array is getting set to nil
}

//to toggle editing for the purpose of rearranging rows: http://stackoverflow.com/questions/4945092/reordering-cells-in-uitableview
- (void)toggleEditing
{
    self.tableView.editing = !self.tableView.editing;
}

//in an ideal scenario, we wouldn't want to make users press a button to toggle editing. Instead, they should only need to press and drag on a cell for editing to occur and rearrange it in that instance (eliminate the extra unnecessary steps to a process to make it optimal). We'll try to figure this out later provided there is time. UPDATE: so after seeing what the edit does, it doesn't look like my idea is even possible (at least not through native means of the built in API tools). It'll take a lot of work and time to figure out I reckon.
- (IBAction)pressedEditButton:(id)sender
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
    
    [self toggleEditing];
}

- (IBAction)pressedAddButton:(id)sender
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
    
    [self performSegueWithIdentifier:@"AddPersonSegue" sender:self];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
    
    Person* movedPerson = [self.persons objectAtIndex:fromIndexPath.row];
    [self.persons removeObjectAtIndex:fromIndexPath.row];
    [self.persons insertObject:movedPerson atIndex:toIndexPath.row];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.persons removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

//this event is called whenever interacting with a table view (ie touch and dragging it) since it is actually a scroll view in its construction
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //*ahem* this triggers so much... eh, well I can't complain. It gets the job done. But ideally, I would want this to trigger once on beginTouch/Scroll, then user needs to lift finger for this to reset being called the reset. I suppose something of the likes is possible through using a BOOL that is set to true when scrolling, and then once scrolling ends the BOOL becomes false and the timer could be reset again. But I don't feel like doing that work to figure it out if it could possibly lead to some unforeseen bug... after all, I still have to actually implement the screen saver!
    
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
}



#pragma mark - Navigation

//Passing data between views: http://stackoverflow.com/questions/5210535/passing-data-between-view-controllers

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"AddPersonSegue"])
    {
        //set the delegate of destination view controller to self
        AddPersonViewController* addPersonViewController = segue.destinationViewController;
        addPersonViewController.delegate = self;
    }
    
    if([segue.identifier isEqualToString:@"jobsSegue"])
    {
        UINavigationController* navigationController = segue.destinationViewController;
        CurrentJobsViewController* currentJobsViewController = (CurrentJobsViewController*)navigationController.topViewController;
        //CurrentJobsViewController* currentJobsViewController = (CurrentJobsViewController*)[[navigationController viewControllers] objectAtIndex:0]; //alt method of getting the correct controller
        currentJobsViewController.delegate = self;
        
        
        //send person reference to currentJobsViewController
        NSIndexPath* nRowPath = [self.tableView indexPathForSelectedRow];
        currentJobsViewController.thePerson = [self.persons objectAtIndex:nRowPath.row];
    }
}




@end



