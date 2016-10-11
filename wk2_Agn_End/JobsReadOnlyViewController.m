//
//  JobsReadOnlyViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "JobsReadOnlyViewController.h"
#import "PrimeViewController.h"


@interface JobsReadOnlyViewController ()

@end

@implementation JobsReadOnlyViewController

@synthesize firstNameRO;
@synthesize middleNameRO;
@synthesize lastNameRO;
@synthesize jobTitleRO;
@synthesize jobDescriptionRO;

@synthesize firstNameLabel;
@synthesize middleNameLabel;
@synthesize lastNameLabel;
@synthesize jobTitleLabel;
@synthesize jobDescriptionLabel;



- (id) init
{
    self = [super init];
    
    if(self)
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //labels can only be set after view has loaded
    self.firstNameLabel.text = self.firstNameRO;
    self.middleNameLabel.text = self.middleNameRO;
    self.lastNameLabel.text = self.lastNameRO;
    self.jobTitleLabel.text = self.jobTitleRO;
    self.jobDescriptionLabel.text = self.jobDescriptionRO;
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetSubPrimeViewController] ResetTimer];
    
    //on touch, dismiss this view and return to the previous one
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
