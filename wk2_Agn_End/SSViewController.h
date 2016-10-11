//
//  SSViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

//this is the screen saver view controller!

@interface SSViewController : UIViewController <UICollisionBehaviorDelegate>
{
    UIViewController* priorViewController;
}

//I need this as a property for passing to the PrimeViewController
@property UIImageView* square;

@property UIDynamicAnimator* animator;
@property UIGravityBehavior* gravity;
@property UICollisionBehavior* collision;
@property UIDynamicItemBehavior* itemBehavior;
@property UIPushBehavior* pushBehavior;


-(UIImageView*)GetSquareRef;

-(int)GetRandomNumberFrom:(int)lowerBound To:(int)upperBound;
-(float)GetRandomFloatFrom:(float)lowerBound To:(float)upperBound;

//might not need this
- (void) SetPriorViewController: (UIViewController*)controller;






@end



