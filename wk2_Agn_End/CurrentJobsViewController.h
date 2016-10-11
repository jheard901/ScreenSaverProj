//
//  CurrentJobsViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobPickerViewController.h"

@class Person;
@class CurrentJobsViewController;

@protocol CurrentJobsViewControllerDelegate <NSObject>

- (void)currentJobsViewControllerDidBack: (CurrentJobsViewController*)controller;

@end


@interface CurrentJobsViewController : UITableViewController <JobPickerViewControllerDelegate>

@property (nonatomic, weak) id <CurrentJobsViewControllerDelegate> delegate;
@property (nonatomic, assign) Person* thePerson;   //use to pull a list of jobs from the person

- (IBAction)pressedBackButton:(id)sender;
- (IBAction)pressedAddButton:(id)sender;



@end
