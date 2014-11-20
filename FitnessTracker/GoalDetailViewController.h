//
//  GoalDetailViewController.h
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitnessGoal.h"
#import "EditGoalViewController.h"


@protocol GoalDetailViewControllerDelegate <NSObject>

-(void)updateGoal;

@end

@interface GoalDetailViewController : UIViewController<EditGoalViewControllerDelegate>


@property (strong, nonatomic) FitnessGoal *goal;
@property (weak, nonatomic) id <GoalDetailViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)editBarButtonItemPressed:(UIBarButtonItem *)sender;
- (IBAction)Back:(UIBarButtonItem *)sender;

@end
