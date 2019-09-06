//
//  UISearchControllerDemo.m
//  LYSearchBar
//
//  Created by Teonardo on 2019/9/4.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "UISearchControllerDemo.h"

@interface UISearchControllerDemo ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, copy) NSArray *searchResultArr;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation UISearchControllerDemo

#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"UISearchControllerDemo";
    
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
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 拖动时隐藏键盘
    
    // MARK:2️⃣ 将搜索框设置成 tableView 的表头
    tableView.tableHeaderView = self.searchController.searchBar;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchController.active ? self.searchResultArr.count : self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    if (self.searchController.active) { // 显示搜索结果
        cell.textLabel.text = self.searchResultArr[indexPath.row];
    } else { // 正常状态
        cell.textLabel.text = self.modelArr[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UISearchResultsUpdating (Required)
// MARK:3️⃣ 当搜索框的文本或范围发生变化, 或搜索栏成为第一响应者时调用。
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // 过滤数据(服务器或本地进行)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[C] %@", searchController.searchBar.text];
    self.searchResultArr = [self.modelArr filteredArrayUsingPredicate:predicate];
    
    // 刷新数据
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate (Optional)
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%@", @(self.searchController.active));
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - UISearchControllerDelegate (Optional)
- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - Getter
// MARK:1️⃣ 初始化 searchController, 设置代理
- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil]; // 如果用同一个视图展示搜索结果传nil就行.
        _searchController.searchResultsUpdater = self; // 搜索逻辑处理
        //_searchController.delegate = self; // 监听 搜索视图控制器的 出现与消失
        _searchController.searchBar.delegate = self; // 监听搜索框
        _searchController.searchBar.placeholder = @"请输入搜索关键字";
        //_searchController.hidesNavigationBarDuringPresentation = NO; // 搜索时隐藏导航栏
        _searchController.dimsBackgroundDuringPresentation = NO;
    }
    return _searchController;
}


- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"].mutableCopy;
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
