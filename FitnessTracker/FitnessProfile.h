//
//  FitnessProfile.h
//  FitnessTracker
//
//  Created by Administrator on 7/6/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

#define fNAME @"FirstName"
#define lName @"LastName"
#define AGE @"Age"
#define HEIGHT @"Height"
#define WEIGHT @"Weight"
#define BMI @"BMI"


@interface FitnessProfile : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (nonatomic) int age;
@property (nonatomic) int height;
@property (nonatomic) int weight;
@property (nonatomic) float bodyMass;
@property (strong, nonatomic) PFFile *file;

-(id)initWithData:(NSDictionary *)data;


@end
