//
//  ProfileViewController.h
//  FitnessTracker
//
//  Created by Administrator on 7/5/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitnessProfileViewController.h"
#import "FitnessProfile.h"
#import "CCConstants.h"
#import "ProfileViewController.h"

@protocol ProfileViewControllerDelegate <NSObject>

-(void)updateProfile;

@end

@interface ProfileViewController : UIViewController<FitnessProfileViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *bmiLabel;
@property (weak, nonatomic) id <ProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) FitnessProfile *profileInfo;
@property (strong, nonatomic) PFUser *matchedUser;
@property (strong, nonatomic) ProfileViewController *pController;

- (IBAction)Back:(UIBarButtonItem *)sender;
- (IBAction)EditProfile:(UIBarButtonItem *)sender;
@end
