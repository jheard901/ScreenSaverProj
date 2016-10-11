//
//  JobsReadOnlyViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsReadOnlyViewController : UIViewController

//problem explained for why UILabel text stays nil even after assigning it properly: http://stackoverflow.com/questions/24009728/uilabel-is-always-nil
//tldr; assign values to a string, and then in the view controller's viewDidLoad, set the UILabels text there

@property NSString* firstNameRO;
@property NSString* middleNameRO;
@property NSString* lastNameRO;
@property NSString* jobTitleRO;
@property NSString* jobDescriptionRO;

@property (nonatomic, strong) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *middleNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *jobTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *jobDescriptionLabel;

-(id) init;

@end



