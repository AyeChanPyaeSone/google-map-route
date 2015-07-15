//
//  PageMenuViewContoller.m
//  RouteMap
//
//  Created by AyeChan PyaeSone on 16/7/15.
//  Copyright (c) 2015 com.acps. All rights reserved.
//

#import "PageMenuViewContoller.h"
#import "CAPSPageMenu.h"
#import "TestViewController.h"

@interface PageMenuViewContoller ()
@property (nonatomic) CAPSPageMenu *pageMenu;
@end

@implementation PageMenuViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    TestViewController *controller1 = [[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
    controller1.title = @"FRIENDS";
    TestViewController *controller2 = [[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
    controller2.title = @"MOOD";
   
    
    NSArray *controllerArray = @[controller1, controller2];
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:nil];
    [self.view addSubview:_pageMenu.view];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

