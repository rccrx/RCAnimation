//
//  RCCustomView.m
//  RCAnimation
//
//  Created by crx on 2021/5/6.
//

#import "RCCustomView.h"

@interface RCCustomView ()
/** 子视图1 */
@property (nonatomic, strong) UIView *leftView;
/** 子视图2 */
@property (nonatomic, strong) UILabel *rightView;
@end
@implementation RCCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor darkGrayColor];
        
        _leftView = [[UIView alloc] initWithFrame:CGRectZero];
        self.leftView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.leftView];
        
        _rightView = [[UILabel alloc] initWithFrame:CGRectZero]; // UIViewAnimationOptionLayoutSubviews无法使UILabel在父视图的frame变化时和父视图保持着约束。
        self.rightView.text = @"custom";
//        _rightView = [[UIView alloc] initWithFrame:CGRectZero];
        self.rightView.backgroundColor = [UIColor systemPinkColor];
        [self addSubview:self.rightView];
        
//        [self setupConstraint]; // 如果使用约束来设置子视图的位置(而不直接设置frame)，则注释掉layoutSubviews整个方法
    }
    return self;
}

/** 首次显示本视图，或者本视图的大小改变时都会调用（本视图只有位置改变时不会调用） */
- (void)layoutSubviews {
    NSLog(@"%@ : %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
//    self.leftView.frame = CGRectMake(5, 5, 50, 30);
//    self.rightView.frame = CGRectMake(60, 10, 50, 30);
    
    // 子视图的frame与父视图的大小有关，才能用来测试UIViewAnimationOptionLayoutSubviews
    self.leftView.frame = CGRectMake(5, 5, CGRectGetWidth(self.bounds)*0.5-7.5, CGRectGetHeight(self.bounds)-10);
    self.rightView.frame = CGRectMake(CGRectGetMidX(self.bounds)+2.5, 5, CGRectGetWidth(self.bounds)*0.5-7.5, CGRectGetHeight(self.bounds)-10);
}

- (void)setupConstraint {
    self.leftView.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:5];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:-7.5];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5];
    NSLayoutConstraint *heigthConstraint = [NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-10];
    [self addConstraint:leftConstraint];
    [self addConstraint:widthConstraint];
    [self addConstraint:topConstraint];
    [self addConstraint:heigthConstraint];
    
    
    NSLayoutConstraint *leftConstraint1 = [NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-5];
    NSLayoutConstraint *widthConstraint1 = [NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:-7.5];
    NSLayoutConstraint *topConstraint1 = [NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5];
    NSLayoutConstraint *heigthConstraint1 = [NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-10];
    [self addConstraint:leftConstraint1];
    [self addConstraint:widthConstraint1];
    [self addConstraint:topConstraint1];
    [self addConstraint:heigthConstraint1];
}

@end
