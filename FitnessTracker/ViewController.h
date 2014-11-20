//
//  ViewController.h
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGoalViewController.h"
#import "GoalDetailViewController.h"
#import "AppDelegate.h"
#import "CalorieCounterViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Social/Social.h>
#import "FitnessGoal.h"
//#import <FatSecretKit/FSClient.h>

#define GOAL_OBJECTS_KEY @"Goal Objects Key"

@interface ViewController : UIViewController<GoalDetailViewControllerDelegate,AddGoalViewControllerDelegate, UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,MPMediaPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *goalObjects;
@property (strong, nonatomic) NSArray *goals;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isOverDue;
@property (nonatomic, assign) int numberOfDays;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) UIImage *profileImg;

- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender;
- (IBAction)addGoalBarButtonItemPressed:(UIBarButtonItem *)sender;
- (IBAction)logout:(UIBarButtonItem *)sender;
- (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

@end
