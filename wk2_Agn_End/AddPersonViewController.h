//
//  AddPersonViewController.h
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <UIKit/UIKit.h>

//these are forward declarations in Objective C, I think...
@class Person;
@class AddPersonViewController;
@class JobViewController;


//this delegate protocol is used to communicate back from the AddPerson view to the main view of listed Persons
@protocol AddPersonViewControllerDelegate <NSObject>

- (void)addPersonViewControllerDidCancel: (AddPersonViewController*)controller;

- (void)addPersonViewController:(AddPersonViewController*)controller didAddPerson:(Person*)person;

@end



@interface AddPersonViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, weak) id <AddPersonViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middleNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;



-(IBAction)cancel:(id)sender;
-(IBAction)confirm:(id)sender;

- (void)registerForTextFieldNotifications;
- (void)OnTextFieldChanged:(id)notification;
- (IBAction)TextFieldIsDone:(id)sender;


@end



