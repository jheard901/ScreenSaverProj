//
//  Person.h
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* middleName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, assign) UIImage* personImage;   //include UIKit, but is this ideal way to do it? I doubt...

/*
 WE FOUND THE FIX TO THE PROBLEM WITH JOBS RESETTING EACH TIME IT WAS INITIALIZED!!!
 
 So, the issue that caused the jobs array to keep resetting even after it was initialized was because I declared the property to be
 '(weak, nonatomic)'
 which caused ARC to automatically deallocate the object because of it being a "weak" reference... I swear I need more time to learn all the basics of objective c and what all those darn properties do to objects or variables...... I spent 4 hours on debugging this issue, what a gigantic waste of time caused by simply not knowing the basics!!!
*/
@property (retain, nonatomic) NSMutableArray* jobs;



-(id) init;


@end
