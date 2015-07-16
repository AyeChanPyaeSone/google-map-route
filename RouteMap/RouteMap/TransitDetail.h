//
//  TransitDetail.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailSteps.h"
#import "Line.h"
@interface TransitDetail : NSObject

@property (nonatomic, retain) NSDictionary* arrival_stop;
@property (nonatomic, retain) NSDictionary* arrival_time;
@property (nonatomic, retain) NSDictionary* departure_stop;
@property (nonatomic, retain) NSDictionary* departure_time;
@property (nonatomic, retain) NSString* headsign;
@property (nonatomic, retain) NSString* headway;
@property (nonatomic, retain) NSString* num_stops;
@property (nonatomic, retain) Line* line;

@end
