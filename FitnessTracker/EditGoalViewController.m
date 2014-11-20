//
//  EditGoalViewController.m
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import "EditGoalViewController.h"

@interface EditGoalViewController ()

@end

@implementation EditGoalViewController

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
    
    /* Set the initial view objects with the Task's properties */
    self.textField.text = self.goal.name;
    self.textView.text = self.goal.description;
    self.datePicker.date = self.goal.date;
    
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"ChampionNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Zapfino" size:17],
      NSFontAttributeName, nil]];
    
    /* Set the delegate properties for the UITextView and UITextField so that the CCEditTaskViewController instance can recieve messages from the UITextFieldDelegate and UITextViewDelegate. */
    self.textView.delegate = self;
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Helper method which updates the task object to reflect the changes in the EditTaskViewController. */
-(void)updateGoal
{
    self.goal.name = self.textField.text;
    self.goal.desc = self.textView.text;
    self.goal.date = self.datePicker.date;
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

- (IBAction)saveGoal:(UIBarButtonItem *)sender
{
    [self updateGoal];
    [self.delegate didUpdateGoal];
}

- (IBAction)back:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
