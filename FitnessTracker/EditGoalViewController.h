//
//  EditGoalViewController.h
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitnessGoal.h"

@protocol EditGoalViewControllerDelegate <NSObject>

-(void)didUpdateGoal;

@end

@interface EditGoalViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) FitnessGoal *goal;
@property (weak, nonatomic) id <EditGoalViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)back:(UIBarButtonItem *)sender;

@end
