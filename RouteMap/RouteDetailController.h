//
//  RouteDetailController.h
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *routeDetailTableView;
@property (weak, nonatomic) NSArray *steps;
@end
