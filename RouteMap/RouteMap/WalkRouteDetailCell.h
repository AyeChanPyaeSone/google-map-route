//
//  RouteDetailCell.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WalkRouteDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *html_instructions_label;
@property (weak, nonatomic) IBOutlet UILabel *distance_time_label;
@property (weak, nonatomic) IBOutlet UILabel *your_locations;
@end
