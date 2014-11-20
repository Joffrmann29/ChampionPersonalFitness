//
//  FitnessProfile.m
//  FitnessTracker
//
//  Created by Administrator on 7/6/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import "FitnessProfile.h"

@implementation FitnessProfile

-(id)initWithData:(NSDictionary *)data
{
    /* Designated Initializer must call the super classes initialization method */
    self = [super init];
    NSString *IDToFetch = [PFUser currentUser].objectId;
    PFQuery *query = [PFUser query];
    [query whereKey:@"user_id" equalTo:IDToFetch];
    NSLog(@"%@", IDToFetch);
    PFUser *foundUser = [PFUser currentUser];
    /* Setup the object with values from the NSDictionary */
    if (self){
        self.firstName = foundUser[@"Name"];
        self.age = [foundUser[@"Age"]intValue];
        self.height = [foundUser[@"Height"]intValue];
        self.weight = [foundUser[@"Weight"]intValue];
        self.bodyMass = [foundUser[@"BMI"]floatValue];
        self.file = foundUser[USERPROFILEIMAGE];
        [foundUser saveEventually];
    }
    
    return self;
}

/* Default initializer calls the new designated initializer initWithData */
-(id)init
{
    self = [self initWithData:nil];
    return self;
}

@end
