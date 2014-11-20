//
//  FitnessProfileViewController.h
//  FitnessTracker
//
//  Created by Administrator on 6/25/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CalorieCounterViewController.h"
#import "FitnessProfile.h"

@protocol FitnessProfileViewControllerDelegate <NSObject>

-(void)didUpdateProfile;

@end

@interface FitnessProfileViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (strong, nonatomic) IBOutlet UITextField *heightField;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameText;
- (IBAction)createProfile:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *profileImg;
@property (weak, nonatomic) id <FitnessProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) FitnessProfile *profile;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) PFUser *matchedUser;

@property (nonatomic) float bmi;

- (IBAction)Back:(UIBarButtonItem *)sender;
@end
