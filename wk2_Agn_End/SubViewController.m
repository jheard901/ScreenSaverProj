//
//  SubViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "SubViewController.h"

@implementation SubViewController



- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    //end text editing where applicable
    [self.view endEditing:YES];
}



@end
