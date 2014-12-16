//
//  GoalDetailViewController.m
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import "GoalDetailViewController.h"

@interface GoalDetailViewController ()

@property (strong, nonatomic) IBOutlet UIView *navView;
@end

@implementation GoalDetailViewController

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
    
    /* Update the view objects with the task object.*/
    self.nameLabel.text = [NSString stringWithFormat:@"Name of Goal: %@", self.goal.name];
    self.detailLabel.text = [NSString stringWithFormat:@"Goal Description: %@",self.goal.desc];
    
    /* Set the NSDateFormatter to change the NSDate into an NSString with year-month-day. */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:self.goal.date];
    
    /* Update the dateLabel with the returned string. */
    self.dateLabel.text = [NSString stringWithFormat:@"Date: %@", stringFromDate];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Running.jpg"]];
    
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel sizeToFit];
    
    CGRect myFrame = self.nameLabel.frame;
    // Resize the frame's width to 280 (320 - margins)
    // width could also be myOriginalLabelFrame.size.width
    myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, 320, myFrame.size.height);
    self.nameLabel.frame = myFrame;
}

-(void)postToFacebook
{
        
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[EditGoalViewController class]]){
        EditGoalViewController *editViewController = segue.destinationViewController;
        editViewController.goal = self.goal;
        editViewController.delegate = self;
    }
}

- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"toEditTaskViewControllerSegue" sender:nil];
}

-(void)didUpdateGoal
{
    self.nameLabel.text = self.goal.name;
    self.detailLabel.text = self.goal.desc;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:self.goal.date];
    self.dateLabel.text = stringFromDate;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate updateGoal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
