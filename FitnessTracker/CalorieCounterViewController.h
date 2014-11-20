//
//  CalorieCounterViewController.h
//  FitnessTracker
//
//  Created by Administrator on 6/15/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitnessMapViewController.h"
#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface CalorieCounterViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>

@property (assign, nonatomic) float bmi;
@property (assign, nonatomic) float weight;
@property (assign, nonatomic) float heightInInches;
@property (assign, nonatomic) float calories;

@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginBarButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookLogin;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


- (IBAction)getCalories:(id)sender;
- (IBAction)Login:(UIButton *)sender;
- (IBAction)loginPressed:(UIButton *)sender;
- (IBAction)showMenu:(UIBarButtonItem *)sender;
- (IBAction)facebookLogin:(UIButton *)sender;

@end
