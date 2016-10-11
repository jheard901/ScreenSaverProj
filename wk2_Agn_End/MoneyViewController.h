//
//  MoneyViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/8/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubViewController.h"

//creating enums: http://stackoverflow.com/questions/2212080/how-do-i-define-and-use-an-enum-in-objective-c

@interface MoneyViewController : SubViewController <UITextFieldDelegate>
{
    
}


@property (weak, nonatomic) IBOutlet UITextField *ppTextField;
@property (weak, nonatomic) IBOutlet UITextField *chTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultTextLabel;



- (id) init;
- (void) UpdateResultLabel;
- (CGFloat) ComputeResult:(CGFloat)ppValue OtherVal:(CGFloat)chValue;
- (BOOL) FloatIsEqual:(CGFloat)cValue To:(CGFloat)nValue;
- (NSMutableArray*) GetReturnTotal:(CGFloat)inputValue;
- (void) registerForTextFieldNotifications;
- (void) OnTextFieldChanged:(id)notification;
- (IBAction)TextFieldIsDone:(id)sender;

@end



