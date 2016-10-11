//
//  JobPickerViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;
@class Job;
@class JobPickerViewController;



@protocol JobPickerViewControllerDelegate <NSObject>

- (void)jobPickerViewController:(JobPickerViewController*)controller didAddJob:(Job*)job;

@end


@interface JobPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id <JobPickerViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *jobPickerView;
@property (weak, nonatomic) IBOutlet UILabel *jobDescriptionLabel;

@property (nonatomic, assign) Person* personRef;
@property (nonatomic, strong) NSMutableArray* jobListings;

- (IBAction)pressedConfirmButton:(id)sender;
- (void)fillJobListings;

@end


