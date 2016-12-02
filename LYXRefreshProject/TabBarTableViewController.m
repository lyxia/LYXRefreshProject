//
//  TabBarTableViewController.m
//  IOSAPILearn
//
//  Created by lyxia on 2016/12/1.
//  Copyright © 2016年 lyxia. All rights reserved.
//

#import "TabBarTableViewController.h"
#import "CuzTableViewController.h"

@interface TabBarTableViewController ()

@end

@implementation TabBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CuzTableViewController *tvc = [[CuzTableViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:tvc];
    nv.title = @"nv";
    
    [self addChildViewController:nv];
    [self.view addSubview:nv.view];
}

@end
