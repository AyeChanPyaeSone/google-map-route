//
//  Steps.m
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//


#import "Steps.h"

@implementation Steps

-(Class)rm_itemClassForArrayProperty:(NSString *)property {
    if([property isEqualToString:@"steps"]) {
        return [DetailSteps class];
    }
    return nil;
}
@end