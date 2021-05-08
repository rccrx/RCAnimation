//
//  RCCustomView.h
//  RCAnimation
//
//  Created by crx on 2021/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 用于测试UIViewAnimationOptions的自定制view，也用来测试transition动画、performSystemAnimation */
@interface RCCustomView : UIView

/** 子视图1 */
@property (nonatomic, strong, readonly) UIView *leftView;
/** 子视图2 */
@property (nonatomic, strong, readonly) UILabel *rightView;
/** 用来测试transition动画的子视图，一开始隐藏状态*/
@property (nonatomic, strong, readonly) UIView *centerView;

@end

NS_ASSUME_NONNULL_END
