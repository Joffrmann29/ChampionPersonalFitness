//
//  FitnessGoal.m
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import "FitnessGoal.h"

@implementation FitnessGoal

/* Designated Initializer */
-(id)initWithData:(NSDictionary *)data
{
    /* Designated Initializer must call the super classes initialization method */
    self = [super init];
    
    /* Setup the object with values from the NSDictionary */
    if (self){
        self.name = data[GOAL_NAME];
        self.desc = data[GOAL_DESCRIPTION];
        self.date = data[GOAL_DATE];
        self.isAchieved = [data[GOAL_ACHIEVED] boolValue];
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
