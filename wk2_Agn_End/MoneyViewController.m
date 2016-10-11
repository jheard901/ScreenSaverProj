//
//  MoneyViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/8/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "MoneyViewController.h"
#import "PrimeViewController.h"

@interface MoneyViewController ()

@end

@implementation MoneyViewController

- (id) init
{
    self = [super init];
    if(self)
    {
        //constructor stuff goes here
        
    }
    return self;
}


//how to vertically align text (thanks Apple): http://stackoverflow.com/questions/1054558/vertically-align-text-to-top-within-a-uilabel and also http://stackoverflow.com/questions/7192088/how-to-set-top-left-alignment-for-uilabel-for-ios-application
- (void) UpdateResultLabel
{
    //we make a function for this since changing the text of resultTextLabel resets it to default formatting
    [self.resultTextLabel setNumberOfLines:0];
    CGRect resultTextFrame = CGRectMake(self.resultTextLabel.frame.origin.x, self.resultTextLabel.frame.origin.y, 160, 220);
    [self.resultTextLabel setFrame:resultTextFrame];
    [self.resultTextLabel sizeToFit];
}

//a negative return value means not enough cash was handed in
- (CGFloat) ComputeResult:(CGFloat)ppValue OtherVal:(CGFloat)chValue
{
    CGFloat result = 0.0;
    result = chValue - ppValue;
    
    return result;
}

//returns true if cValue is nearly equal to nValue | only for use with floats
- (BOOL) FloatIsEqual:(CGFloat)cValue To:(CGFloat)nValue
{
    //get the difference between the two values
    //CGFloat rValue = nValue - cValue;
    
    //get the absolute value | info from: http://stackoverflow.com/questions/4717060/convert-to-absolute-value-in-objective-c
    CGFloat rValue = fabs(nValue - cValue);
    
    //check that the two values are nearly equal (allow minimal degree of error)
    if(rValue < 0.001)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSMutableArray*) GetReturnTotal:(CGFloat)inputValue
{
    //init a storage array
    NSMutableArray* resultReturnTotal = [NSMutableArray array];
    CGFloat remainingResult = inputValue;
    
    //rounding the result to 2 decimal places for avoiding awkward decimal differences that a PENNY cannot subtract from to equal 0 | info from: http://stackoverflow.com/questions/560517/make-a-float-only-show-two-decimal-places
    NSString* sResult = [NSString stringWithFormat:@"%.2f", remainingResult];
    remainingResult = atof([sResult UTF8String]);
    
    
    //continue adding values to array while there is still a value to count
    while(![self FloatIsEqual:remainingResult To:0.0])
    //while(remainingResult != 0.0)
    {
        
        //check from largest currency first, then work your way down to smallest
        if (remainingResult >= 100.0)        //ONE HUNDRED
        {
            remainingResult -= 100.0;
            [resultReturnTotal addObject:@"ONE HUNDRED"];
        }
        else if (remainingResult >= 50.0)    //FIFTY
        {
            remainingResult -= 50.0;
            [resultReturnTotal addObject:@"FIFTY"];
        }
        else if (remainingResult >= 20.0)    //TWENTY
        {
            remainingResult -= 20.0;
            [resultReturnTotal addObject:@"TWENTY"];
        }
        else if (remainingResult >= 10.0)    //TEN
        {
            remainingResult -= 10.0;
            [resultReturnTotal addObject:@"TEN"];
        }
        else if (remainingResult >= 5.0)     //FIVE
        {
            remainingResult -= 5.0;
            [resultReturnTotal addObject:@"FIVE"];
        }
        else if (remainingResult >= 2.0)     //TWO
        {
            remainingResult -= 2.0;
            [resultReturnTotal addObject:@"TWO"];
        }
        else if (remainingResult >= 1.0)     //ONE
        {
            remainingResult -= 1.0;
            [resultReturnTotal addObject:@"ONE"];
        }
        else if (remainingResult >= 0.50)    //HALF DOLLAR
        {
            remainingResult -= 0.50;
            [resultReturnTotal addObject:@"HALF DOLLAR"];
        }
        else if (remainingResult >= 0.25)    //QUARTER
        {
            remainingResult -= 0.25;
            [resultReturnTotal addObject:@"QUARTER"];
        }
        else if (remainingResult >= 0.10)    //DIME
        {
            remainingResult -= 0.10;
            [resultReturnTotal addObject:@"DIME"];
        }
        else if (remainingResult >= 0.05)    //NICKEL
        {
            remainingResult -= 0.05;
            [resultReturnTotal addObject:@"NICKEL"];
        }
        else if (remainingResult >= 0.01)    //PENNY
        {
            remainingResult -= 0.01;
            [resultReturnTotal addObject:@"PENNY"];
        }
        else
        {
            //if no values were valid then continue incrementing until it makes it to a valid value (ie PENNY)
            remainingResult += 0.001;
        }
    }
    
    return resultReturnTotal;
}

//fires off the specified event/function (ie selector) for the observer object when the specified notification occurs for the specified object
- (void) registerForTextFieldNotifications
{
    //info from: http://stackoverflow.com/questions/5216245/how-to-handle-key-events-in-iphone
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidBeginEditingNotification object:self.ppTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.ppTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidEndEditingNotification object:self.ppTextField];
    
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidBeginEditingNotification object:self.chTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.chTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidEndEditingNotification object:self.chTextField];
}


- (void) OnTextFieldChanged:(id)notification
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set the delegates | helper info: http://stackoverflow.com/questions/11837188/how-to-set-delegate-of-text-field-in-objective-c
    self.ppTextField.delegate = self;
    self.chTextField.delegate = self;
    
    //add return key functionality to the text fields | we don't need to manually CTRL + drag the textfields to an action when we do it this way
    [self.ppTextField setReturnKeyType:UIReturnKeyDone];
    [self.ppTextField addTarget:self action:@selector(TextFieldIsDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.chTextField setReturnKeyType:UIReturnKeyDone];
    [self.chTextField addTarget:self action:@selector(TextFieldIsDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //register notifications for when text fields change
    [self registerForTextFieldNotifications];
    
    [self UpdateResultLabel];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
}

//event fired off when return/enter key is pressed while editing a text field | info from: http://stackoverflow.com/questions/2828826/iphone-keyboard-done-button-and-resignfirstresponder
-(IBAction)TextFieldIsDone:(id)sender
{
    [sender resignFirstResponder];
    
    //reset timer | moved this functionality to 'OnTextFieldChanged'
    //[(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
}

//whenever editing ends, the result label should update
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    //check that both labels are not empty
    if(![self.ppTextField.text isEqual: @""] && ![self.chTextField.text isEqual: @""])
    {
        //change it from grayed out color to black | info from: http://stackoverflow.com/questions/2508600/how-to-programmatically-change-uicolor-of-view
        self.resultTextLabel.textColor = [UIColor blackColor];
        
        //check if the string only has numeric values
        NSString* ppString = self.ppTextField.text;
        NSString* chString = self.chTextField.text;
        CGFloat resultValue = 0.0;
        
        //if true, the textField strings contains only numbers 0 - 9 | info from: http://stackoverflow.com/questions/6091414/finding-out-whether-a-string-is-numeric-or-not
        //alternate method that is more accurate for decimal numbers from: http://stackoverflow.com/questions/11588571/ios-how-do-i-check-if-a-string-is-numeric-or-not
        NSScanner* scanner = [NSScanner scannerWithString:ppString];
        if ([scanner scanDouble:NULL] && [scanner isAtEnd])
        {
            //okay, now check 2nd value
            NSScanner* scannerTwo = [NSScanner scannerWithString:chString];
            if ([scannerTwo scanDouble:NULL] && [scannerTwo isAtEnd])
            {
                //we did it!
                
                //user input okay
                CGFloat v1 = [ppString floatValue];
                CGFloat v2 = [chString floatValue];
                resultValue = v2 - v1;
                
                //NSLog(@"%f", resultValue);
            }
            else
            {
                //display ERROR message
                self.resultTextLabel.text = @"ERROR";
                [self UpdateResultLabel];
                return;
            }
        }
        else
        {
            //display ERROR message
            self.resultTextLabel.text = @"ERROR";
            [self UpdateResultLabel];
            return;
        }
        
        //assess whether or not the result is valid and update resultTextLabel appropiately
        if (resultValue < 0.0)
        {
            //invalid
            self.resultTextLabel.text = @"ERROR";
        }
        else if ([self FloatIsEqual:resultValue To:0.0])
        {
            //okay
            self.resultTextLabel.text = @"ZERO";
        }
        else
        {
            //valid | now we need to convert the value into the expected string output
            
            //return an array of strings that total the result (not sorted)
            NSMutableArray* totalResult = [self GetReturnTotal:resultValue];
            
            //sort the array of strings alphabetically; this makes it harder to read the result imo, since by default its sorted by largest to smallest currency values but its requirements =/
            //info on sorting: http://stackoverflow.com/questions/1351182/how-to-sort-a-nsarray-alphabetically
            NSArray* sortedResult = [totalResult sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            //format the array of strings into a single string to display for the resultTextLabel | appending info: http://stackoverflow.com/questions/510269/shortcuts-in-objective-c-to-concatenate-nsstrings
            NSString* textTotalResult = @"";
            for(int i = 0; i < [sortedResult count]; i++)
            {
                NSString* temp = [sortedResult objectAtIndex:i];
                
                //special case only for beginning value
                if (i == 0)
                {
                    textTotalResult = [textTotalResult stringByAppendingFormat:@"%@", temp];
                }
                else
                {
                    textTotalResult = [textTotalResult stringByAppendingFormat:@", %@", temp];
                }
                
            }
            
            self.resultTextLabel.text = textTotalResult;
        }
        
        //update label whenever the text changes
        [self UpdateResultLabel];
    }
    
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


