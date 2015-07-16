//
//  BusRouteDetailCell.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BusRouteDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *html_instructions;
@property (weak, nonatomic) IBOutlet UILabel *startbustop_name;
@property (weak, nonatomic) IBOutlet UILabel *endbustop_name;
@property (weak, nonatomic) IBOutlet UILabel *stops_time;

@end

