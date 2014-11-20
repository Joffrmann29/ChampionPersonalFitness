//
//  CalorieCounterViewController.m
//  FitnessTracker
//
//  Created by Administrator on 6/15/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#define kOFFSET_FOR_KEYBOARD 80.0
#import "CalorieCounterViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"


@interface CalorieCounterViewController ()<FBLoginViewDelegate,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    MBProgressHUD *hud;
}

@property (strong, nonatomic) FBLoginView *loginview;

@end

@implementation CalorieCounterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.userField] || [sender isEqual:self.passField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    self.passField.delegate = self;
    self.userField.delegate = self;
    
    CALayer *btnLayer = [_facebookLogin layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:10.0f];
    [btnLayer setBorderWidth:5.0f];
    [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    CALayer *btnLayer2 = [_signUpButton layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:10.0f];
    [btnLayer2 setBorderWidth:1.0f];
    [btnLayer2 setBorderColor:[[UIColor whiteColor] CGColor]];
    
    CALayer *btnLayer3 = [_loginButton layer];
    [btnLayer3 setMasksToBounds:YES];
    [btnLayer3 setCornerRadius:10.0f];
    [btnLayer3 setBorderWidth:1.0f];
    [btnLayer3 setBorderColor:[[UIColor whiteColor] CGColor]];
    
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = _signUpButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:12.0f / 255.0f green:62.0f / 255.0f blue:222.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:11.0f / 255.0f green:51.0f / 255.0f blue:101.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [_signUpButton.layer insertSublayer:btnGradient atIndex:0];
    
    CAGradientLayer *btnGradient2 = [CAGradientLayer layer];
    btnGradient2.frame = _loginButton.bounds;
    btnGradient2.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:96.0f / 255.0f green:24.0f / 255.0f blue:96.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:48.0f / 255.0f green:12.0f / 255.0f blue:48.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [_loginButton.layer insertSublayer:btnGradient2 atIndex:0];
    
    UIColor *textfieldPlaceholderColor = [UIColor darkGrayColor];
    
    [self.passField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.userField setValue:textfieldPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.passField setSecureTextEntry:YES];
    [self.menuBarButton setEnabled:NO];
    
    // Create Login View so that the app will be granted "status_update" permission.
    self.loginview = [[FBLoginView alloc] init];
    
    self.loginview.frame = CGRectOffset(self.loginview.frame, 44, 340);
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.loginview.frame = CGRectOffset(self.loginview.frame, 5, 25);
    }
#endif
#endif
#endif
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"ChampionForApp.jpeg"]];
    self.loginview.delegate = self;
    
    //self.view.backgroundColor = [UIColor blackColor];
  
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Valid internet connection");
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"You are not currently connected to the internet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        });
    };
    
    [reach startNotifier];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [self performSegueWithIdentifier:@"toViewController" sender:self];
    }
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //notificationLabel.text = @"Notification Says Reachable";
    }
    else
    {
        //notificationLabel.text = @"Notification Says Unreachable";
    }
}

-(void)getUserData
{
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user){
            if (!error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"The Facebook Login was Canceled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
        }
        if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
            [self performSegueWithIdentifier:@"toViewController" sender:self];
        }
        else{
            //[self performSegueWithIdentifier:@"toProfile" sender:nil];
        }
    }];
}

- (IBAction)facebookLogin:(UIButton *)sender {
    [self getUserData];
    //show loading indicator
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self setViewMovedUp:NO];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(void)canLogin
{
    if([self.userField.text isEqualToString:@""])
    {
        UIAlertView *facebookAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enter a valid fitness goal" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        //[facebookAlert dismissWithClickedButtonIndex:1 animated:NO];
        [facebookAlert show];
        _loginBarButton.enabled = NO;
    }
    else if([self.passField.text isEqualToString:@""])
        {
            UIAlertView *facebookAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enter a valid fitness goal" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            //[facebookAlert dismissWithClickedButtonIndex:1 animated:NO];
            [facebookAlert show];
        }
    else
    {
        [self performSegueWithIdentifier:@"toViewController" sender:nil];
        _loginBarButton.enabled = YES;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //[self viewDidLoad];
    }
}

- (IBAction)getCalories:(id)sender
{
    [self canLogin];
}

- (IBAction)loginPressed:(UIButton *)sender
{
    [PFUser logInWithUsernameInBackground:self.userField.text password:self.passField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //Open the wall
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have successfully logged in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self performSegueWithIdentifier:@"toViewController" sender:self];
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}

- (IBAction)Login:(UIButton *)sender
{
    PFUser *newUser = [PFUser user];
    newUser.username = self.userField.text;
    newUser.password = self.passField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your trackmaster account has been successfully created" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [self performSegueWithIdentifier:@"toProfile" sender:nil];
        }
        else{
            NSLog(@"%@", error);
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];

}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showMenu:(UIBarButtonItem *)sender
{
    [self loginPressed:self.loginButton];
    NSLog(@"Hit");
}

@end
