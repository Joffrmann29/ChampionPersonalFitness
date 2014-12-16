//
//  AddGoalViewController.m
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import "AddGoalViewController.h"

@interface AddGoalViewController ()


@end

@implementation AddGoalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /* set the textView and textField delegate properties to self so that we can implement their protocol methods */
    self.textView.delegate = self;
    self.textField.delegate = self;
    NSLog(@"%@", self.datePicker.date);
    
    self.view.backgroundColor = [UIColor colorWithRed:42.0f / 255.0f green:184.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    
    [self.datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    
    SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:self.datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(FitnessGoal *)returnNewGoalObject
{
    FitnessGoal *goalObject = [[FitnessGoal alloc] init];
    goalObject.name = self.textField.text;
    goalObject.desc = self.textView.text;
    goalObject.date = self.datePicker.date;
    goalObject.isAchieved = NO;
    
    return goalObject;
}

#pragma mark - UITextFieldDelegate

/* Method is called when the user taps the return key. When this action occurs we tell the textField to dismiss the keyboard. */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

/* UITextView Delegate method. This method is triggered when the user types a new character in the textView. */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /* Test if the entered text is a return. If it is we tell textView to dismiss the keyboard and then we stop the textView from entering in additional information as text. This is not a perfect solution because users cannot enter returns in their text and if they paste text with a return items after the return will not be added. For the functionality required in this project this solution works just fine. */
    if ([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];
        return NO;
    }
    else return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/* If the user presses the addTaskButton call the method defined in the protocol on the delegate property. Pass in a Fitness Goal object using the method returnNewGoalObject. */
- (IBAction)addGoal:(UIBarButtonItem *)sender
{
    if([self.textField.text isEqualToString:@""] || [self.textView.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete Entry" message:@"All fields must be completed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    else{
        [self.delegate didAddGoal:[self returnNewGoalObject]];
    }
}
@end
