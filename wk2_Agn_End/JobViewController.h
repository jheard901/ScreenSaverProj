//
//  JobViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPersonViewController.h"
#import "CurrentJobsViewController.h"

//not gonna lie, DoctorG you da real MVP: http://stackoverflow.com/questions/3349609/how-to-detect-touch-event-in-table-cells-for-iphone

@interface JobViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddPersonViewControllerDelegate, CurrentJobsViewControllerDelegate, UIScrollViewDelegate>


@property (nonatomic, retain) NSMutableArray* persons;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void) toggleEditing;
- (IBAction)pressedEditButton:(id)sender;
- (IBAction)pressedAddButton:(id)sender;



//- (id) init; //could initialize persons array in init, but I'll just use viewDidLoad


@end



