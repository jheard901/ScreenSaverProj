//
//  DrawViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/9/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "DrawViewController.h"


//static variable needed for initializing TouchTracker's ID | info from: http://stackoverflow.com/questions/16330889/how-to-declare-static-variables-in-objective-c
static NSInteger idTracker = 1000;

//the TouchTracker class

@interface TouchTracker ()
@end

@implementation TouchTracker


//info on initialization: http://stackoverflow.com/questions/6143107/compiler-error-initializer-element-is-not-a-compile-time-constant
- (id) init //I'm starting to think, I can call this anything - it doesn't have to be init as the name for this method (I think...?)
{
    self = [super init];
    if(self)
    {
        //constructor stuff goes here
        touchID = idTracker;
        [self updateTracker];
        bSwiping = NO;
    }
    return self;
}

//info from: http://stackoverflow.com/questions/6084802/passing-parameters-to-a-custom-class-on-initialization
- (id) initTouchTracker:(UITouch *)theInitTouch
{
    self = [super init];
    if(self)
    {
        //constructor stuff
        touchData = theInitTouch;
        touchID = idTracker;
        [self updateTracker];
        bSwiping = NO;
    }
    return self;
}

//increment tracker for a new object to get a valid unique value
- (void) updateTracker
{
    idTracker++;
}

- (UITouch*) GetTouchData
{
    if(touchData)
    {
        return touchData;
    }
    else
    {
        return nil;
    }
}


- (NSInteger) GetID
{
    return touchID;
}

- (void) SetSwiping:(BOOL)swiperNoSwiping
{
    bSwiping = swiperNoSwiping;
}

- (BOOL) GetSwiping
{
    return bSwiping;
}

- (void) SetLastPointLocation:(CGPoint)lastLoc
{
    lastPointLocation = lastLoc;
}

- (CGPoint) GetLastPointLocation
{
    return lastPointLocation;
}

- (void) SetCurrentPointLocation:(CGPoint)currentLoc
{
    currentPointLocation = currentLoc;
}

- (CGPoint) GetCurrentPointLocation
{
    return currentPointLocation;
}



@end




//beginning of DrawViewController class implementation

@interface DrawViewController ()

@end

@implementation DrawViewController

- (id) init
{
    self = [super init];
    if(self)
    {
//        //constructor stuff goes here
//        brushWidth = 10.0;
//        opacity = 1.0;
//        swiped = NO;
//        
//        lastPoint = CGPointZero;
//        red = 0.0;
//        green = 0.0;
//        blue = 0.0;
    }
    return self;
}

//mainImageView holds image of all drawings while tempImageView holds image of line currently being drawn
- (void) DrawLineFrom:(CGPoint)fromPoint To:(CGPoint)toPoint
{
    /*
     Problems to Figure out:
     1) For some reason, the mainImageView & tempImageView (in storyboard) need to be the exact same size as the device's view (self.view) in order to get strokes to be drawn in the exact location that touch is reported at (otherwise it will be drawn at an offset) | I'm not sure why yet, but I'll figure this out
     : it turns out the issue with the image being shifted by an offset after touch ended was because I accidently used the width of frame for both the width and height which explains that offset problem
     : I think the reason behind why the frame size of main/tempImageView needs to the same as the device's view is probably because of the code UIGraphicsBeginImageContext(view*) using the device's frame size - I'll test changing it later
     
     
     */
    
    
    /*
     info from DrawPad example and other resources:
     http://stackoverflow.com/questions/3391489/saving-cgcontextref
     http://stackoverflow.com/questions/6329908/drawing-simple-lines-on-iphone-with-coregraphics
     
     */
    
    
    
    //make a context for drawing into tempImageView
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.tempImageView.image drawInRect: CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.frame.size.height)];
    
    //get current touch point and draw a line from lastPoint to currentPoint
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    
    //set drawing parameters for brush size, opacity, and stroke color
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, brushWidth);
    //while drawing, the stroke color should be blue
    red = 0.125; green = 0.125; blue = 0.75;
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    //draws the path using the context
    CGContextStrokePath(context);
    
    //end the drawing context to render the new line into the tempImageView
    self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempImageView.alpha = opacity;
    UIGraphicsEndImageContext();
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //constructor stuff goes here | not sure why, but these values get reset if they are set in the init
    brushWidth = 10.0;
    opacity = 1.0;
    swiped = NO;
    
    lastPoint = CGPointZero;
    red = 0.0;
    green = 0.0;
    blue = 0.0;
    
    touchTrackers = [NSMutableArray array];
    
    [self.view setMultipleTouchEnabled:YES];
}

//on getting touch information: http://stackoverflow.com/questions/3338617/how-do-i-get-the-location-of-a-touch-in-cocoa-objective-c
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];   //be mindful that super is needed in order for the callback to PrimeViewController's touch event (for screen saver) to occur
    
    /*
    int index = 0;
    BOOL validNewTouch = NO;
    
    while (!validNewTouch)
    {
        TouchTracker* newTouch;
        UITouch* nTouch = [[touches allObjects] objectAtIndex:index];
        [newTouch initTouchTracker:nTouch];
        
        //search through array of touches to see if this touch already exists
        for (int i = 0; i < [touchTrackers count]; i++)
        {
            if([touchTrackers objectAtIndex:i])
        }
        = [TouchTracker initTouchTracker]
        [touchTrackers addObject:(nonnull id)]
    }
    */
    
    //int index = 0;
//    if([touchTrackers count] != 0)
//    {
//        index = (int)[touchTrackers count];
//    }
    
    BOOL validTouch = NO;
    
    //add all unique touches for cases where touches can occur simultaneously (happens in simulator, registering the beginTouch event only once | which means it can happen to a user)
    for(int i = 0; i < [touches count]; i++)
    {
        validTouch = YES;
        
        UITouch* iTouch = [[touches allObjects] objectAtIndex:i];
        
        //check if this touch is already in the touchTracker array
        for(int j = 0; j < [touchTrackers count]; j++)
        {
            if([[touches allObjects] objectAtIndex:i] != [[touchTrackers objectAtIndex:j] GetTouchData])
            {
                //don't add this touch to array
                validTouch = YES;
            }
            else
            {
                //if the touch is found in array, do not repeat adding it
                validTouch = NO;
                break;
            }
        }
        
        //add touch to be tracked if not in the tracker array
        if(validTouch)
        {
            TouchTracker* newTouchTracker = [[TouchTracker alloc] initTouchTracker:iTouch];
            [touchTrackers addObject:newTouchTracker];
            [[touchTrackers objectAtIndex:i] SetSwiping:NO];
            
            if ([[touchTrackers objectAtIndex:i] GetTouchData])
            {
                //this should probably be stored in an array of lastPoints, for this class I think
                lastPoint = [[[touchTrackers objectAtIndex:i] GetTouchData] locationInView:self.view];
                [[touchTrackers objectAtIndex:i] SetLastPointLocation:lastPoint];
            }
        }
        
    }
    //UITouch* iTouch = [[touches allObjects] objectAtIndex:index];   //this should work, only if allObjects stores touches sequentially and doesn't change the order each time its called
    
    //make a TouchTracker for the new touch | on alloc: https://blog.twitter.com/2014/how-to-objective-c-initializer-patterns
    //TouchTracker* newTouchTracker = [[TouchTracker alloc] initTouchTracker:iTouch];
    
    //add that to the TouchTracker array
    //[touchTrackers addObject:newTouchTracker];
    
    //notes on memory management: http://stackoverflow.com/questions/7824158/does-removing-an-object-from-nsarray-automatically-release-its-memory
    //and more: http://stackoverflow.com/questions/1219575/objective-c-release-autorelease-and-data-types
    //[newTouchTracker release];    //can't do this, so I guess ARC does it for me? sigh, let's hope no memory leaks
    
    //start of a drawing event so reset swiped to false, and save the touch location in lastPoint to track the starting point
    //swiped = NO;    //I feel like this should be kept in an array since each finger has its own swipe
    //[[touchTrackers objectAtIndex:index] SetSwiping:NO];
    
    //executes if touch is valid | self.view does not return an accurate location (it's returning an offset from actual location of touch)
    //UITouch* touch = [[touches allObjects] objectAtIndex:0];
    //if ([[touchTrackers objectAtIndex:index] GetTouchData])
    //{
    //    lastPoint = [[[touchTrackers objectAtIndex:index] GetTouchData] locationInView:self.view];
    //}
    
    /*
     the original code for only 1 finger at a time
     
     //start of a drawing event so reset swiped to false, and save the touch location in lastPoint to track the starting point
     swiped = NO;
     
     //executes if touch is valid | self.view does not return an accurate location (it's returning an offset from actual location of touch)
     UITouch* touch = [[touches allObjects] objectAtIndex:0];
     if (touch)
     {
     lastPoint = [touch locationInView:self.view];
     }
     
     */
    
    
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    int index = 0;
    
    for(int i = 0; i < [[touches allObjects] count]; i++)
    {
        for(int j = 0; j < [touchTrackers count]; j++)
        {
            //does this touch comparison work???
            if([[touches allObjects] objectAtIndex:i] == [[touchTrackers objectAtIndex:j] GetTouchData])
            {
                //this is the touch we want to reference
                index = j;
                break;
            }
        }
    }
    
    //new strategy, loop through all the current touches being tracked
    for(int apple = 0; apple < [touchTrackers count]; apple++)
    {
        //UITouch* touch = [[touches allObjects] objectAtIndex:0];
        if ([[touchTrackers objectAtIndex:apple] GetTouchData])
        {
            CGPoint currentPoint = [[[touchTrackers objectAtIndex:apple] GetTouchData] locationInView:self.view];
            [[touchTrackers objectAtIndex:apple] SetCurrentPointLocation:currentPoint];
            
            [self DrawLineFrom:[[touchTrackers objectAtIndex:apple] GetLastPointLocation] To:[[touchTrackers objectAtIndex:apple] GetCurrentPointLocation]];
            //[self DrawLineFrom:lastPoint To:currentPoint];
            
            //update lastPoint so next touch event continues where you left off
            [[touchTrackers objectAtIndex:apple] SetLastPointLocation:[[touchTrackers objectAtIndex:apple] GetCurrentPointLocation]];
            //lastPoint = currentPoint;
            
            [[touchTrackers objectAtIndex:apple] SetSwiping:YES];
        }
    }
    
    //swiped becomes true to track the current swipe in progress
    swiped = YES;
    //[[touchTrackers objectAtIndex:index] SetSwiping:YES];
    
    /*
    the last strategy code, works and shows only 1 touch
    //UITouch* touch = [[touches allObjects] objectAtIndex:0];
    if ([[touchTrackers objectAtIndex:index] GetTouchData])
    {
        CGPoint currentPoint = [[[touchTrackers objectAtIndex:index] GetTouchData] locationInView:self.view];
        [self DrawLineFrom:lastPoint To:currentPoint];
        
        //update lastPoint so next touch event continues where you left off
        lastPoint = currentPoint;
    }
    
    */
    
    
    /*
     the original code
    //swiped becomes true to track the current swipe in progress
    swiped = YES;
    
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    if (touch)
    {
        CGPoint currentPoint = [touch locationInView:self.view];
        [self DrawLineFrom:lastPoint To:currentPoint];
        
        //update lastPoint so next touch event continues where you left off
        lastPoint = currentPoint;
    }
    
    */
    
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    //int index = 0;
    
    for(int i = 0; i < [[touches allObjects] count]; i++)
    {
        for(int j = 0; j < [touchTrackers count]; j++)
        {
            //does this touch comparison work???
            if([[touches allObjects] objectAtIndex:i] == [[touchTrackers objectAtIndex:j] GetTouchData])
            {
                //this is the touch we want to reference
                //index = j;
                if(![[touchTrackers objectAtIndex:j] GetSwiping])
                {
                    //draw a single point if user didn't move finger after touching screen
                    [self DrawLineFrom:[[touchTrackers objectAtIndex:j] GetLastPointLocation] To:[[touchTrackers objectAtIndex:j] GetLastPointLocation]];
                }
                
                //remove that touch from the array
                [touchTrackers removeObjectAtIndex:j];
                
                //break out of loop and repeat for any remaining touches that may have ended "simultaneously" with this one
                break;
            }
        }
    }
    
    /*
    previous code attemp
    if(![[touchTrackers objectAtIndex:index] GetSwiping])
    {
        //draw a single point if user didn't move finger after touching screen
        //[self DrawLineFrom:lastPoint To:lastPoint];
        [self DrawLineFrom:[[touchTrackers objectAtIndex:index] GetLastPointLocation] To:[[touchTrackers objectAtIndex:index] GetLastPointLocation]];
    }
    
    //remove that touch from the array
    [touchTrackers removeObjectAtIndex:index];
    */
    
    /*
    the original code
     
    if(!swiped)
    {
        //draw a single point if user didn't move finger after touching screen
        [self DrawLineFrom:lastPoint To:lastPoint];
    }
    */
     
    //merge the tempImageView into mainImageView
    UIGraphicsBeginImageContext(self.mainImageView.frame.size);
    [self.mainImageView.image drawInRect:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempImageView.image drawInRect:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //when a line is commited, the stroke color changes to black | info from: http://stackoverflow.com/questions/12396236/ios-change-the-colors-of-a-uiimage
    self.mainImageView.image = [self.mainImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.mainImageView setTintColor: [UIColor blackColor]];
    
    //end context
    UIGraphicsEndImageContext();
    
    //reset the tempImageView
    self.tempImageView.image = nil;
}

//I think this is what would be called when a system event occurs that interrupts program | can't confirm it in the simulator
- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if(!swiped)
    {
        //draw a single point if user didn't move finger after touching screen
        [self DrawLineFrom:lastPoint To:lastPoint];
    }
    
    //merge the tempImageView into mainImageView
    UIGraphicsBeginImageContext(self.mainImageView.frame.size);
    [self.mainImageView.image drawInRect:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempImageView.image drawInRect:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //when a line is commited, the stroke color changes to black | info from: http://stackoverflow.com/questions/12396236/ios-change-the-colors-of-a-uiimage
    self.mainImageView.image = [self.mainImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.mainImageView setTintColor: [UIColor blackColor]];
    
    //end context
    UIGraphicsEndImageContext();
    
    //reset the tempImageView
    self.tempImageView.image = nil;
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




