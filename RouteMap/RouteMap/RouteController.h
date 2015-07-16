//
//  RouteController.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <AFNetworking.h>
@import GoogleMaps;


typedef enum tagTravelMode
{
    TravelModeDriving,
    TravelModeBicycling,
    TravelModeTransit,
    TravelModeWalking
}TravelMode;

typedef void (^SuccessBlock)(GMSPolyline *polyline);
typedef void (^FailBlock)(NSError *error);
typedef void (^ProgressBlock)(NSUInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead);

@interface RouteController : NSObject

+ (void)getPolylineWithLocations:(NSArray *)locations travelMode:(TravelMode)travelMode success:(SuccessBlock)success fail:(FailBlock)fail;
//+ (void)getPolylineWithLocations:(NSArray *)locations success:(SuccessBlock)success fail:(FailBlock)fail;
- (void)abortRequest;


@end
