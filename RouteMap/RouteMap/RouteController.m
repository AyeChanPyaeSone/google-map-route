//
//  RouteController.m
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#define kDirectionsURL @"http://maps.googleapis.com/maps/api/directions/json?"


#import "RouteController.h"
#import "RMMapper.h"
#import "Route.h"
#import "Steps.h"

@interface RouteController()
@end


@implementation RouteController
static AFHTTPRequestOperationManager* requestManager;

+(AFHTTPRequestOperationManager*)sharedRequestManager {
    return [RouteController sharedRequestManagerWithFormData:NO];
}

//because we can't send PUT JSON to server
//we have to send data-form format manager
//bug on 27/10/14
+(AFHTTPRequestOperationManager*)sharedRequestManagerWithFormData:(BOOL)isFormData {
    if (!requestManager) {
        NSURL* url;
        url = [NSURL URLWithString:kDirectionsURL];
        requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        
        //use different serializer for different format send: JSON or data-form format
        if (isFormData) {
            requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        } else {
            requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
        [requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        requestManager.securityPolicy.allowInvalidCertificates = NO;
        
    }
    
    return requestManager;
    
}


+ (void)getPolylineWithLocations:(NSArray *)locations travelMode:(TravelMode)travelMode success:(SuccessBlock)success fail:(FailBlock)fail{
      AFHTTPRequestOperationManager* manager = [RouteController sharedRequestManager];
    

    NSLog(@"In");
    NSUInteger locationsCount = [locations count];
    
    if (locationsCount < 2) return;
    
    NSMutableArray *locationStrings = [NSMutableArray new];
    
    for (CLLocation *location in locations)
    {
        [locationStrings addObject:[[NSString alloc] initWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude]];
    }
    
    NSString *sensor = @"false";
    NSString *origin = [locationStrings objectAtIndex:0];
    NSString *destination = [locationStrings lastObject];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@origin=%@&destination=%@&sensor=%@", kDirectionsURL, origin, destination, sensor];
    
    if (locationsCount > 2)
    {
        [url appendString:@"&waypoints=optimize:false"];
        for (int i = 1; i < [locationStrings count] - 1; i++)
        {
            [url appendFormat:@"|%@", [locationStrings objectAtIndex:i]];
        }
    }
    
    switch (travelMode)
    {
        case TravelModeWalking:
            [url appendString:@"&mode=walking"];
            break;
        case TravelModeBicycling:
            [url appendString:@"&mode=bicycling"];
            break;
        case TravelModeTransit:
            [url appendString:@"&mode=transit"];
            break;
        default:
            [url appendString:@"&mode=driving"];
            break;
    }
    
    url = [NSMutableString stringWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    
    [manager GET:url  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ((success)) {
            GMSPolyline *polyline;
            NSLog(@"responseobject %@",responseObject);
            NSArray *routesArray = [responseObject objectForKey:@"routes"];
            NSDictionary *steps =  [routesArray objectAtIndex:0];
            NSArray *arraysteps = [steps objectForKey:@"legs"];
            NSDictionary *dictsteps = [arraysteps objectAtIndex:0];

           // Steps* step = [RMMapper objectWithClass:[Steps class] fromDictionary:dictsteps[@"steps"]];
            
           NSArray* stepsArray= [RMMapper arrayOfClass:[Steps class] fromArrayOfDictionary:dictsteps[@"steps"]];
            
            for(Steps *step in stepsArray){
                NSLog(@"%@",step.html_instructions);
                NSLog(@"%lu",(unsigned long)[step.steps count]);
            }
            //NSLog(@"Route %@",route.html_instructions);
            
            NSLog(@"steps %@",dictsteps);
            
            
            if ([routesArray count] > 0)
            {
                NSDictionary *routeDict = [routesArray objectAtIndex:0];
                NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                GMSPath *path = [GMSPath pathFromEncodedPath:points];
                polyline = [GMSPolyline polylineWithPath:path];
                
            }
            else
            {
#if DEBUG
                if (locationsCount > 10)
                    NSLog(@"If you're using Google API's free service you will not get the route. Free service supports up to 8 waypoints + origin + destination.");
#endif          
                polyline =nil;
            }
            
            if (success) {
                success(polyline,stepsArray);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
           // [[self appDelegate] logout];
        }else{
            if (fail) {
                fail(error);
            }
        }
    }];
    
    
    
    
}

- (void)abortRequest
{
    //if (_request && [_request inProgress])
    //    [_request clearDelegatesAndCancel];
}


- (void)dealloc
{
    [self abortRequest];
}


@end
