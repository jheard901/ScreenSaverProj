//
//  PrimeViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "PrimeViewController.h"


const CGFloat timerDuration = 20.0; //I recommend a value of at least 20 seconds (ßug Me Not)


@interface PrimeViewController ()

@end

@implementation PrimeViewController

//on using constructors" http://stackoverflow.com/questions/5841400/constructor-in-objective-c
- (id) init
{
    self = [super init];
    if(self)
    {
        timerEndedSelector = sel_registerName("TimerEnded:");
        bTimerActive = NO;
        bScreenSaverActive = NO;
        bIsTouching = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self StartTimer];
}




//////////////// TIMER METHODS ////////////////

//This should really be in a separate class, but we'll explore that possibility later.


- (void) StartTimer
{
    //activate timer if it is not yet active
    if(!bTimerActive)
    {
        //Objective C BOOL values explained (tldr; use YES or NO for BOOL inputs):
        //http://stackoverflow.com/questions/28244584/objective-c-true-false-vs-true-false
        //http://stackoverflow.com/questions/690903/why-does-objective-c-use-yes-and-no-instead-of-1-and-0
        //http://stackoverflow.com/questions/615702/is-there-a-difference-between-yes-no-true-false-and-true-false-in-objective-c
        timer = [NSTimer scheduledTimerWithTimeInterval:timerDuration target:self selector:@selector(TimerEnded) userInfo:nil repeats:NO];
        
        bTimerActive = YES;
        NSLog(@"The timer has started.");
    }
    
}

- (void) StopTimer
{
    if(bTimerActive)
    {
        [timer invalidate];
        timer = nil;
        
        bTimerActive = NO;
        NSLog(@"The timer has stopped.");
    }
}

- (void) ResetTimer
{
    [self StopTimer];
    [self StartTimer];
    
    NSLog(@"The timer has finished resetting.");
}

- (void) TimerEnded
{
    if(bTimerActive)
    {
        bTimerActive = NO;
        
        //how to print messages: http://stackoverflow.com/questions/9422671/write-debug-messages-to-xcode-output-window
        NSLog(@"The timer has completed."); //formatting example: NSLog(@"Value of string is %@", myNSString);
        
        if(!bScreenSaverActive)
        {
            bScreenSaverActive = YES;
            
            //how to push to a ViewController only through code: http://stackoverflow.com/questions/15371995/push-to-another-view-controller-without-prepareforsegue
            //supplementary information explaining what a modal push is: http://stackoverflow.com/questions/4600448/iphone-show-modal-uitableviewcontroller-with-navigation-bar
            
            if(!screenSaverVC)
            {
                screenSaverVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SSViewController"];
                [screenSaverVC SetPriorViewController:self];
            }
            
            //solution derived from: http://stackoverflow.com/questions/6131205/iphone-how-to-find-topmost-view-controller
            UIViewController* topViewController = [PrimeViewController GetTopViewController];
            [topViewController presentViewController:screenSaverVC animated:YES completion:nil];
            
        }
        
    }
}



//////////////// UTILITY METHODS ////////////////


//explanation of difference between + and - used for a class method http://stackoverflow.com/questions/2611419/difference-between-and-before-function-name-in-objective-c
+ (UIViewController*) GetTopViewController
{
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //continues executing if topController is presenting another view
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

+ (UIViewController*) GetPrimeViewController
{
    UIViewController* primeController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (primeController.presentedViewController)
    {
        //if we find this controller in the stack, then return it
        if(primeController == self)
        {
            return primeController;
        }
        primeController = primeController.presentedViewController;
    }
    
    return primeController;
}

+ (UIViewController*) GetSubPrimeViewController
{
    UIViewController* subPrimeController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while(subPrimeController.presentingViewController)
    {
        if (subPrimeController == self)
        {
            return subPrimeController;
        }
        subPrimeController = subPrimeController.presentingViewController;
    }
    return subPrimeController;
}



//////////////// TOUCH METHODS ////////////////


//on using overrides: http://stackoverflow.com/questions/6858457/objective-c-overriding-method-in-subclass
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event];
    
    
    //check for input to interact with timers only when screen saver is not active
    if(!bScreenSaverActive)
    {
        //check if timer is active
        if(bTimerActive)
        {
            //stop it while user is touching screen
            [self StopTimer];
        }
    }
    
    //dismiss the screen saver view and return to the previous view
    if(bScreenSaverActive)
    {
        //true if not nil
        if(screenSaverVC)
        {
            //check that the user touched the block from the screen saver
            
            //get the point of touch for screen saver dismissal
            CGPoint point = [[[touches allObjects] objectAtIndex:0] locationInView:screenSaverVC.view];
            
            //create a touch rect that is bigger and easier to click than the actual object | use an offset to center the touchRect on square
            CGFloat multiplier = 2.4;
            CGFloat xOffset = screenSaverVC.square.frame.size.width * (multiplier * 0.5);
            CGFloat yOffset = screenSaverVC.square.frame.size.height * (multiplier * 0.5);
            CGRect touchRect = CGRectMake(screenSaverVC.square.frame.origin.x - xOffset, screenSaverVC.square.frame.origin.y - yOffset, screenSaverVC.square.frame.size.width * multiplier, screenSaverVC.square.frame.size.height * multiplier);
            if(CGRectContainsPoint(touchRect, point))
            {
                //dismissing a modal view: http://stackoverflow.com/questions/8513319/closing-a-view-displayed-via-a-modal-segue
                [screenSaverVC dismissViewControllerAnimated:YES completion:nil];
                
                //restart the timer
                bScreenSaverActive = NO;
                [self StartTimer];
            }
            
        }
        else
        {
            NSLog(@"Error: The screen saver controller is nil");
        }
    }
}



-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    
    //check for input to interact with timers only when screen saver is not active
    if(!bScreenSaverActive)
    {
        //check if timer is active
        if(bTimerActive)
        {
            [self ResetTimer];  //note, this should never trigger because when touch begins it stops the timer and makes it not active
        }
        //if not then make it active
        else
        {
            [self StartTimer];
        }
    }
}

//////////////// TAB BAR METHODS ////////////////

//info from: http://stackoverflow.com/questions/5885667/iphone-app-detect-which-tab-bar-item-was-pressed
- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self ResetTimer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end






