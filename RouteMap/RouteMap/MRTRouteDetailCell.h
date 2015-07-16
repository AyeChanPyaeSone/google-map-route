//
//  MRTRouteDetailCell.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRTRouteDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startstation_name;
@property (weak, nonatomic) IBOutlet UILabel *html_instructions;
@property (weak, nonatomic) IBOutlet UILabel *stops_mins;
@property (weak, nonatomic) IBOutlet UILabel *endstation_name;

@end
