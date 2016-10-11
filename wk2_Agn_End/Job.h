//
//  Job.h
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject

@property (nonatomic, copy) NSString* jobTitle;
@property (nonatomic, copy) NSString* jobDescription;

-(NSString*) GetJobTitle;
-(NSString*) GetJobDescription;

@end


