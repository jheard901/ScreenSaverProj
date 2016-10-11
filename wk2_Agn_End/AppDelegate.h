//
//  AppDelegate.h
//  wk2_Agn_End
//
//  Created by User on 10/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/*
 //this is a general good read that you should do to understand using Objective C better, a lot better: http://stackoverflow.com/questions/12632285/declaration-definition-of-variables-locations-in-objectivec
 //this looks like a good read on using table cells (I've only glanced through it so I'm not certain): https://code.tutsplus.com/tutorials/ios-sdk-crafting-custom-uitableview-cells--mobile-15702
 //this looks like it'll come in handy later: http://stackoverflow.com/questions/3481858/tutorial-on-how-to-drag-and-drop-item-from-uitableview-to-uitableview
 
 
 /////// Kinks to Work Out Later ///////
 
 1)
 Problem:   For the screen saver, the timer does not stop when touching other objects such as a button, the tab bar interface, or anything in general that is non-interactive in the current view
 Expected Result:   Touching/interacting with anything in the program should stop the timer, and then restart it once touch input has ended
 
 
 
 */





@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

