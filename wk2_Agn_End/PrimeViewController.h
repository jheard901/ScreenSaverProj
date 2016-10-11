//
//  PrimeViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"


//using consts: http://stackoverflow.com/questions/5875474/does-const-go-before-or-after-cgfloat
//more info on consts: http://stackoverflow.com/questions/538996/constants-in-objective-c
//and more...: http://stackoverflow.com/questions/6188672/where-do-you-declare-a-constant-in-objective-c
extern const CGFloat timerDuration;



//this will be the object that every view controller will be subviewed from pretty much in order to modally push the screen saver to the top-most view
@interface PrimeViewController : UITabBarController
{
    //on using timer: http://stackoverflow.com/questions/1449035/how-do-i-use-nstimer
    NSTimer* timer;
    //on using selectors: http://stackoverflow.com/questions/6224976/how-to-get-rid-of-the-undeclared-selector-warning
    //turns out this selector was not needed, there were simply logical syntax errors that the IDE didn't correct
    SEL timerEndedSelector;
    
    BOOL bTimerActive;
    BOOL bScreenSaverActive;
    BOOL bIsTouching;   //true when user is touching screen with any finger
    
    SSViewController* screenSaverVC;
}

//in the future, for any @property variables you create, you need to synthesize it if you don't define the getter and setter methods manually as explained here: http://stackoverflow.com/questions/10425827/please-explain-getter-and-setters-in-objective-c
//and this is recap on what synthesize does: http://stackoverflow.com/questions/3266467/what-exactly-does-synthesize-do


- (id) init;
- (void) StartTimer;
- (void) StopTimer;
- (void) ResetTimer;
- (void) TimerEnded;
+ (UIViewController*) GetTopViewController;
+ (UIViewController*) GetPrimeViewController;
+ (UIViewController*) GetSubPrimeViewController;



@end





