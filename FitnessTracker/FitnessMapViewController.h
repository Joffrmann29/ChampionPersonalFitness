//
//  FitnessMapViewController.h
//  FitnessTracker
//
//  Created by Administrator on 6/15/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FitnessMapViewController : UIViewController<MKMapViewDelegate,MKAnnotation,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *destinationText;
@property (strong, nonatomic) NSString *nameText;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)back:(UIBarButtonItem *)sender;
- (IBAction)Reroute:(UIBarButtonItem *)sender;

@end
