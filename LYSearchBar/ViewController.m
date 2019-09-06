//
//  ViewController.m
//  LYSearchBar
//
//  Created by Teonardo on 2019/9/3.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "ViewController.h"
#import "UISearchControllerDemo.h"
#import "LYSearchBarDemo.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation ViewController

#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = @[@"UISearchControllerDemo", @"LYSearchBarDemo"];
    
    [self addTableView];
}

#pragma mark - UI
- (void)addTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.rowHeight = 50;
    tableView.tableFooterView = [UIView new];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UISearchControllerDemo *vc = [UISearchControllerDemo new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        LYSearchBarDemo *vc= [LYSearchBarDemo new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

@end
