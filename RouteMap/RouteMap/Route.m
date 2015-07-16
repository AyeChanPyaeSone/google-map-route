//
//  Route.m
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//
#import "Route.h"
#import "Steps.h"

@implementation Route

-(Class)rm_itemClassForArrayProperty:(NSString *)property {
    if([property isEqualToString:@"steps"]) {
        return [Steps class];
    }
    return nil;
}

@end
