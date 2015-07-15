//
//  ViewController.m
//  RouteMap
//
//  Created by Kyaw Myint Thein on 7/14/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import "ViewController.h"
#import <INTULocationManager/INTULocationManager.h>
#import <SMCalloutView/SMCalloutView.h>
#import <GoogleMaps/GoogleMaps.h>
#import "KLCPopup.h"
#import <QuartzCore/QuartzCore.h>
#import "Colours.h"
#import "MapFilterViewController.h"
#import "MZFormSheetPresentationController.h"
#import "MZFormSheetPresentationControllerSegue.h"
#import "RouteMap-Swift.h"
#import "GMDirectionService.h"
@import CoreLocation;
@import GoogleMaps;

static NSString * const TitleKey = @"title";
static NSString * const InfoKey = @"info";
static NSString * const LatitudeKey = @"latitude";
static NSString * const LongitudeKey = @"longitude";

static const CGFloat CalloutYOffset = 50.0f;

/* Paris */
static const CLLocationDegrees DefaultLatitude = 1.3000;
static const CLLocationDegrees DefaultLongitude = 103.8000;
static const CGFloat DefaultZoom = 11.0f;
@interface ViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>
    @property (strong, nonatomic) IBOutlet GMSMapView *mapView;
    @property (nonatomic, retain) CLLocationManager *locationManager;
    @property (nonatomic, retain) CLLocation *currentLocation;
    @property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
    @property (strong, nonatomic) UIView *emptyCalloutView;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MZFormSheetPresentationController appearance] setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.3]];
    
    self.title = @"Map Demo";
    self.calloutView = [[SMCalloutView alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [leftButton addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];

    _headerView.backgroundColor = [UIColor tealColor];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager requestAlwaysAuthorization];
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addLatitude:-33.866 longitude:151.195]; // Sydney
    [path addLatitude:-18.142 longitude:178.431]; // Fiji
    [path addLatitude:21.291 longitude:-157.821]; // Hawaii
    [path addLatitude:37.423 longitude:-122.091]; // Mountain View
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = _mapView;

    [[GMDirectionService sharedInstance] getDirectionsFrom:@"130023" to:@"310023" succeeded:^(GMDirection *directionResponse) {
        NSLog(@"Duration : %@", [directionResponse durationHumanized]);
        NSLog(@"Distance : %@", [directionResponse distanceHumanized]);
        NSArray *routes = [[directionResponse directionResponse] objectForKey:@"routes"];
        NSLog(@"route %@",routes);
    } failed:^(NSError *error) {
        NSLog(@"Can't reach the server");
    }];

    
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    
    self.calloutView.rightAccessoryView = button;
    self.calloutView.leftAccessoryView = leftButton;
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:DefaultLatitude
                                                                    longitude:DefaultLongitude
                                                                         zoom:DefaultZoom];

    _mapView.camera = cameraPosition;
    self.mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];
    
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addMarkersToMap];
}

- (void) mapView: (GMSMapView *) mapView  idleAtCameraPosition: (GMSCameraPosition *)   position {
    NSLog(@"TAPPED LOCATION");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     NSLog(@"%@", [locations lastObject]);
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}



- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self.mapView removeFromSuperview];
    self.mapView = nil;
    
    self.emptyCalloutView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMarkersToMap {
    NSArray *markerInfos = @[
                             @{
                                 TitleKey: @"Eiffel Tower",
                                 InfoKey: @"A wrought-iron structure erected in Paris in 1889. With a height of 984 feet (300 m), it was the tallest man-made structure for many years.",
                                 LatitudeKey: @1.331422,
                                 LongitudeKey: @103.93646
                                 },
                             @{
                                 TitleKey: @"Centre Georges Pompidou",
                                 InfoKey: @"Centre Georges Pompidou is a complex in the Beaubourg area of the 4th arrondissement of Paris. It was designed in the style of high-tech architecture.",
                                 LatitudeKey: @44.967021,
                                 LongitudeKey: @19.597954
                                 },
                             @{
                                 TitleKey: @"The Louvre",
                                 InfoKey: @"The principal museum and art gallery of France, in Paris.",
                                 LatitudeKey: @1.31495,
                                 LongitudeKey: @103.909332
                                 }
                             ];
    
    UIImage *pinImage = [UIImage imageNamed:@"Pin"];
    
    for (NSDictionary *markerInfo in markerInfos) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        marker.position = CLLocationCoordinate2DMake([markerInfo[LatitudeKey] doubleValue], [markerInfo[LongitudeKey] doubleValue]);
        marker.title = markerInfo[TitleKey];
        marker.icon = pinImage;
        marker.userData = markerInfo;
        marker.infoWindowAnchor = CGPointMake(0.5, 0.25);
        marker.groundAnchor = CGPointMake(0.5, 1.0);
        
        marker.map = self.mapView;
    }
    
    GMSMarker *marker1 = [[GMSMarker alloc] init];
    
    marker1.position = CLLocationCoordinate2DMake(self.mapView.myLocation.coordinate.latitude,self.mapView.myLocation.coordinate.longitude);
    marker1.title = @"Me";
    marker1.icon = pinImage;
    marker1.userData = @"My current locaiton";
    marker1.infoWindowAnchor = CGPointMake(0.5, 0.25);
    marker1.groundAnchor = CGPointMake(0.5, 1.0);
    marker1.map = self.mapView;
}


- (void)calloutAccessoryButtonTapped:(id)sender {
    if (self.mapView.selectedMarker) {
        
        GMSMarker *marker = self.mapView.selectedMarker;
        NSDictionary *userData = marker.userData;
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:userData[TitleKey]
//                                                            message:userData[InfoKey]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
        [self showDetailPopup];
        
    }
}

#pragma mark - GMSMapViewDelegate

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    
    self.calloutView.title = marker.title;
    
    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
    
    self.calloutView.hidden = NO;
    
    CGRect calloutRect = CGRectZero;
    calloutRect.origin = point;
    calloutRect.size = CGSizeZero;
    
    [self.calloutView presentCalloutFromRect:calloutRect
                                      inView:mapView
                           constrainedToView:mapView
                                    animated:YES];
    
    return self.emptyCalloutView;
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position {
    /* move callout with map drag */
    if (pMapView.selectedMarker != nil && !self.calloutView.hidden) {
        CLLocationCoordinate2D anchor = [pMapView.selectedMarker position];
        
        CGPoint arrowPt = self.calloutView.backgroundView.arrowPoint;
        
        CGPoint pt = [pMapView.projection pointForCoordinate:anchor];
        pt.x -= arrowPt.x;
        pt.y -= arrowPt.y + CalloutYOffset;
        
        self.calloutView.frame = (CGRect) {.origin = pt, .size = self.calloutView.frame.size };
    } else {
        self.calloutView.hidden = YES;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.calloutView.hidden = YES;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    /* don't move map camera to center marker on tap */
    mapView.selectedMarker = marker;
    return YES;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [_locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}
- (IBAction)showFilterView:(id)sender {
    MapFilterViewController *mapFilterVC = [[MapFilterViewController alloc] init];
    MZFormSheetPresentationController *formSheetController = [[MZFormSheetPresentationController alloc] initWithContentViewController:mapFilterVC];
//    formSheetController.shouldApplyBackgroundBlurEffect = YES;
  //  formSheetController.blurEffectStyle = UIBlurEffectStyleExtraLight;
    formSheetController.shouldDismissOnBackgroundViewTap = YES;
    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideFromTop;
     formSheetController.contentViewSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - 150);
    formSheetController.contentViewController.view.frame = CGRectMake(0, 105, formSheetController.contentViewSize.width, formSheetController.contentViewSize.height);
         __weak MZFormSheetPresentationController *weakController = formSheetController;
    formSheetController.willPresentContentViewControllerHandler = ^(UIViewController *a) {
        weakController.contentViewController.view.layer.masksToBounds = NO;
        
        CALayer *layer = weakController.contentViewController.view.layer;
        
        [layer setShadowOffset:CGSizeMake(0, 3)];
        [layer setShadowOpacity:0.8];
        [layer setShadowRadius:3.0f];
        
        [layer setShadowPath:
         [[UIBezierPath bezierPathWithRoundedRect:[weakController.contentViewController.view bounds]
                                     cornerRadius:12.0f] CGPath]];
    };
    
    [self presentViewController:formSheetController animated:YES completion:nil];
//    [self presentViewController:formSheetController animated:YES completion:nil];
}

-(void)showDetailPopup{
   // rgb(242, 242, 242)
   UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 60, self.view.bounds.size.width - 5, self.view.bounds.size.height - 100)];
    view.backgroundColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1] ;
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    // Show in popup
    KLCPopupLayout layout =  KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBelowCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:view showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupShowTypeBounceInFromTop maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    
        [popup showWithLayout:layout];


}



-(void)drawRuote{
}
@end
