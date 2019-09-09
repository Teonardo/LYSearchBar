//
//  LYSearchBarDemo.m
//  LYSearchBar
//
//  Created by Teonardo on 2019/9/4.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "LYSearchBarDemo.h"
#import "LYSearchBar.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@interface LYSearchBarDemo ()<UITableViewDelegate, UITableViewDataSource, LYSearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, copy) NSArray *searchResultArr;
@property (nonatomic, strong) LYSearchBar *searchBar;

@end

@implementation LYSearchBarDemo

#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"LYSearchBarDemo";
    
    [self addTableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"active测试" style:UIBarButtonItemStylePlain target:self action:@selector(changeActive)];
}

// 测试手动设置 active 属性的效果
- (void)changeActive {
    self.searchBar.active = !self.searchBar.active;
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
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 拖动时隐藏键盘
    
    tableView.tableHeaderView = self.searchBar;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.searchBar.barStyle = indexPath.row;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchBar.active ? self.searchResultArr.count : self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    if (self.searchBar.active) { // 显示搜索结果
        cell.textLabel.text = self.searchResultArr[indexPath.row];
    } else { // 正常状态
        cell.textLabel.text = self.modelArr[indexPath.row];
    }
    
    return cell;
}

#pragma mark - LYSearchBarDelegate
- (void)updateSearchResultsForSearchBar:(LYSearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // 过滤数据(服务器或本地进行)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[C] %@", searchBar.text];
    self.searchResultArr = [self.modelArr filteredArrayUsingPredicate:predicate];
    
    // 刷新数据
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(LYSearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarTextDidBeginEditing:(LYSearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (BOOL)searchBarShouldEndEditing:(LYSearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarTextDidEndEditing:(LYSearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)searchBar:(LYSearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (BOOL)searchBar:(LYSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarSearchButtonClicked:(LYSearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)searchBarCancelButtonClicked:(LYSearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - Getter

- (LYSearchBar *)searchBar {
    if (!_searchBar) {
        LYSearchBar *searchBar = [[LYSearchBar alloc] init];
        searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, LYSearchBarDefaultHeight);
        searchBar.placeholder = @"请输入搜索关键字";
        searchBar.delegate = self;
        _searchBar = searchBar;
    }
    return _searchBar;
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = @[@"LYBarStyleDefault", @"LYBarStyleSystem", @"LYBarStyleBorder", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"].mutableCopy;
    }
    return _modelArr;
}

- (NSArray *)searchResultArr {
    if (!_searchResultArr) {
        _searchResultArr = [NSArray array];
    }
    return _searchResultArr;
}

@end
