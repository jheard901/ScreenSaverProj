//
//  Person.m
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize firstName;
@synthesize middleName;
@synthesize lastName;
@synthesize personImage;

@synthesize jobs;



- (id) init
{
    self = [super init];
    
    if(self)
    {
        //initialize jobs array | for some reason, this is not called when a Person is created, and I thought that was the point of this being an initializer... sigh.
        jobs = [NSMutableArray array];
    }
    return self;
}




@end



