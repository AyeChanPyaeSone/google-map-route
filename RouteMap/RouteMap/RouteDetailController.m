//
//  RouteDetailController.m
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import "RouteDetailController.h"
#import "WalkRouteDetailCell.h"
#import "Steps.h"

@interface RouteDetailController ()

@end

@implementation RouteDetailController
NSMutableArray *steps;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    steps = [[NSMutableArray alloc]init];
    for(Steps *step in self.steps){
        [steps addObject:step];
    }
    
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
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Steps *step = steps[indexPath.row];
    if([step.travel_mode  isEqual: @"WALKING"]){
        static NSString *cellIdentifier = @"WalkRouteDetailCell";
        WalkRouteDetailCell *walkrouteDetailCell = (WalkRouteDetailCell *)[self.routeDetailTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        walkrouteDetailCell.html_instructions_label.text = step.html_instructions;
        walkrouteDetailCell.distance_time_label.text = [NSString stringWithFormat:@"%@ ( %@ ) ",[step.distance objectForKey:@"text"],[step.duration objectForKey:@"text"]];
        
        return walkrouteDetailCell;

    }
    else if([step.travel_mode  isEqual: @"TRANSIT"]){
        static NSString *cellIdentifier = @"WalkRouteDetailCell";
        WalkRouteDetailCell *walkrouteDetailCell = (WalkRouteDetailCell *)[self.routeDetailTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        walkrouteDetailCell.html_instructions_label.text = step.html_instructions;
        walkrouteDetailCell.distance_time_label.text = [NSString stringWithFormat:@"%@ ( %@ ) ",[step.distance objectForKey:@"text"],[step.duration objectForKey:@"text"]];
        
        return walkrouteDetailCell;
        
    }
    static NSString *cellIdentifier = @"WalkRouteDetailCell";
    WalkRouteDetailCell *walkrouteDetailCell = (WalkRouteDetailCell *)[self.routeDetailTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    walkrouteDetailCell.html_instructions_label.text = step.html_instructions;
    walkrouteDetailCell.distance_time_label.text = [NSString stringWithFormat:@"%@ ( %@ ) ",[step.distance objectForKey:@"text"],[step.duration objectForKey:@"text"]];
    
    return walkrouteDetailCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


@end

