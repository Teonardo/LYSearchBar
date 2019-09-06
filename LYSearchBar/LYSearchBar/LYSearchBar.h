//
//  LYSearchBar.h
//  LYSearchBar
//
//  Created by Teonardo on 2019/9/3.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LYSearchBarDefaultHeight 60.0

NS_ASSUME_NONNULL_BEGIN

@class LYSearchBar;
@protocol LYSearchBarDelegate <NSObject>

@optional

/**
 更新搜索结果回调, 以下4种情况会触发
 1 searchBar 开始输入
 2 输入文本发生变化时 (若输入文本还未确认则不会触发,比如输入中文时,点击键盘确认按钮后才会触发)
 3 点击取消
 4 手动改变 active 的值
 
 如果想自行选择处理时机, 比如说只想在点击键盘搜索按钮时进行搜索操作, 则需要处理以下3个方法:
 ① searchBarTextDidBeginEditing:(点击搜索框) [根据 active 显示搜索结果,此时一般为空]
 ② searchBarSearchButtonClicked:(点击搜索按钮)[执行搜索操作并刷新数据]
 ③ searchBarCancelButtonClicked:(点击取消按钮)[根据 active 显示原始数据]
 
 @param searchBar searchBar对象
 */
- (void)updateSearchResultsForSearchBar:(LYSearchBar *)searchBar;

// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(LYSearchBar *)searchBar;

// called when text starts editing
- (void)searchBarTextDidBeginEditing:(LYSearchBar *)searchBar;

// return NO to not resign first responder
- (BOOL)searchBarShouldEndEditing:(LYSearchBar *)searchBar;

// called when text ends editing
- (void)searchBarTextDidEndEditing:(LYSearchBar *)searchBar;

// called when text changes (including clear)
- (void)searchBar:(LYSearchBar *)searchBar textDidChange:(NSString *)searchText;

// called before text changes
- (BOOL)searchBar:(LYSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

// called when keyboard search button pressed(点击搜索按钮时触发)
- (void)searchBarSearchButtonClicked:(LYSearchBar *)searchBar;

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(LYSearchBar *)searchBar;

@end


@interface LYSearchBar : UIView

@property(nonatomic, weak, nullable) id<LYSearchBarDelegate> delegate;
@property(nonatomic, copy, nullable) NSString *text;
@property(nonatomic, copy, nullable) NSString *placeholder;

/**
 主要用来判断是否处于搜索状态
 也可主动设置来 开启/取消 搜索, 非必要情况不建议使用
 */
@property (nonatomic, assign, getter = isActive) BOOL active;

@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) UIButton *cancelButton;

@end

NS_ASSUME_NONNULL_END
