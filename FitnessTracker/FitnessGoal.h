//
//  FitnessGoal.h
//  FitnessTracker
//
//  Created by Administrator on 6/13/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GOAL_NAME @"Goal Name"
#define GOAL_DATE @"Goal Date"
#define GOAL_DESCRIPTION @"Goal Description"
#define GOAL_ACHIEVED @"Goal Achieved"

@interface FitnessGoal : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL isAchieved;

/* Custom Initializer which has a single parameter of class NSDictionary. */
-(id)initWithData:(NSDictionary *)data;

@end
