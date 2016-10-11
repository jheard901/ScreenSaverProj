//
//  DrawViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/9/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>



//this class will be used to track individual touches (would prefer to do a struct, but using Obj-C, "nope"
@interface TouchTracker : NSObject
{
    UITouch* touchData;
    NSInteger touchID;
    BOOL bSwiping;
    CGPoint lastPointLocation;
    CGPoint currentPointLocation;
}

//too many problems with trying to make constants happen :/
//extern NSInteger const touchID;

- (id) init;
- (id) initTouchTracker:(UITouch*)theInitTouch;
- (void) updateTracker;
- (UITouch*) GetTouchData;
- (NSInteger) GetID;
- (void) SetSwiping:(BOOL)bIsSwiping;
- (BOOL) GetSwiping;
- (void) SetLastPointLocation:(CGPoint)lastLoc;
- (CGPoint) GetLastPointLocation;
- (void) SetCurrentPointLocation:(CGPoint)currentLoc;
- (CGPoint) GetCurrentPointLocation;


@end



//the main class
@interface DrawViewController : UIViewController
{
    CGFloat brushWidth;
    CGFloat opacity;
    BOOL swiped;
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    NSMutableArray* touchTrackers;  //array of TouchTrackers for UITouch and its supporting values
}

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tempImageView;

- (id) init;
- (void) DrawLineFrom:(CGPoint)fromPoint To:(CGPoint)toPoint;





@end



