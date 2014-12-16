//
//  ProfileViewController.m
//  FitnessTracker
//
//  Created by Administrator on 7/5/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) IBOutlet UIView *navView;

@end

@implementation ProfileViewController

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
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *IDToFetch = [PFUser currentUser].objectId;
    PFQuery *query = [PFUser query];
    [query whereKey:@"user_id" equalTo:IDToFetch];
    PFUser *foundUser = [PFUser currentUser];
    self.firstNameLabel.text = foundUser[@"Name"];
    self.ageLabel.text = foundUser[@"Age"];
    NSString *height = foundUser[@"Height"];
    int h = [height intValue];
    int feet = h/12;
    int inches = h % 12;
    NSString *formattedHeight = [NSString stringWithFormat:@"%i'%i", feet, inches];
    self.heightLabel.text = formattedHeight;
    self.weightLabel.text = foundUser[@"Weight"];
    self.bmiLabel.text = foundUser[@"BMI"];
    [foundUser saveEventually];
    
    //NSDictionary *profileDict = self.matchedUser[@"profile"];
    self.matchedUser = [PFUser currentUser];
    PFFile *theImage = [self.matchedUser objectForKey:USERPROFILEIMAGE];
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    }];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Running.jpg"]];
}

- (void)requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kCCPhotoClassKey];
    [query whereKey:kCCPhotoUserKey equalTo:[PFUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0)
        {
            PFUser *user = [PFUser currentUser];
            
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[kCCUserProfileKey][kCCUserProfilePictureURL]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0.0f];
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if (!urlConnection){
                NSLog(@"Failed to Download Picture");
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[FitnessProfileViewController class]]){
        PFUser *foundUser = [PFUser currentUser];
        FitnessProfileViewController *editViewController = segue.destinationViewController;
        editViewController.profile = self.profileInfo;
        editViewController.name = foundUser[@"Name"];
        editViewController.age = foundUser[@"Age"];
        editViewController.height = foundUser[@"Height"];
        editViewController.weight = foundUser[@"Weight"];
        [foundUser save];
        editViewController.delegate = self;
    }
}

-(void)didUpdateProfile
{
    NSString *IDToFetch = [PFUser currentUser].objectId;
    PFQuery *query = [PFUser query];
    [query whereKey:@"user_id" equalTo:IDToFetch];
    PFUser *foundUser = [PFUser currentUser];
    self.firstNameLabel.text = self.profileInfo.firstName;
    self.ageLabel.text = [NSString stringWithFormat:@"%i",self.profileInfo.age];
    self.heightLabel.text = [NSString stringWithFormat:@"%i",self.profileInfo.height];
    self.weightLabel.text = [NSString stringWithFormat:@"%i",self.profileInfo.weight];
    self.bmiLabel.text = [NSString stringWithFormat:@"%f",self.profileInfo.bodyMass];
    [foundUser saveEventually:^(BOOL succeeded, NSError *error) {
        [self.delegate updateProfile];
        if(succeeded){
            NSLog(@"The profile has been updated");
        }
    }];
}

- (IBAction)Back:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)EditProfile:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"toEditProfile" sender:sender];
}
@end
