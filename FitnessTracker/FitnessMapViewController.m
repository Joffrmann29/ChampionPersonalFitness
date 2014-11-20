//
//  FitnessMapViewController.m
//  FitnessTracker
//
//  Created by Administrator on 6/15/14.
//  Copyright (c) 2014 Joffrey Mann. All rights reserved.
//

#import "FitnessMapViewController.h"
#include <dispatch/dispatch.h>

@interface FitnessMapViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSString *preString;
@property (nonatomic, assign) int intValue;
@property (nonatomic, assign)int intValue2;
@property (nonatomic, assign) float projectedCalories;
@property (nonatomic, assign) float distanceInMiles;
@property (nonatomic, assign) int finalCalorieCount;
@property (nonatomic, assign) float distanceMeters;
@property (nonatomic, assign) float stepsInMile;
@property (nonatomic, assign) float caloriesPerStep;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float longi;
@property (nonatomic, strong) CLLocation *loc;
@property (nonatomic, strong) CLLocation *pointBLocation;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLLocationCoordinate2D there;
@property (strong, nonatomic) NSString *allSteps;
@property (strong, nonatomic) UIAlertView *destinationAlert;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) UIAlertView *invalidDestAlert;
@property (nonatomic, strong) UIAlertView *calorieAlert;


@end

@implementation FitnessMapViewController

CLPlacemark *thePlacemark;
MKRoute *routeDetails;

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
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    [self zoomToCurrentLocation];
    
    [self showDestinationAlert];
    [self.navBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Zapfino" size:17],
      NSFontAttributeName, nil]];
    
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"ChampionNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == _destinationAlert)
    {
        if(buttonIndex == 1)
        {
            [self addressSearch:alertView];
        }
    }
    
    else if(alertView == _calorieAlert)
    {
        if(buttonIndex == 0)
        {
            //[self performSegueWithIdentifier:@"toRouteView" sender:nil];
            //[self routeMap];
        }
        
    }
    
    else if(alertView == _invalidDestAlert)
    {
        if(buttonIndex == 0)
        {
            [self showDestinationAlert];
        }
    }
}

-(void)routeMap
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //
    //NSString *addressString = @"3410 Camp Creek Pkwy 30349";
    [geocoder geocodeAddressString:_destinationText completionHandler:^(NSArray *placemarks, NSError *error) {
        __block int finalC;
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            _location = placemark.location;
            _there = _location.coordinate;
            MKPlacemark *destPlace = [[MKPlacemark alloc] initWithCoordinate:_there addressDictionary:nil];
            MKMapItem *destMapItem = [[MKMapItem alloc] initWithPlacemark:destPlace];
            destMapItem.name = _destinationText;
            _lat = 33.645;
            _longi = -84.556;
            _loc = [[CLLocation alloc]initWithLatitude:_lat longitude:_longi];
            _pointBLocation = [[CLLocation alloc] initWithLatitude:_location.coordinate.latitude longitude:_location.coordinate.longitude];
            _distanceMeters = [_loc distanceFromLocation:_pointBLocation];
            _distanceInMiles = (_distanceMeters / 1209.344);
            _stepsInMile = 5280;
            _caloriesPerStep = .0321;
            _projectedCalories = _stepsInMile * _caloriesPerStep;
            _intValue = (int)ceil(_projectedCalories);
            _intValue2 = (int)ceil(_distanceInMiles);
            _finalCalorieCount = _intValue * _intValue2;
            finalC = _finalCalorieCount;
            NSArray* mapItems = [[NSArray alloc] initWithObjects: destMapItem, nil];
            NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsDirectionsModeKey, nil];
            [MKMapItem openMapsWithItems:mapItems launchOptions:options];
        }
    }];
}

-(void)showDestinationAlert
{
    _destinationAlert = [[UIAlertView alloc]initWithTitle:@"Enter New Destination" message:@"Enter your new jogging destination" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [_destinationAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [_destinationAlert show];
}

- (void)addAnnotation:(CLPlacemark *)placemark {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
    point.title = [placemark.addressDictionary objectForKey:@"Street"];
    point.subtitle = [placemark.addressDictionary objectForKey:@"City"];
    [self.mapView addAnnotation:point];
    [self getDirections];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)getDirections
{
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:thePlacemark];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeWalking;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            routeDetails = response.routes.lastObject;
            [self.mapView addOverlay:routeDetails.polyline];
//            NSString *destString = [placemark.addressDictionary objectForKey:@"Street"];
//            NSString *distanceString = [NSString stringWithFormat:@"%0.1f Miles", routeDetails.distance/1609.344];
//            NSString *transportText = [NSString stringWithFormat:@"%u" ,routeDetails.transportType];
            float distance = routeDetails.distance/1609.344;
            float distanceInSteps = distance * 5280;
            _projectedCalories = distanceInSteps * .0321;
            self.allSteps = @"";
            for (int i = 0; i < routeDetails.steps.count; i++) {
                MKRouteStep *step = [routeDetails.steps objectAtIndex:i];
                NSString *newStep = step.instructions;
                self.allSteps = [self.allSteps stringByAppendingString:newStep];
                self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
            }
            [self showAlertWithInt:_projectedCalories];
        }
        NSLog(@"%@", routeDetails.steps);
    }];
}

-(void)showAlertWithInt:(int)calories
{
    calories = _projectedCalories;
    NSString *preString = [NSString stringWithFormat:@"Your next fitness goal is to burn %i calories",calories];

    _calorieAlert = [[UIAlertView alloc]initWithTitle:@"Your Next Goal!" message:preString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [_calorieAlert dismissWithClickedButtonIndex:1 animated:NO];
    [_calorieAlert show];
    [self zoomToCurrentLocation];
}

- (NSString *)addressSearch:(UIAlertView *)alertView
{
    _alert = alertView;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    _destinationText = [alertView textFieldAtIndex:0].text;

    [geocoder geocodeAddressString:_destinationText completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            _invalidDestAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enter a valid destination" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [_invalidDestAlert dismissWithClickedButtonIndex:1 animated:NO];
            [_invalidDestAlert show];
        } else {
            thePlacemark = [placemarks lastObject];
            float spanX = 1.00725;
            float spanY = 1.00725;
            MKCoordinateRegion region;
            region.center.latitude = thePlacemark.location.coordinate.latitude;
            region.center.longitude = thePlacemark.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
            [self addAnnotation:thePlacemark];
        }
    }];
    return _destinationText;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //self.searchButton.hidden = NO;
}

- (void)zoomToCurrentLocation
{
    float spanX = 0.01725;
    float spanY = 0.01725;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)routeBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self showDestinationAlert];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Reroute:(UIBarButtonItem *)sender
{
    [self showDestinationAlert];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     
 }
 

@end
