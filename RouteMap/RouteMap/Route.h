//
//  Route.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface Route : NSObject

@property (nonatomic, retain) NSDictionary* arrival_time;
@property (nonatomic, retain) NSDictionary* departure_time;
@property (nonatomic, retain) NSDictionary* distance;
@property (nonatomic, retain) NSDictionary* duration;
@property (nonatomic, retain) NSDictionary* steps;
@end