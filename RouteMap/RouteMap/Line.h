//
//  Line.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"
#import "Vehicle.h"

@interface Line : NSObject

@property (nonatomic, retain) NSDictionary* agencies;
@property (nonatomic, retain) NSString* color;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* short_name;
@property (nonatomic, retain) Vehicle* vehicle;

@end


