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
    
    if(indexPath.row==0){
         return 95;
    }
    else if([step.travel_mode  isEqual: @"WALKING"]){
        
        return 65;
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
        
        if(indexPath.row>0){
            walkrouteDetailCell.your_locations.text = step.html_instructions;
            walkrouteDetailCell.html_instructions_label.text = [NSString stringWithFormat:@"%@ ( %@ ) ",[step.distance objectForKey:@"text"],[step.duration objectForKey:@"text"]];
             walkrouteDetailCell.distance_time_label.text=@"";
            
        }
        else{
            
            walkrouteDetailCell.html_instructions_label.text = step.html_instructions;
            walkrouteDetailCell.distance_time_label.text = [NSString stringWithFormat:@"%@ ( %@ ) ",[step.distance objectForKey:@"text"],[step.duration objectForKey:@"text"]];
        }
       
        
        return walkrouteDetailCell;

    }
    else if([step.travel_mode  isEqual: @"TRANSIT"]){
        
        if([step.transit_details.line.vehicle.type  isEqual: @"SUBWAY"]){
            

            static NSString *cellIdentifier = @"MRTRouteDetailCell";
            MRTRouteDetailCell *mrtrouteDetailCell = (MRTRouteDetailCell *)[self.routeDetailTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            if([step.transit_details.line.name isEqual:@"East West Line"]){
                mrtrouteDetailCell.mrtline_image.image= [UIImage imageNamed:@"EW"];
            }
            else if([step.transit_details.line.name isEqual:@"North South Line"]){
                mrtrouteDetailCell.mrtline_image.image= [UIImage imageNamed:@"NS"];
            }
            else if([step.transit_details.line.name isEqual:@"North East Line"]){
                mrtrouteDetailCell.mrtline_image.image= [UIImage imageNamed:@"NE"];
            }
            else if([step.transit_details.line.name isEqual:@"Circle Line"]){
                mrtrouteDetailCell.mrtline_image.image= [UIImage imageNamed:@"CC"];
            }
            else if([step.transit_details.line.name isEqual:@"Downtown Line"]){
                mrtrouteDetailCell.mrtline_image.image= [UIImage imageNamed:@"DT"];
                
            }
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
            
            busrouteDetailCell.bus_number.layer.borderColor = [UIColor blackColor].CGColor;
            busrouteDetailCell.bus_number.layer.borderWidth = 1.0;
            busrouteDetailCell.bus_number.text = step.transit_details.line.short_name;
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
    
//    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ActivityDetailViewController *activityVC = [mainSb instantiateViewControllerWithIdentifier:@"ActivityDetailView"];
//    if (indexPath.row <= self.localActivities.count) {
//        activityVC.selectedActivity = self.localActivities[indexPath.row];
//        
//        [self.navigationController pushViewController:activityVC animated:YES];
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    }
}


@end

