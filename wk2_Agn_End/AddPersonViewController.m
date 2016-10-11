//
//  AddPersonViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "AddPersonViewController.h"
#import "Person.h"
#import "PrimeViewController.h"

@interface AddPersonViewController ()

@end

@implementation AddPersonViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set the delegates | helper info: http://stackoverflow.com/questions/11837188/how-to-set-delegate-of-text-field-in-objective-c
    self.firstNameTextField.delegate = self;
    self.middleNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    
    //add return key functionality to the text fields | we don't need to manually CTRL + drag the textfields to an action when we do it this way
    [self.firstNameTextField setReturnKeyType:UIReturnKeyDone];
    [self.firstNameTextField addTarget:self action:@selector(TextFieldIsDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.middleNameTextField setReturnKeyType:UIReturnKeyDone];
    [self.middleNameTextField addTarget:self action:@selector(TextFieldIsDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.lastNameTextField setReturnKeyType:UIReturnKeyDone];
    [self.lastNameTextField addTarget:self action:@selector(TextFieldIsDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //register notifications for when text fields change
    [self registerForTextFieldNotifications];
}

//info on popping this view off stack from: http://stackoverflow.com/questions/3249240/how-to-pop-a-controller-off-the-navigation-stack-without-using-the-navigation-ba
-(IBAction)cancel:(id)sender
{
    [self.delegate addPersonViewControllerDidCancel:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)confirm:(id)sender
{
    Person* person = [[Person alloc] init];
    person.firstName = self.firstNameTextField.text;
    person.middleName = self.middleNameTextField.text;
    person.lastName = self.lastNameTextField.text;
    //person.personImage =  //@"nope.jpg"
    person.jobs = [NSMutableArray array];
    
    [self.delegate addPersonViewController:self didAddPerson:person];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerForTextFieldNotifications
{
    //info from: http://stackoverflow.com/questions/5216245/how-to-handle-key-events-in-iphone
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidBeginEditingNotification object:self.firstNameTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.firstNameTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidEndEditingNotification object:self.firstNameTextField];
    
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidBeginEditingNotification object:self.middleNameTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.middleNameTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidEndEditingNotification object:self.middleNameTextField];
    
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidBeginEditingNotification object:self.lastNameTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.lastNameTextField];
    [notificationCenter addObserver:self selector:@selector(OnTextFieldChanged:) name:UITextFieldTextDidEndEditingNotification object:self.lastNameTextField];
}

- (void)OnTextFieldChanged:(id)notification
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetPrimeViewController] ResetTimer];
}

- (IBAction)TextFieldIsDone:(id)sender
{
    [sender resignFirstResponder];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    //end text editing where applicable
    [self.view endEditing:YES];
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
