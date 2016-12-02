//
//  CuzTableViewController.m
//  IOSAPILearn
//
//  Created by lyxia on 2016/12/1.
//  Copyright © 2016年 lyxia. All rights reserved.
//

#import "CuzTableViewController.h"
#import "UIScrollView+Refresh.h"
#import "RefreshHeader.h"
#import "RefreshFooter.h"

@interface CuzTableViewController ()
@property (nonatomic, assign) int count;
@end

@implementation CuzTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 3;
    
    self.tableView.re_header = [[RefreshHeader alloc] init];
    self.tableView.re_footer = [[RefreshFooter alloc] init];
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(addHandler)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteHandler)];
}

- (void)addHandler {
    self.count += 1;
    [self.tableView.re_header endRefresh];
    [self.tableView.re_footer endRefresh];
    [self.tableView reloadData];
}

- (void)deleteHandler {
    self.count -= 1;
    if (self.count < 3) {
        self.count = 3;
    }
    [self.tableView.re_header endRefresh];
    [self.tableView.re_footer endRefresh];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"test";
    return cell;
}

@end
