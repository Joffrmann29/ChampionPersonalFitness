//
//  ViewController.m
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import "ViewController.h"
#import "FitnessProfileViewController.h"
#import "CCConstants.h"
#import "MenuViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITableViewCell *goalCell;
@property (strong, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (strong, nonatomic) UIActionSheet *logOutAction;
@property (strong, nonatomic) UIActionSheet *menuActionSheet;
@property (strong, nonatomic) UIImage *postImage;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSMutableArray *goalObjectsWeekTwo;
@property (strong, nonatomic) NSMutableArray *goalObjectsWeekThree;
@property (strong, nonatomic) NSMutableArray *goalObjectsWeekFour;

@end

@implementation ViewController

-(NSMutableArray *)goalObjects
{
    if (!_goalObjects){
        _goalObjects = [[NSMutableArray alloc] init];
    }
    
    return _goalObjects;
}

-(NSMutableArray *)goalObjectsWeekTwo
{
    if (!_goalObjectsWeekTwo){
        _goalObjectsWeekTwo = [[NSMutableArray alloc] init];
    }
    
    return _goalObjectsWeekTwo;
}

-(NSMutableArray *)goalObjectsWeekThree
{
    if(!_goalObjectsWeekThree){
        _goalObjectsWeekThree = [[NSMutableArray alloc]init];
    }
    return _goalObjectsWeekThree;
}

-(NSMutableArray *)goalObjectsWeekFour
{
    if(_goalObjectsWeekFour){
        _goalObjectsWeekFour = [[NSMutableArray alloc]init];
    }
    return _goalObjectsWeekFour;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);

    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Arial" size:17.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    CGRect navBounds = CGRectMake(0, 0, 320, 94);
    self.navigationController.navigationBar.bounds = navBounds;
    
    CALayer * bgGradientLayer = [self gradientBGLayerForBounds:self.navigationController.navigationBar.bounds];
    UIGraphicsBeginImageContext(bgGradientLayer.bounds.size);
    [bgGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * bgAsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    if (bgAsImage != nil)
    {
        [[UINavigationBar appearance] setBackgroundImage:bgAsImage
                                           forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        NSLog(@"Failed to create gradient bg image, user will see standard tint color gradient.");
    }
    
    /* Set the tableView's datasource and delegate properties to self so that the UITableViewControllerDelegate and UITableViewControllerDataSource know to pass message to this instance of the viewController. */
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    /* Access NSUserDefaults for the array containing the task's saved as NSDictionary objects. */
    NSArray *goalsAsPropertyLists = [[NSUserDefaults standardUserDefaults] arrayForKey:GOAL_OBJECTS_KEY];
    
    /* Iterate over the returned array with fast enumeration. Convert each dictionary into a FitnessGoal object using the helper method goalObjectForDictionary. Add the returned goal objects to the goalObjectsArray */
    for (NSDictionary *dictionary in goalsAsPropertyLists){
        FitnessGoal *goalObject = [self goalObjectForDictionary:dictionary];
        NSInteger days = [self getDateDistance:goalObject];
        if(days <= 7){
        [self.goalObjects addObject:goalObject];
        }
        else if(days >7 && days <= 14){
            [self.goalObjectsWeekTwo addObject:goalObject];
        }
        else if(days >14){
            [self.goalObjectsWeekThree addObject:goalObject];
        }
        /*else if(days > 21 && days <= 28){
            [self.goalObjectsWeekFour addObject:goalObject];
        }*/
    }
    FitnessGoal *goal = [[FitnessGoal alloc]init];
    self.isOverDue = NO;
    /* Determine if the goal is overdue using the helper method isDateGreaterThanDate */
    self.isOverDue = [self isDateGreaterThanDate:[NSDate date] and:goal.date];
    
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error){
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            //create URL
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
            if (userDictionary[@"name"]){
                userProfile[kCCUserProfileNameKey] = userDictionary[@"name"];
            }
            if (userDictionary[@"first_name"]){
                userProfile[kCCUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if (userDictionary[@"location"][@"name"]){
                userProfile[kCCUserProfileLocationKey] = userDictionary[@"location"][@"name"];
            }
            if (userDictionary[@"gender"]){
                userProfile[kCCUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if (userDictionary[@"birthday"]){
                userProfile[kCCUserProfileBirthdayKey] = userDictionary[@"birthday"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [formatter dateFromString:userDictionary[@"birthday"]];
                NSDate *now = [NSDate date];
                NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                int age = seconds / 31536000;
                userProfile[kCCUserProfileAgeKey] = @(age);
            }
            if (userDictionary[@"interested_in"]){
                userProfile[kCCUserProfileInterestedInKey] = userDictionary[@"interested_in"];
            }
            if (userDictionary[@"relationship_status"]){
                userProfile[kCCUserProfileRelationshipStatusKey] = userDictionary[@"relationship_status"];
            }
            if ([pictureURL absoluteString]){
                userProfile[kCCUserProfilePictureURL] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:kCCUserProfileKey];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self requestImage];
            }];
        }
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self checkIndexPath];
}

-(void)checkIndexPath
{
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES selector:@selector(compare:)];
        [_goalObjects sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
        [_goalObjectsWeekTwo sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
        [_goalObjectsWeekThree sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
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

-(void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"ProfileImage.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            // Create a PFObject around a PFFile and associate it with the current user
            [[PFUser currentUser] setObject:imageFile forKey:USERPROFILEIMAGE];
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error)
                {
                    //[self refresh:nil];
                }
                else
                {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection did recieve data");
    [self.imageData appendData:data];
    [self uploadImage:self.imageData];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.profileImg = [UIImage imageWithData:self.imageData];
}

- (void)takePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)uploadPicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _postImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)showAction
{
    NSString *actionSheetTitle = @"Menu Options"; //Action Sheet Title
    NSString *addGoal = @"Add Goal";
    NSString *mapRoute = @"Map Jogging Route";
    NSString *profile = @"Profile";
    NSString *music = @"Music";
    NSString *facebook = @"Post to Facebook";
    NSString *twitter = @"Post to Twitter";
    NSString *takePicture = @"Camera";
    NSString *uploadPicture = @"Choose Existing Photo";
    NSString *cancelTitle = @"Cancel Button";
    
    _menuActionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:addGoal
                                  otherButtonTitles:mapRoute,profile, music, facebook, twitter, takePicture, uploadPicture, nil];
    [_menuActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == _menuActionSheet){
        if(buttonIndex == 0)
        {
            [self performSegueWithIdentifier:@"toAddTaskViewControllerSegue" sender:nil];
        }
    
        else if(buttonIndex == 1)
        {
            [self performSegueWithIdentifier:@"toFitnessView" sender:nil];
        }
    
        else if(buttonIndex == 2)
        {
            [self performSegueWithIdentifier:@"toProfile" sender:nil];
        }
    
        else if(buttonIndex == 3)
        {
            [self performSegueWithIdentifier:@"toMusic" sender:nil];
        }
    
        else if(buttonIndex == 4)
        {
            [self postToFacebook];
        }
    
        else if(buttonIndex == 5)
        {
            [self postToTwitter];
        }
        
        else if(buttonIndex == 6)
        {
            [self takePicture];
        }
        
        else if(buttonIndex == 7)
        {
            [self uploadPicture];
        }
    }
    if(actionSheet == _logOutAction){
        if(actionSheet == _logOutAction && buttonIndex == 0)
        {
            [PFUser logOut];
            CalorieCounterViewController *calorieView = [self.storyboard instantiateViewControllerWithIdentifier:@"CalorieCounter"];
            
            [self presentViewController:calorieView animated:YES completion:nil];

        }
    }
}

-(void)postToFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet addImage:_postImage];
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
    else if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        UIAlertView *facebookAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You cannot post to Facebook at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [facebookAlert show];
    }
    
    
    else
    {
        UIAlertView *facebookAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You cannot post to Facebook at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [facebookAlert show];
    }

}

-(void)postToTwitter
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *twitterSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterSheet addImage:_postImage];
        [self presentViewController:twitterSheet animated:YES completion:nil];
    }
    else if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        UIAlertView *facebookAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You cannot post to Twitter at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [facebookAlert show];
    }
    
    
    else
    {
        UIAlertView *facebookAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You cannot post to Twitter at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [facebookAlert show];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FitnessGoal *goalObject = [[FitnessGoal alloc]init];
    /* Before transitioning to the CCAddTaskViewController set the delegate property to self. This way the CCAddTaskViewController will be able to call methods in the ViewController file. */
    if ([segue.destinationViewController isKindOfClass:[AddGoalViewController class]]){
        AddGoalViewController *addGoalViewController = segue.destinationViewController;
        addGoalViewController.delegate = self;
    }
    
    /* Before transitioning to the CCDetailTaskViewController determine the task selected by the user based on the sender argument of NSIndexPath. Set the task property of the detailTaskViewController. Also set the delegate property to self. This way the CCDetailTaskViewController will be able to call methods in the ViewController file. */
    
    else if ([segue.destinationViewController isKindOfClass:[GoalDetailViewController class]]){
        GoalDetailViewController *detailViewController = segue.destinationViewController;
        NSIndexPath *path = sender;
        if(path.section == 0){
        goalObject = self.goalObjects[path.row];
        }
        
        else if(path.section == 1){
            goalObject = self.goalObjectsWeekTwo[path.row];
        }
        
        else if(path.section == 2){
            goalObject = self.goalObjectsWeekThree[path.row];
        }
        
        else if(path.section == 3){
            goalObject = self.goalObjectsWeekFour[path.row];
        }
        detailViewController.goal = goalObject;
        detailViewController.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* When the reorderBarButtonItem is pressed check if the tableView is in editing mode. If it is setEditing mode to NO otherwise set it to YES. */
- (IBAction)reorderBarButtonItemPressed:(UIBarButtonItem *)sender
{
    if (self.tableView.editing == YES)[self.tableView setEditing:NO animated:YES];
    else [self.tableView setEditing:YES animated:YES];
}

/* When the addGoalBarButtonItem is pressed transition to the AddGoalViewController */
- (IBAction)addGoalBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self showAction];
    //[self getLastYearDate];
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    NSString *actionSheetTitle = @"Are you sure you want to log out?"; //Action Sheet Title
    //NSString *destructiveTitle = @"Destructive Button"; //Action Sheet Button Titles
    NSString *yesString = @"Yes";
    NSString *noString = @"No";
    NSString *cancelTitle = @"Cancel";
    
    _logOutAction = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:yesString
                                  otherButtonTitles:noString, nil];
    [_logOutAction showInView:self.view];
}

#pragma mark - CCAddTaskViewControllerDelegate

/* Delegate method called when a task is added in the AddTaskViewController. Notice that the task added is passed as a parameter.*/
-(void)didAddGoal:(FitnessGoal *)goal
{
    /*  Add the task object to the taskObjects array. */
    NSInteger days = [self getDateDistance:goal];
    if(days <= 7){
    [self.goalObjects addObject:goal];
    }
    
    else if(days > 7 && days <= 14){
        [self.goalObjectsWeekTwo addObject:goal];
    }
    
    else if(days > 14){
        [self.goalObjectsWeekThree addObject:goal];
    }
    
    /* Use NSUserDefaults to access all previously saved tasks. If there were not saved tasks we allocate and initialize the NSMutableArray named taskObjectsAsPropertyLists. */
    NSMutableArray *goalObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:GOAL_OBJECTS_KEY] mutableCopy];
    if (!goalObjectsAsPropertyLists) goalObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    /* First convert the task object to a property list using the method taskObjectAsAPropertyList. Then add the propertylist (dictionary) to the taskObjectsAsPropertyLists NSMutableArray. Synchronize will save the added array to NSUserDefaults.*/
    [goalObjectsAsPropertyLists addObject:[self goalObjectsAsAPropertyList:goal]];
    [[NSUserDefaults standardUserDefaults] setObject:goalObjectsAsPropertyLists forKey:GOAL_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}

-(NSInteger)getDateDistance:(FitnessGoal *)goalObject
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components: NSDayCalendarUnit
                                           fromDate: [NSDate date]
                                             toDate: goalObject.date
                                            options: 0];
    NSInteger days = [comps day];
    
    
//    if(days < 2 && !goalObject.isAchieved)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"YOUR GOAL DEADLINE IS RAPIDLY APPROACHING!" message:@"This goal is not far away, please do not forget." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
    
    return days;
}

#pragma mark - CCDetailTaskViewControllerDelegate

/* Delegate call back from the CCDetailTaskViewController. Save the updated task to NSUserDefaults with the helper method saveTasks. Reload the tableView with the updated information */
-(void)updateGoal
{
    [self saveGoals];
    [self.tableView reloadData];
}

#pragma mark - Helper Methods

/* Convert and return an NSDictionary of the taskObject */
-(NSDictionary *)goalObjectsAsAPropertyList:(FitnessGoal *)goalObject
{
    NSDictionary *dictionary = @{GOAL_NAME : goalObject.name, GOAL_DESCRIPTION : goalObject.desc, GOAL_DATE : goalObject.date, GOAL_ACHIEVED : @(goalObject.isAchieved) };
    return dictionary;
}

/* Convert a NSDictionary into a CCTask object and return it. Use the custom initializer we set setup in the CCTask.h file. */
-(FitnessGoal *)goalObjectForDictionary:(NSDictionary *)dictionary
{
    FitnessGoal *goalObject = [[FitnessGoal alloc] initWithData:dictionary];
    return goalObject;
}

/* Method returns a BOOL based on whether the first date parameter is greater than the second date parameter. To compare the two date parameters we convert the NSDates into NSTimeInterval's using the method timeIntervalSince1970. */
-(BOOL)isDateGreaterThanDate:(NSDate *)date and:(NSDate *)toDate
{
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    NSTimeInterval toDateInterval = [toDate timeIntervalSince1970];
    
    if (dateInterval > toDateInterval)
    {
        return YES;
    }
    else return NO;
}

/* The method has two parameters a CCTask and a NSIndexPath */
-(void)updateCompletionOfGoal:(FitnessGoal *)goal forIndexPath:(NSIndexPath *)indexPath
{
    /* Use NSUserDefaults to access all previously saved tasks. If there were not saved tasks we allocate and initialize the NSMutableArray named taskObjectsAsPropertyLists. */
    NSMutableArray *goalObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:GOAL_OBJECTS_KEY] mutableCopy];
    if (!goalObjectsAsPropertyLists) goalObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    /* Remove the old dictionary stored at the indexPath.row that the user wants to update */
    [goalObjectsAsPropertyLists removeObjectAtIndex:indexPath.row];
    
    /* Update the tasks completion from YES to NO or NO to YES based on the current status of the completion. */
    if(goal.isAchieved == YES) goal.isAchieved = NO;
    else goal.isAchieved = YES;
    
    /* Convert the updated taskObject into a property list. Insert it into the array at the same location that we just removed the old task object from */
    [goalObjectsAsPropertyLists insertObject:[self goalObjectsAsAPropertyList:goal] atIndex:indexPath.row];
    
    /* Save the updated array to NSUserDefaults. */
    [[NSUserDefaults standardUserDefaults] setObject:goalObjectsAsPropertyLists forKey:GOAL_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /* Reload the tableView with the updated task. This works because the task we updated is stored in the heap. So updating it here updates it in the array of task objects. */
    [self.tableView reloadData];
}

-(void)saveGoals
{
    /* Create a NSMutableArray that we will NSDictionaries returned from the method taskObjectAsAPropertyList. */
    NSMutableArray *goalObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    for (int x = 0; x < [self.goalObjects count]; x ++){
        for (int x = 0; x < [self.goalObjectsWeekTwo count]; x ++){
            for (int x = 0; x < [self.goalObjectsWeekThree count]; x ++){
        [goalObjectsAsPropertyLists addObject:[self goalObjectsAsAPropertyList:self.goalObjects[x]]];
    [goalObjectsAsPropertyLists addObject:[self goalObjectsAsAPropertyList:self.goalObjectsWeekTwo[x]]];
                [goalObjectsAsPropertyLists addObject:[self goalObjectsAsAPropertyList:self.goalObjectsWeekThree[x]]];
            }
        }
    }
    
    /* Save the updated array to NSUserDefaults. */
    [[NSUserDefaults standardUserDefaults] setObject:goalObjectsAsPropertyLists forKey:GOAL_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /* The number of rows should be the number of task's in the taskObjects Array */
    if(section == 0){
    return [self.goalObjects count];
    }
    else if(section == 1) {
        return [self.goalObjectsWeekTwo count];
    }
    else if(section == 2){
        return [self.goalObjectsWeekThree count];
    }
    else{
        return [self.goalObjectsWeekFour count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* We will only have 1 section for now */
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"7 Day Outlook";
    }
    else if(section == 1){
        return @"14 Day Outlook";
    }
    else if(section == 2){
        return @"21+ Day Outlook";
    }
    else{
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.textLabel.shadowColor = [UIColor blackColor];
    header.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    header.contentView.backgroundColor = [UIColor colorWithRed:42.0f / 255.0f green:184.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    self.goalCell = cell;
    FitnessGoal *goal = [[FitnessGoal alloc]init];
    //Configure the cell...
    
    /* Determine which task object should be displayed for the specific indexPath.row. */
    if(indexPath.section == 0){
        goal = self.goalObjects[indexPath.row];
        cell.textLabel.text = goal.name;
    }
    
    else if(indexPath.section == 1){
        goal = self.goalObjectsWeekTwo[indexPath.row];
        cell.textLabel.text = goal.name;
    }
    
    else if(indexPath.section == 2){
        goal = self.goalObjectsWeekThree[indexPath.row];
        cell.textLabel.text = goal.name;
    }
    
    else{
        goal = self.goalObjectsWeekFour[indexPath.row];
        cell.textLabel.text = goal.name;
    }
    
    UIFont *textFont = [UIFont fontWithName:@"optima" size:12];
    [cell.textLabel setFont:textFont];
    /* Create a NSDateFormatter Object. Set the formatting type to include year, month and day. Use the formatter to convert the NSDate to an NSString.*/
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:goal.date];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    //NSString *theTime = [timeFormat stringFromDate:goal.date];
    //NSLog(@"%@", theTime);
    /* Update the detailTextLabel with the date string */
    cell.detailTextLabel.text = stringFromDate;
    [cell.detailTextLabel setFont:textFont];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components: NSDayCalendarUnit
                                           fromDate: [NSDate date]
                                             toDate: goal.date
                                            options: 0];
    NSInteger days = [comps day];
    /* Update the coloring of the cell's background if the task isCompleted, isOverdue or simply pending. */
    if (goal.isAchieved == YES)
    {
        cell.backgroundColor = [UIColor greenColor];
    }
    
    else if (days < 2 && self.isOverDue == YES)
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    else if(days < 2)
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor yellowColor];
        cell.detailTextLabel.textColor = [UIColor yellowColor];
    }
    
    
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel sizeToFit];
    
    CGRect myFrame = cell.textLabel.frame;
    // Resize the frame's width to 280 (320 - margins)
    // width could also be myOriginalLabelFrame.size.width
    myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, 320, myFrame.size.height);
    cell.textLabel.frame = myFrame;

    return cell;
}

#pragma mark - UITableViewDelegate

/* When the user taps a cell in the tableView the task's isCompleted status should update. Use the helper method updateCompletionOfTask. */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FitnessGoal *goal = [[FitnessGoal alloc]init];
    if(indexPath.section == 0){
    goal = self.goalObjects[indexPath.row];
    }
    else if(indexPath.section == 1){
        goal = self.goalObjectsWeekTwo[indexPath.row];
    }
    else if(indexPath.section == 2){
        goal = self.goalObjectsWeekThree[indexPath.row];
    }
    /*else{
        goal = self.goalObjectsWeekFour[indexPath.row];
    }*/
    [self updateCompletionOfGoal:goal forIndexPath:indexPath];
}

/* Allow the user to edit tableViewCells for deletion */
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/* Method called when the users swipes and presses the delete key */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 0){
        /* If a user deletes the row remove the task at that row from the tasksArray */
        [self.goalObjects removeObjectAtIndex:indexPath.row];
    }
    
    else if(editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 1){
        [self.goalObjectsWeekTwo removeObjectAtIndex:indexPath.row];
    }
    else if(editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 2){
        [self.goalObjectsWeekThree removeObjectAtIndex:indexPath.row];
    }
    else if(editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 3){
        [self.goalObjectsWeekFour removeObjectAtIndex:indexPath.row];
    }
        /* With the updated array of task objects iterate over them and convert them to plists. Save the plists in the newTaskObjectsData NSMutableArray. Save this array to NSUserDefaults. */
        NSMutableArray *newGoalObjectsData = [[NSMutableArray alloc] init];
        
        for (FitnessGoal *goal in self.goalObjects){
            [newGoalObjectsData addObject:[self goalObjectsAsAPropertyList:goal]];
        }
    
        [[NSUserDefaults standardUserDefaults] setObject:newGoalObjectsData forKey:GOAL_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /* Animate the deletion of the cell */
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

/* When the user taps the accessory button transition to the DetailTaskViewController */
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetailTaskViewControllerSegue" sender:indexPath];
}

/* Allow the user to move cells in the tableView */
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/* Method called when the user moves a cell while in editing mode */
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    /* Determine which task was moved and update the taskObjects array by remove the object from it's old index and inserting it at it's new index. Save the updated taskObjects array to NSUserDefaults using the helper method saveTasks */
    NSIndexPath *path = [[NSIndexPath alloc]init];
    FitnessGoal *goalObject = [[FitnessGoal alloc]init];
    if(path.section == 0){
        goalObject = self.goalObjects[sourceIndexPath.row];
        [self.goalObjects removeObjectAtIndex:sourceIndexPath.row];
        [self.goalObjects insertObject:goalObject atIndex:destinationIndexPath.row];
    }
    else if(path.section == 1){
        goalObject = self.goalObjectsWeekTwo[sourceIndexPath.row];
        [self.goalObjectsWeekTwo removeObjectAtIndex:sourceIndexPath.row];
        [self.goalObjectsWeekTwo insertObject:goalObject atIndex:destinationIndexPath.row];
    }
    else if(path.section == 2){
        goalObject = self.goalObjectsWeekThree[sourceIndexPath.row];
        [self.goalObjectsWeekThree removeObjectAtIndex:sourceIndexPath.row];
        [self.goalObjectsWeekThree insertObject:goalObject atIndex:destinationIndexPath.row];
    }
    [self saveGoals];
}

- (CALayer *)gradientBGLayerForBounds:(CGRect)bounds
{
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = bounds;
    gradientBG.colors = [NSArray arrayWithObjects:
                         (id)[[UIColor colorWithRed:42.0f / 255.0f green:184.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:31.0f / 255.0f green:130.0f / 255.0f blue:190.0f / 255.0f alpha:1.0f] CGColor],
                         nil];
    return gradientBG;
}

@end
