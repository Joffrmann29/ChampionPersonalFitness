//
//  AddGoalViewController.h
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitnessGoal.h"


@protocol AddGoalViewControllerDelegate <NSObject>

-(void)didAddGoal:(FitnessGoal *)goal;

@end

@interface AddGoalViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

/* A delegate property which will allow us to call the protocol methods. */
@property (weak, nonatomic) id <AddGoalViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) FitnessGoal *goal;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)addGoal:(UIBarButtonItem *)sender;
- (IBAction)back:(UIBarButtonItem *)sender;


@end
