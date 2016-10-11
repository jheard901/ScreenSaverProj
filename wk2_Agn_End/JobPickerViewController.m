//
//  JobPickerViewController.m
//  wk2_Agn_End
//
//  Created by User on 10/10/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "JobPickerViewController.h"
#import "Person.h"
#import "Job.h"
#import "PrimeViewController.h"


@interface JobPickerViewController ()

@end

@implementation JobPickerViewController

@synthesize personRef;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fillJobListings];
    
    self.jobPickerView.delegate = self;
    self.jobPickerView.dataSource = self;
    
    //on view loading, update the jobDescriptionLabel to match the first element
    self.jobDescriptionLabel.text = [(Job*)[self.jobListings objectAtIndex:0] GetJobDescription];
}

//how to setup a picker view: http://stackoverflow.com/questions/7040553/how-do-i-fill-an-uipickerview-with-text-strings-during-do-while-loop

//the values that will be put into the pickerView | I'm totally tripping, for some reason I was thinking I need to use the array of jobs that a person has for populating the picker, instead of using an array that I initialize myself to populate the picker with
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [(Job*)[self.jobListings objectAtIndex:row] GetJobTitle];
    //return [(Job*)[self.personRef.jobs objectAtIndex:row] GetJobTitle];
}

//the number of rows that will be added to each component (maybe we can make this aysmmetric with more than 1 component?)
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.jobListings count];
    //return [self.personRef.jobs count];
}

//how many components of pieces to split the picker view into | utilize 1 to get a single wheel; utilize 3 if you want to simulate a slot machine look
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//this is what should be used for changing the label job description as the picker is changing
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //reset timer
    [(PrimeViewController*)[PrimeViewController GetSubPrimeViewController] ResetTimer];
    
    //exclude this when testing
    self.jobDescriptionLabel.text = [(Job*)[self.jobListings objectAtIndex:row] GetJobDescription];
    
    //this should be deleted, idk what I was thinking lol
    //self.jobDescriptionLabel.text = [(Job*)[self.personRef.jobs objectAtIndex:row] GetJobDescription];
}

- (IBAction)pressedConfirmButton:(id)sender
{
    Job* selectedJob = [self.jobListings objectAtIndex:[self.jobPickerView selectedRowInComponent:0]];
    [self.delegate jobPickerViewController:self didAddJob:selectedJob];
    [self.navigationController popViewControllerAnimated:YES];
}

//define the array of data to fill the picker with | only run this ONCE!
- (void)fillJobListings
{
    self.jobListings = [NSMutableArray array];
    
    //we'll do the fun part of filling in job descriptions later, refer to your notes for the details of it
    
    //programmer
    Job* job1 = [[Job alloc] init];
    job1.jobTitle = @"Programmer";
    job1.jobDescription = @"The workhorses of any development team. These are the real machos that are responsible for getting things done. They don't get paid the big bucks for nothing.";
    [self.jobListings addObject:job1];
    
    //artist
    Job* job2 = [[Job alloc] init];
    job2.jobTitle = @"Artist";
    job2.jobDescription = @"Typically the playboys of any development team. These guys spend a ton of time making the art that you find in applications - sure, that's hard work. Other than that, what else are they responsible for doing?";
    [self.jobListings addObject:job2];
    
    //designer
    Job* job3 = [[Job alloc] init];
    job3.jobTitle = @"Designer";
    job3.jobDescription = @"Any designer can come up with a million ideas of things that might be worth trying out, but any designer worth his salt knows how to come up with idea, execute it, and present it for review.";
    [self.jobListings addObject:job3];
    
    //producer
    Job* job4 = [[Job alloc] init];
    job4.jobTitle = @"Producer";
    job4.jobDescription = @"Some guys get by as managers, and then you have some guys that are naturally born to pull it off. The best producers could kidnap and you wouldn't even realize it.";
    [self.jobListings addObject:job4];
    
    //con artist
    Job* job5 = [[Job alloc] init];
    job5.jobTitle = @"Con-Artist";
    job5.jobDescription = @"Adept at defrauding a person or group through gaining their confidence and trust. Exploits characteristics of the human psyche such as honesty, vanity, compassion, credulity, irresponsibility, naïveté, and greed. Nevertheless, a valid profession.";
    [self.jobListings addObject:job5];
    
    //thief
    Job* job6 = [[Job alloc] init];
    job6.jobTitle = @"Thief";
    job6.jobDescription = @"Relys on wits, speed, and subterfuge to achieve their goal. While they are known for their stealthy nature both in and out of battle, many of them are quite talented with machines and contraptions of all sorts.";
    [self.jobListings addObject:job6];
    
    //adventurer
    Job* job7 = [[Job alloc] init];
    job7.jobTitle = @"Adventurer";
    job7.jobDescription = @"A journeyman seeking glories of gold, pleasure, and fame. Confronts the biggest and scariest foes without even the slightest thought of doubt. However, ever vigilant of the ol' arrow to the knee.";
    [self.jobListings addObject:job7];
    
    //warrior
    Job* job8 = [[Job alloc] init];
    job8.jobTitle = @"Paladin";
    job8.jobDescription = @"Extremely devoted, often fanatical, soldiers who have pledged themselves to a chosen cause or organization. They can inspire nearby allies and have the ability to quickly assist their allies";
    [self.jobListings addObject:job8];
    
    //the kid
    Job* job9 = [[Job alloc] init];
    job9.jobTitle = @"The Kid";
    job9.jobDescription = @"In an ideal world, Apple would of made built-in support for vertical alignment, but that would make too much sense...";
    [self.jobListings addObject:job9];

    //brew master
    Job* job10 = [[Job alloc] init];
    job10.jobTitle = @"Brew Master";
    job10.jobDescription = @"Authorities in the world of alcohol and boozes, these craftsmen do the world a great service. Brew masters cover a wide range of responsibilities, aside from just drinking beer. They develop concepts, test beer, and run the business.";
    [self.jobListings addObject:job10];
    
    //pawn
    Job* job11 = [[Job alloc] init];
    job11.jobTitle = @"Pawn";
    job11.jobDescription = @"This the kingpin, a'ight? And he the man. You get the other dude's king, you got the game. But he trying to get your king too, so you gotta protect it. Now, the king, he move one space any direction he damn choose, 'cause he's the king.";
    [self.jobListings addObject:job11];
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



