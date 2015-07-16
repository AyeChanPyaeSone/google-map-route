//
//  RouteDetailController.m
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import "RouteDetailController.h"
#import "WalkRouteDetailCell.h"
#import "MRTRouteDetailCell.h"
#import "BusRouteDetailCell.h"
#import "Steps.h"

@interface RouteDetailController ()

@end

@implementation RouteDetailController
NSMutableArray *steps;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    steps = [[NSMutableArray alloc]init];
    
    NSLog(@"Steps Count %lu",(unsigned long)[self.steps count]);
    for(Steps *step in self.steps){
        [steps addObject:step];
    }
    
    NSLog(@" Detail Steps Count %lu",(unsigned long)[steps count]);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return steps.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Steps *step = steps[indexPath.row];
    
    if([step.travel_mode  isEqual: @"WALKING"]){
        
        return 80;
    }
    else{
         return 120;
    }
     return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Steps *step = steps[indexPath.row];
    NSString *num_stops;
    WalkRouteDetailCell *walkrouteDetailCell;
    if([step.travel_mode  isEqual: @"WALKING"]){
        static NSString *cellIdentifier = @"WalkRouteDetailCell";
        WalkRouteDetailCell *walkrouteDetailCell = (WalkRouteDetailCell *)[self.routeDetailTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        walkrouteDetailCell.html_instructions_label.text = step.html_instructions;
        walkrouteDetailCell.distance_time_label.text = [NSString stringWithFormat:@"%@ ( %@ ) ",[step.distance objectForKey:@"text"],[step.duration objectForKey:@"text"]];
        
        return walkrouteDetailCell;

    }
    else if([step.travel_mode  isEqual: @"TRANSIT"]){
        
        if([step.transit_details.line.vehicle.type  isEqual: @"SUBWAY"]){
            

            static NSString *cellIdentifier = @"MRTRouteDetailCell";
            MRTRouteDetailCell *mrtrouteDetailCell = (MRTRouteDetailCell *)[self.routeDetailTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            mrtrouteDetailCell.html_instructions.text = step.html_instructions;
            mrtrouteDetailCell.startstation_name.text = [step.transit_details.departure_stop objectForKey:@"name"];
            mrtrouteDetailCell.endstation_name.text = [step.transit_details.arrival_stop objectForKey:@"name"];
            if([step.transit_details.num_stops intValue]>1){
                num_stops = @"stops";
            }
            else{
                num_stops = @"stop";
            }
            mrtrouteDetailCell.stops_mins.text = [NSString stringWithFormat:@"%@ %@ (%@)",step.transit_details.num_stops,num_stops,[step.duration objectForKey:@"text"]];

            
            return mrtrouteDetailCell;

        }
        else{
            static NSString *cellIdentifier = @"BusRouteDetailCell";
            BusRouteDetailCell *busrouteDetailCell = (BusRouteDetailCell *)[self.routeDetailTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            busrouteDetailCell.html_instructions.text = step.html_instructions;
            busrouteDetailCell.startbustop_name.text = [step.transit_details.departure_stop objectForKey:@"name"];
            busrouteDetailCell.endbustop_name.text = [step.transit_details.arrival_stop objectForKey:@"name"];
            
            if([step.transit_details.num_stops intValue]>1){
                num_stops = @"stops";
            }
            else{
                num_stops = @"stop";
            }
            
            busrouteDetailCell.stops_time.text = [NSString stringWithFormat:@"%@ %@ (%@)",step.transit_details.num_stops,num_stops,[step.duration objectForKey:@"text"]];
            
            return busrouteDetailCell;

        }
        
    }
    return walkrouteDetailCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


@end

