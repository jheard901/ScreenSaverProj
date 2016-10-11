//
//  SSViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/7/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "SSViewController.h"

@interface SSViewController ()

@end

@implementation SSViewController


//I don't think manually synthesizing matters anymore tbh, if I remember correctly I read somewhere that synthesizing occurs automatically if not getter/setter methods are made for properties, but if you do make them it will default to using those defintions for a property.
@synthesize square;
@synthesize animator;
@synthesize gravity;
@synthesize collision;
@synthesize itemBehavior;
@synthesize pushBehavior;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /////// Setting up other stuff //////////////////////////////////////////////////////////////////
    
    /*
    //load a gif: info from: https://medium.com/swift-programming/ios-make-an-awesome-video-background-view-objective-c-swift-318e1d71d0a2#.4n85np7rw
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"castle" ofType:@"gif"];
    NSData* gif = [NSData dataWithContentsOfFile:filePath]; //loading gif works, but takes considerably buffer time when loaded through a UIWebView
    //create a UIWebView to display gif on, disable interaction with it since it functions like a ScrollView
    UIWebView* webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];    //if this line gives issues, then try @"" in place of nil
    webViewBG.userInteractionEnabled = NO;
    [self.view addSubview:webViewBG];
    //optional filter to overlay on webViewBG
    UIView* filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.05;
    [self.view addSubview:filter];
    */
    
    //alternate method: http://stackoverflow.com/questions/4386675/add-animated-gif-image-in-iphone-uiimageview
    
    //this works much better since it is not loading a UIWebView which seems to include a whole lot based off how long it hangs before initializing
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"frame_0.gif"],
                                         [UIImage imageNamed:@"frame_1.gif"],
                                         [UIImage imageNamed:@"frame_2.gif"],
                                         [UIImage imageNamed:@"frame_3.gif"],
                                         [UIImage imageNamed:@"frame_4.gif"],
                                         [UIImage imageNamed:@"frame_5.gif"],
                                         [UIImage imageNamed:@"frame_6.gif"],
                                         [UIImage imageNamed:@"frame_7.gif"],
                                         [UIImage imageNamed:@"frame_8.gif"],
                                         [UIImage imageNamed:@"frame_9.gif"],
                                         [UIImage imageNamed:@"frame_10.gif"],
                                         [UIImage imageNamed:@"frame_11.gif"],
                                         [UIImage imageNamed:@"frame_12.gif"],
                                         [UIImage imageNamed:@"frame_13.gif"],
                                         [UIImage imageNamed:@"frame_14.gif"],
                                         [UIImage imageNamed:@"frame_15.gif"],
                                         [UIImage imageNamed:@"frame_16.gif"],
                                         [UIImage imageNamed:@"frame_17.gif"],
                                         [UIImage imageNamed:@"frame_18.gif"],
                                         [UIImage imageNamed:@"frame_19.gif"],
                                         [UIImage imageNamed:@"frame_20.gif"],
                                         [UIImage imageNamed:@"frame_21.gif"],
                                         [UIImage imageNamed:@"frame_22.gif"],
                                         [UIImage imageNamed:@"frame_23.gif"], nil];
    animatedImageView.animationDuration = 2.0f;
    animatedImageView.animationRepeatCount = 0;
    [animatedImageView startAnimating];
    [self.view addSubview: animatedImageView];
    
    /////// Setting up the collisions and objects that are dynamic within scene /////////////////////
    
    //create the title text
    //note, we could of used a higher resolution image because the view strectches (or compresses) the image based off the frame size
    UIImageView* titleText = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.075, self.view.frame.size.height * 0.25, self.view.frame.size.width * 0.85, 30.0)];
    UIImage* titleImage = [UIImage imageNamed:@"touch_the_block"];
    titleText.image = titleImage;
    [self.view addSubview:titleText];
    
    //quick refresher on adding images: http://stackoverflow.com/questions/9317911/add-image-to-view
    self.square = [[UIImageView alloc] initWithFrame:CGRectMake(100.0, 100.0, 64.0, 64.0)]; //this was a UIImageView* before
    UIImage* squareImage = [UIImage imageNamed:@"block"];
    self.square.image = squareImage;
    //square.backgroundColor = [UIColor redColor]; //debug testing to show block
    [self.view addSubview:self.square];
    
    //UIView* barrier = [[UIView alloc] initWithFrame:CGRectMake(0.0, 300.0, 130.0, 25.0)];
    CGFloat barrierSize = 48.0;
    UIView* barrier = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - barrierSize, self.view.frame.size.width, barrierSize)];
    //barrier.backgroundColor = [UIColor greenColor]; //used for debug testing to see location of barrier
    [self.view addSubview:barrier];
    
    itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:[NSArray arrayWithObjects:self.square, nil]];
    itemBehavior.elasticity = 0.85; //controls how much falloff to kinetic energy occurs each time it has contact with a boundary | 1.0 = no falloff
    
    pushBehavior = [[UIPushBehavior alloc] initWithItems:[NSArray arrayWithObjects:self.square, nil] mode:UIPushBehaviorModeContinuous];
    pushBehavior.angle = (CGFloat)[self GetRandomNumberFrom:0 To:360];
    pushBehavior.magnitude = 2.0; //(CGFloat)[self GetRandomNumberFrom:2 To:4];
    
    gravity = [[UIGravityBehavior alloc] initWithItems:[NSArray arrayWithObjects:self.square, nil]];
    gravity.magnitude = 0.45;   //default value = 1.0 which is roughly ~9.8m/s | 0.0 = no gravity and resets gravityDirection to (0.0, 0.0)
    gravity.gravityDirection = CGVectorMake(0.0, 1.0); //default value = (0.0, 1.0) which is a downward force
    //recall positive x points to right, and positive y points down, so if you want to do crazy things with gravity then as follows:
    //(1, 0) = gravity pulls to right
    //(-1, 0) = gravity pulls to left
    //(0, 1) = gravity pulls down
    //(0, -1) = gravity pulls up.
    
    collision = [[UICollisionBehavior alloc] initWithItems:[NSArray arrayWithObjects:self.square, nil]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    //creating BezierPaths in Objective C is apparently a whole 'nother beast compared to Swift... http://stackoverflow.com/questions/21311880/drawing-uibezierpath-on-code-generated-uiview
    //found how to create the Bezier path from here: http://stackoverflow.com/questions/28442516/ios-an-easy-way-to-draw-a-circle-using-cashapelayer
    //CAShapeLayer* barrierLayer = [CAShapeLayer layer];
    //[barrierLayer setPath:[[UIBezierPath bezierPathWithRect:(CGRect)]]]
    UIBezierPath* barrierPath = [UIBezierPath bezierPathWithRect:barrier.frame];
    [collision addBoundaryWithIdentifier:@"barrierPathBoundary" forPath:barrierPath];
    collision.collisionDelegate = self;
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [animator addBehavior:gravity];
    [animator addBehavior:collision];
    [animator addBehavior:itemBehavior];
    [animator addBehavior:pushBehavior];
}


-(void) collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    //sets a new offset to apply the pushBehavior to (works to rotate item) | a good value for this depends on size of item
    //UIOffset newOffset = UIOffsetMake(200.0, 20.0);   //if you want to see it really spin...
    UIOffset newOffset = UIOffsetMake((CGFloat)[self GetRandomFloatFrom:-20.0 To:20.0], (CGFloat)[self GetRandomFloatFrom:-20.0 To:20.0]);
    [pushBehavior setTargetOffsetFromCenter:newOffset forItem:item];
    
    
    //randomize gravity's direction each time collision occurs to keep the object always moving in a new direction
    gravity.gravityDirection = CGVectorMake((CGFloat)[self GetRandomFloatFrom:-1.0 To:1.0], (CGFloat)[self GetRandomFloatFrom:-1.0 To:1.0]);
}


#pragma mark - Helper Functions

-(UIImageView*)GetSquareRef
{
    return self.square;
}

// info from: http://stackoverflow.com/questions/9678373/generate-random-numbers-between-two-numbers-in-objective-c
-(int)GetRandomNumberFrom:(int)lowerBound To:(int)upperBound
{
    int randNum = lowerBound + arc4random() % (upperBound - lowerBound);
    return randNum;
}

//info from: http://stackoverflow.com/questions/3410070/how-to-create-a-random-float-in-objective-c/4579457#4579457
-(float)GetRandomFloatFrom:(float)lowerBound To:(float)upperBound
{
    float diff = upperBound - lowerBound;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + lowerBound;
}

- (void)SetPriorViewController:(UIViewController *)controller
{
    priorViewController = controller;
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
