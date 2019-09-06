//
//  LYSearchBar.m
//  LYSearchBar
//
//  Created by Teonardo on 2019/9/3.
//  Copyright © 2019 Teonardo. All rights reserved.
//

#import "LYSearchBar.h"

#define kCancelTextColor [UIColor colorWithRed:72/255.0 green:150/255.0 blue:247/255.0 alpha:1]

@interface LYSearchBar ()<UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *textField;
@property (nonatomic, strong, readwrite) UIButton *cancelButton;

@property (nonatomic, assign) BOOL showsCancelButton;

@end

const CGFloat kSpacing = 10.f;
const CGFloat kTextFieldHeight = 40.f; // 输入宽高度(取消按钮相同)
const CGFloat kFontSize = 16.0; // 文字大小

@implementation LYSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self layoutUI];
    }
    return self;
}

#pragma mark - UI
- (void)layoutUI {
    
    // textField
    UITextField *textField = [UITextField new];
    [self addSubview:textField];
    self.textField = textField;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:kFontSize];
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeySearch;
    textField.enablesReturnKeyAutomatically = YES; // 没有输入时禁止搜索
    
    textField.leftView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.bounds = CGRectMake(0, 0, kTextFieldHeight, kTextFieldHeight);
        imageView;
    });
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = kTextFieldHeight/2.0;
    textField.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];

    
    // cancelButton
    [self addSubview:self.cancelButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cancelButtonWidth = [self cancelButtonWidth];
    CGFloat originY = (CGRectGetHeight(self.frame) - kTextFieldHeight) / 2.0;
    CGFloat textFieldWidth;
    if (self.showsCancelButton) {
        textFieldWidth = CGRectGetWidth(self.frame) - kSpacing * 3 - cancelButtonWidth;
    } else {
        textFieldWidth = CGRectGetWidth(self.frame) - kSpacing * 2;
    }
    self.textField.frame = CGRectMake(kSpacing, originY, textFieldWidth, kTextFieldHeight);
    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(_textField.frame) + kSpacing, originY, cancelButtonWidth, kTextFieldHeight);
}

#pragma mark - Handle Method
- (void)clickedCancelButton:(UIButton *)buttton {
    _active = NO;
    // 1 清空输入
    self.text = @"";
    
    // 2 通知取消
    [self setShowsCancelButton:NO animated:YES];
    if ([self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [self.delegate searchBarCancelButtonClicked:self];
    }
    
    // 3 结束编辑
    [self endEditing:YES];
    
    // 4 通知更新
    if ([self.delegate respondsToSelector:@selector(updateSearchResultsForSearchBar:)]) {
        [self.delegate updateSearchResultsForSearchBar:self];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.textField.markedTextRange) { // 屏蔽还未确定的输入
        return;
    }
    
    // 1 通知文本改变
    if ([self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
    
    // 2 通知更新
    if ([self.delegate respondsToSelector:@selector(updateSearchResultsForSearchBar:)]) {
        [self.delegate updateSearchResultsForSearchBar:self];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _active = YES;
    [self setShowsCancelButton:YES animated:YES];
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
    
    // 通知更新
    if ([self.delegate respondsToSelector:@selector(updateSearchResultsForSearchBar:)]) {
        [self.delegate updateSearchResultsForSearchBar:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        return [self.delegate searchBarTextDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    [self endEditing:YES];
    return YES;
}

#pragma mark - Private Method
- (void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated {
    
    if (_showsCancelButton == showsCancelButton) {
        return;
    }
    _showsCancelButton = showsCancelButton;
    
    CGRect textFieldFrame = self.textField.frame;
    CGRect cancelButtonFrame = self.cancelButton.frame;
    CGFloat offset = kSpacing + self.cancelButtonWidth;
    if (showsCancelButton) {
        textFieldFrame.size.width -= offset;
        cancelButtonFrame.origin.x -= offset;
    } else {
        textFieldFrame.size.width += offset;
        cancelButtonFrame.origin.x += offset;
    }
    
    [UIView animateWithDuration:(animated ? 0.3 : 0.0) animations:^{
        self.textField.frame = textFieldFrame;
        self.cancelButton.frame = cancelButtonFrame;
    }];
}

- (CGFloat)cancelButtonWidth {
    return [self.cancelButton sizeThatFits:CGSizeMake(MAXFLOAT, kTextFieldHeight)].width;
}

#pragma mark - Setter

- (void)setText:(NSString *)text {
    _textField.text = text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _textField.placeholder = placeholder;
}

- (void)setActive:(BOOL)active {
    if (_active != active) {
        
        [self setShowsCancelButton:active animated:YES];
        
        if (active == NO) {
            _textField.text = @"";
            [_textField resignFirstResponder];
        }
        
        _active = active;
        
        // 通知更新
        if ([self.delegate respondsToSelector:@selector(updateSearchResultsForSearchBar:)]) {
            [self.delegate updateSearchResultsForSearchBar:self];
        }
    }
}

#pragma mark - Getter

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:kCancelTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSize];
        [button addTarget:self action:@selector(clickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}

- (NSString *)text {
    return _textField.text;
}

- (NSString *)placeholder {
    return _textField.placeholder;
}

@end
