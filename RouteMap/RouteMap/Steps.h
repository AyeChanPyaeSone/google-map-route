//
//  Steps.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"
#import "DetailSteps.h"
#import "TransitDetail.h"
#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface Steps : NSObject

@property (nonatomic, retain) NSDictionary* distance;
@property (nonatomic, retain) NSDictionary* duration;
@property (nonatomic, retain) NSString* html_instructions;
@property (nonatomic, retain) NSDictionary* steps;
@property (nonatomic, retain) NSString* travel_mode;
@property (nonatomic, retain) TransitDetail* transit_details;
@end