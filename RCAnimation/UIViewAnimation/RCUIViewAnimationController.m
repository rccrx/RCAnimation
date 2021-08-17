//
//  RCUIViewAnimationController.m
//  RCAnimation
//
//  Created by crx on 2021/5/5.
//

#import "RCUIViewAnimationController.h"
#import "RCCustomView.h"

@interface RCUIViewAnimationController () <UIPickerViewDataSource, UIPickerViewDelegate>
/** 测试视图 */
@property (nonatomic, strong) UILabel *testView;
/** UIViewAnimationOptions选择器 */
@property (nonatomic, strong) UIPickerView *optionsPickerView;
/** 所有UIViewAnimationOptions取值（optionsPickerView的数据源） */
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSNumber *> *> *optionsArray;
/** 测试UIViewAnimationOptions的视图 */
@property (nonatomic, strong) RCCustomView *testOptionView;
@end

@implementation RCUIViewAnimationController

#pragma mark - UIViewAnimationOptions选择器 与 UIPickerView代理
- (void)createAndAddOptionsPickerViewToSelfView {
    _optionsArray = @[
        @{@"UIViewAnimationOptionLayoutSubviews":@(UIViewAnimationOptionLayoutSubviews)},
        @{@"UIViewAnimationOptionAllowUserInteraction":@(UIViewAnimationOptionAllowUserInteraction)},
        @{@"UIViewAnimationOptionBeginFromCurrentState":@(UIViewAnimationOptionBeginFromCurrentState)},
        @{@"UIViewAnimationOptionRepeat":@(UIViewAnimationOptionRepeat)},
        @{@"UIViewAnimationOptionAutoreverse":@(UIViewAnimationOptionAutoreverse)},
        @{@"UIViewAnimationOptionOverrideInheritedDuration":@(UIViewAnimationOptionOverrideInheritedDuration)},
        @{@"UIViewAnimationOptionOverrideInheritedCurve":@(UIViewAnimationOptionOverrideInheritedCurve)},
        @{@"UIViewAnimationOptionAllowAnimatedContent":@(UIViewAnimationOptionAllowAnimatedContent)},
        @{@"UIViewAnimationOptionShowHideTransitionViews":@(UIViewAnimationOptionShowHideTransitionViews)},
        @{@"UIViewAnimationOptionOverrideInheritedOptions":@(UIViewAnimationOptionOverrideInheritedOptions)},
        
        @{@"UIViewAnimationOptionCurveEaseInOut":@(UIViewAnimationOptionCurveEaseInOut)},
        @{@"UIViewAnimationOptionCurveEaseIn":@(UIViewAnimationOptionCurveEaseIn)},
        @{@"UIViewAnimationOptionCurveEaseOut":@(UIViewAnimationOptionCurveEaseOut)},
        @{@"UIViewAnimationOptionCurveLinear":@(UIViewAnimationOptionCurveLinear)},
        
        @{@"UIViewAnimationOptionTransitionNone":@(UIViewAnimationOptionTransitionNone)},
        @{@"UIViewAnimationOptionTransitionFlipFromLeft":@(UIViewAnimationOptionTransitionFlipFromLeft)},
        @{@"UIViewAnimationOptionTransitionFlipFromRight":@(UIViewAnimationOptionTransitionFlipFromRight)},
        @{@"UIViewAnimationOptionTransitionCurlUp":@(UIViewAnimationOptionTransitionCurlUp)},
        @{@"UIViewAnimationOptionTransitionCurlDown":@(UIViewAnimationOptionTransitionCurlDown)},
        @{@"UIViewAnimationOptionTransitionCrossDissolve":@(UIViewAnimationOptionTransitionCrossDissolve)},
        @{@"UIViewAnimationOptionTransitionFlipFromTop":@(UIViewAnimationOptionTransitionFlipFromTop)},
        @{@"UIViewAnimationOptionTransitionFlipFromBottom":@(UIViewAnimationOptionTransitionFlipFromBottom)},
        
        @{@"UIViewAnimationOptionPreferredFramesPerSecondDefault":@(UIViewAnimationOptionPreferredFramesPerSecondDefault)},
        @{@"UIViewAnimationOptionPreferredFramesPerSecond60":@(UIViewAnimationOptionPreferredFramesPerSecond60)},
        @{@"UIViewAnimationOptionPreferredFramesPerSecond30":@(UIViewAnimationOptionPreferredFramesPerSecond30)}];
    
    _optionsPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-50-80, CGRectGetWidth(self.view.frame), 80)];
    self.optionsPickerView.layer.borderWidth = 2;
    self.optionsPickerView.dataSource = self;
    self.optionsPickerView.delegate = self;
    [self.view addSubview:self.optionsPickerView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.optionsArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CGRectGetWidth(self.view.frame)-30;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = self.optionsArray[row].allKeys.firstObject;
    return label;
}

#pragma mark - 生命周期 与 按钮点击
/** self.view添加一个按钮 */
- (void)selfViewAddButtonWithOriginY:(CGFloat)y title:(NSString *)title tag:(NSInteger)tag {
    CGFloat buttonWidth = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat buttonHeight = 30;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, buttonWidth, buttonHeight)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [self.view addSubview:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _testView = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 200, 100)];
    self.testView.backgroundColor = [UIColor redColor];
    self.testView.text = @"测试文字";
    [self.view addSubview:self.testView];
    
    self.testOptionView = [[RCCustomView alloc] initWithFrame:CGRectMake(200, 50, 150, 50)];
    [self.view addSubview:self.testOptionView];
    
    [self selfViewAddButtonWithOriginY:200 title:@"恢复视图为动画开始之前的样子" tag:99];
    [self selfViewAddButtonWithOriginY:250 title:@"测试属性动画" tag:1];
    [self selfViewAddButtonWithOriginY:300 title:@"简单测试各个UIViewAnimationOptions，某些选项的具体用法在下一个测试" tag:2];
    [self selfViewAddButtonWithOriginY:350 title:@"测试UIViewAnimationOptions一些选项的具体用法" tag:3];
    [self selfViewAddButtonWithOriginY:400 title:@"测试UIViewAnimationOptionBeginFromCurrentState可以先启动一个animation" tag:4];
    [self selfViewAddButtonWithOriginY:450 title:@"测试关键帧动画、performSystemAnimation、performWithoutAnimation、setAnimationsEnabled" tag:5];
    
    [self createAndAddOptionsPickerViewToSelfView];
}

/** 按钮点击事件 */
- (void)buttonClicked:(UIButton *)button {
    NSInteger tag = button.tag;
    NSLog(@"点击了按钮（tag=%ld）", tag);
    switch (tag) {
        case 99:
        {
            [self resetView];
            break;
        }
        case 1:
        {
            [self executePropertyAnimation];
            break;
        }
        case 2:
        {
            [self executeAnimationForEveryUIViewAnimationOptions];
            break;
        }
        case 3:
        {
            [self executeAnimationForUIViewAnimationOptionsUsage];
            break;
        }
        case 4:
        {
            [self executeAnimationForUIViewAnimationOptionBeginFromCurrentState];
            break;
        }
        case 5:
        {
            [self executeAnimations];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - 动画相关代码
/** 恢复视图 */
- (void)resetView {
    // 将属性恢复成原来的样子，然后再重新执行动画
    self.testView.transform = CGAffineTransformIdentity; // 由于transform不等于identity时，frame是无效的，所以如果想恢复变形之后的视图为原来的样子，必须先将transform修改成identity才能修改frame。如果先修改frame再修改为identity则无法恢复原来的样子。
    self.testView.frame = CGRectMake(100, 50, 200, 100);
    self.testView.backgroundColor = [UIColor redColor];
    self.testView.alpha = 1;
    
    self.testOptionView.frame = CGRectMake(200, 50, 150, 50);
    self.testOptionView.rightView.frame = CGRectMake(77.5, 5, 67.5, 40);
    self.testOptionView.leftView.hidden = NO;
    self.testOptionView.centerView.hidden = YES;
    [self.testOptionView addSubview:self.testOptionView.leftView];
    self.testOptionView.leftView.transform = CGAffineTransformIdentity;
    self.testOptionView.leftView.alpha = 1;
    [self.testOptionView addSubview:self.testOptionView.rightView];
    self.testOptionView.rightView.transform = CGAffineTransformIdentity;
    self.testOptionView.rightView.alpha = 1;
    
    if (![self.view viewWithTag:1099]) {
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(200, 70, 100, 120)];
        v.text = NSStringFromCGRect(v.frame);
        v.adjustsFontSizeToFitWidth = YES;
        v.layer.borderColor = [UIColor yellowColor].CGColor;
        v.layer.borderWidth = 2;
        v.tag = 1099;
        [self.view addSubview:v];
    }
    
    if (![self.view viewWithTag:1098]) {
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 100, 120)];
        v.text = NSStringFromCGRect(v.frame);
        v.adjustsFontSizeToFitWidth = YES;
        v.layer.borderColor = [UIColor purpleColor].CGColor;
        v.layer.borderWidth = 2;
        v.tag = 1098;
        [self.view addSubview:v];
    }
    
    if (![self.view viewWithTag:1097]) {
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 120)];
        v.text = NSStringFromCGRect(v.frame);
        v.adjustsFontSizeToFitWidth = YES;
        v.layer.borderColor = [UIColor cyanColor].CGColor;
        v.layer.borderWidth = 2;
        v.tag = 1097;
        [self.view addSubview:v];
    }
    
    if (![self.view viewWithTag:1096]) {
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(300, 150, 50, 50)];
        v.backgroundColor = [UIColor redColor];
        v.alpha = 0.5;
        v.text = @"alpha=0.5";
        v.adjustsFontSizeToFitWidth = YES;
        v.tag = 1096;
        [self.view addSubview:v];
    }
    
    if (![self.view viewWithTag:1095]) {
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(300, 100, 50, 50)];
        v.backgroundColor = [UIColor redColor];
        v.alpha = 0.1;
        v.text = @"alpha=0.1";
        v.adjustsFontSizeToFitWidth = YES;
        v.tag = 1095;
        [self.view addSubview:v];
    }
    
    if (![self.view viewWithTag:1094]) {
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(200, 50, 150, 50)];
        v.text = NSStringFromCGRect(v.frame);
        v.adjustsFontSizeToFitWidth = YES;
        v.layer.borderColor = [UIColor blueColor].CGColor;
        v.layer.borderWidth = 2;
        v.tag = 1094;
        [self.view addSubview:v];
    }
}

/** 测试属性动画 */
- (void)executePropertyAnimation {
    [UIView animateWithDuration:1 delay:0 options:0 animations:^{
        /*
         frame、bound、center、transform、alpha、backgroundColor，修改这些属性都有动画效果
         */
//        self.testView.frame = CGRectMake(200, 70, 100, 120); // 修改位置和大小
//        self.testView.backgroundColor = [UIColor orangeColor]; // 修改背景颜色
        
        /*
         变形：缩放、旋转、平移
         x' = a*x + c*y + tx
         y' = b*x + d*y + ty
         CGAffineTransform = [a, b, c, d, tx, ty]
         x和y是相对中心点的坐标，xy轴正向和屏幕坐标系正向一致（也就是，x轴正向往右，y轴正向往下），比如frame=(50, 50, 200, 100)的左上角的(x,y)=(-100,-50)，旋转90度之后变成(50,-100)，所以求出(a=0,b=1,c=-1,d=0,tx=0,ty=0)。
        */
        CGAffineTransform transform;
//        transform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0); // 保持y坐标不变，x坐标镜像映射
//        transform = CGAffineTransformMake(1, 1, 0, 1, 0, 0); // 保持x坐标不变，y轴左边的点往上移，y轴右边的点往下移，移动增量是原x坐标值的绝对值
        transform = CGAffineTransformMake(1, 0, -1, 1, 0, 0); // 保持y坐标不变，x轴以上的点往右移，x轴以下的点往左移，移动增量是原y坐标值的绝对值
//        transform = CGAffineTransformMakeScale(0.5, 0.7); // [0.5, 0, 0, 0.7, 0, 0]
//        transform = CGAffineTransformMakeRotation(M_PI_2); // [0, 1, -1, 0, 0, 0]
//        transform = CGAffineTransformMakeTranslation(100, 50); // [1, 0, 0, 1, 100, 50]
        NSLog(@"transform = %@", NSStringFromCGAffineTransform(transform));
        self.testView.transform = transform;
        } completion:^(BOOL finished) {
            NSLog(@"%@: finished=%d", NSStringFromSelector(_cmd), finished);
        }];
}

/** 这里只是简单测试各个option，每个option的具体用法在之后的测试中*/
- (void)executeAnimationForEveryUIViewAnimationOptions {
    NSInteger seletedRow = [self.optionsPickerView selectedRowInComponent:0];
    UIViewAnimationOptions option = self.optionsArray[seletedRow].allValues.firstObject.unsignedIntegerValue; // 获取optionsPickerView选中的UIViewAnimationOptions
    NSLog(@"selected option = %lu", option);
    
    [UIView animateWithDuration:1 delay:0 options:option animations:^{
        self.testView.frame = CGRectMake(200, 70, 100, 120);
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d", NSStringFromSelector(_cmd), finished);
    }];
}

/** 测试UIViewAnimationOptions一些选项的具体用法 */
- (void)executeAnimationForUIViewAnimationOptionsUsage {
//    [self executeAnimationWithUIViewAnimationOptionLayoutSubviews];
//    [self executeAnimationWithUIViewAnimationOptionBeginFromCurrentState];
//    [self executeAnimationWithUIViewAnimationOptionOverrideInheritedDuration];
//    [self executeAnimationWithUIViewAnimationOptionAllowAnimatedContent];
//    [self executeAnimationWithUIViewAnimationOptionShowHideTransitionViews];
//    [self executeAnimationWithUIViewAnimationOptionOverrideInheritedOptions];
    [self executeAnimationWithUIViewAnimationOptionPreferredFramesPerSecond30];
}

/** 测试UIViewAnimationOptionLayoutSubviews */
- (void)executeAnimationWithUIViewAnimationOptionLayoutSubviews {
    UIViewAnimationOptions option;
    option = UIViewAnimationOptionLayoutSubviews; // 为了测试这个选项，①testOptionView的子视图的frame需要与父视图即testOptionView的大小有关，②在自定制的RCCustomView(即testOptionView类型)中重写-layoutSubviews:并在这个方法中设置子类的frame，①②设置之后才会使这个选项生效，也就是父视图的大小位置动态渐渐改变时，子视图的frame一直保持着和父视图的相对关系比如一直是父视图大小的二分之一减7.5。并且，子视图需要是UIView不能是UILabel，UILabel的frame无法在父视图大小位置变化时保持和父视图的相对关系即高度应该是父视图减10。（即使使用约束NSLayoutConstraint设置子视图和父视图的相对关系，还是无法使UILabel在父视图位置大小变化时保持约束。）
//    option = 0;
    
    [UIView animateWithDuration:1 delay:0 options:option animations:^{
        self.testOptionView.frame = CGRectMake(200, 70, 100, 120);
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d", NSStringFromSelector(_cmd), finished);
    }];
}

/** 用于测试UIViewAnimationOptionBeginFromCurrentState的进行中动画 */
- (void)executeAnimationForUIViewAnimationOptionBeginFromCurrentState {
    UIViewAnimationOptions option;
    option = UIViewAnimationOptionBeginFromCurrentState;
    option = 0;
    [UIView animateWithDuration:4 delay:0 options:option animations:^{
//        self.testView.frame = CGRectMake(200, 70, 100, 120);
        self.testView.alpha = 0.5;
        NSLog(@"animation1"); // 当执行到animateWithDurationxx这个方法时，会立即调用animations这个block里面的代码，但是不一定启动动画比如当设置了延迟1.5时
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d (animation1)", NSStringFromSelector(_cmd), finished);
    }];
}

/** 测试UIViewAnimationOptionBeginFromCurrentState */
- (void)executeAnimationWithUIViewAnimationOptionBeginFromCurrentState {
    UIViewAnimationOptions option;
    option = UIViewAnimationOptionBeginFromCurrentState; // 这个选项对frame所加的动画无效，对alpha有效：①不管option是UIViewAnimationOptionBeginFromCurrentState还是0，本动画animation2开始时会使得已经运行中的动画animation1立即结束(前提是animation1是修改alpha而不是frame，如果是frame则不会结束)，调用completion且finished=NO，所以xxCurrentState并不影响一个已经运行中的动画是否该立即结束，而这个运行中的动画是否立即结束取决于动画修改的是哪个属性(但是还没有验证过alpha和frame以外的属性)。②如果没有进行中的alpha动画，则option=xxCurrentState使得动画不会从<animateWithDurationxx代码前面设置alpha值>即0.1开始变化，而是从当前屏幕显示的alpha开始变化；option=0使得动画是从0.1开始变化。②如果有进行中的alpha动画，option=0使得动画是从0.1开始变化，而xxCurrentState看起来立即停止了animation1的动画，但是animation2的起始alpha不是animation1结束时的alpha，而是比结束时更接近0.5(animation1的目标值)的alpha值。
//    option = 0;

//    self.testView.frame = CGRectMake(10, 50, 100, 120);
    self.testView.alpha = 0.1; // 如果将这句代码改成“[UIView animateWithDuration:0 animations:^{self.testView.alpha = 0.1;} completion:^(BOOL finished){[UIView animateWithDuration:xx”给0.1加一个duration=0的动画并在completion中写上animation2的整个代码并且animation2使用xxCurrentState，结果是每次animation2都是从0.1开始，但其实animation2的option不要设置为xxCurrentState就可以达到每次从0.1开始的效果。
    
    [UIView animateWithDuration:5 delay:0 options:option animations:^{
        self.testView.alpha = 1;
//        self.testView.frame = CGRectMake(150, 50, 100, 120);
//        self.testView.frame = CGRectMake(200, 70, 100, 120); // animation1修改frame时：由于前面的动画代码立即执行了animations里面的代码，所以self.testView.frame已经是(200, 70, 100, 120)，所以这第二个动画没有执行，直接调用completion
        NSLog(@"animation2");
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d (animation2)", NSStringFromSelector(_cmd), finished);
    }];
}

/** 测试UIViewAnimationOptionOverrideInheritedDuration */
- (void)executeAnimationWithUIViewAnimationOptionOverrideInheritedDuration {
    UIViewAnimationOptions option;
    option = UIViewAnimationOptionOverrideInheritedDuration;
//    option = 0;
    
    [UIView animateWithDuration:6 delay:0 options:0 animations:^{
        self.testView.frame = CGRectMake(150, 50, 100, 120);
        NSLog(@"animation1");
        
        [UIView animateWithDuration:2 delay:1 options:option animations:^{ // ①嵌套动画，如果delay是0则和外层动画同时开始，如果非0则比外层延迟delay秒；②如果option是UIViewAnimationOptionOverrideInheritedDuration，则嵌套动画运行时长就是设置的2s，如果option=0，则嵌套动画运行时长和外层一样，是6s而不是2s(而且因为启动比外层延迟1s所以结束也会比外层慢1s)。
//            self.testView.backgroundColor = [UIColor orangeColor]; // 修改背景颜色立即生效没有动画效果，但是之前测试过有动画效果，为什么有时又没有动画效果？
            self.testView.alpha = 0.1;
            NSLog(@"animation2");
        } completion:^(BOOL finished) {
            NSLog(@"%@: finished=%d (animation2)", NSStringFromSelector(_cmd), finished);
        }];
        
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d (animation1)", NSStringFromSelector(_cmd), finished);
    }];
}

/** 测试UIViewAnimationOptionAllowAnimatedContent */
- (void)executeAnimationWithUIViewAnimationOptionAllowAnimatedContent {
    UIViewAnimationOptions option;
//    option = UIViewAnimationOptionAllowAnimatedContent; // option有没有设置xxAllowAnimatedContent都不会调用drawRect
//    option = 0;
//    option = UIViewAnimationOptionTransitionFlipFromLeft;
//    option = UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionAllowAnimatedContent;
    option = UIViewAnimationOptionTransitionCurlUp;
//    option = UIViewAnimationOptionTransitionCurlUp|UIViewAnimationOptionAllowAnimatedContent;
    
    // transition动画的第一个参数view是容器视图，改变这个容器视图的内容(比如添加一个子视图)，然后加上过渡选项比如UIViewAnimationOptionTransitionFlipFromLeft，就会翻转后显示这个容器视图的新样式新内容，如果没有设置过渡选项则容器视图内容改变没有动画而是立即生效；如果在animations中什么都不做不改变容器视图的内容而只添加xxTransitionFlipFromLeft选项，这样容器视图还是有翻转的效果，但是翻转之后内容没有变。
    [UIView transitionWithView:self.testOptionView duration:6 options:option animations:^{
        self.testOptionView.rightView.frame = CGRectMake(30, 15, 67.5, 40); // 不管有没有设置xxAllowAnimatedContent，这个属性变化都有动画效果
        self.testOptionView.leftView.hidden = YES;
        self.testOptionView.centerView.hidden = NO;
        
        self.testOptionView.center = CGPointMake(80, 100); // ①xxCurlUp：如果没有这句代码，则xxCurlUp翻页效果在原视图位置上有投影，并且卷起来的视图vj位置会超出原视图上边界，并且逐渐变透明消失；如果有这句代码，则卷起来的视图vj上部分不显示，而且vj的位置和没有这句代码时的位置不一样，偏上。②xxCurlUp|xxAllowAnimatedContent：如果没有这句代码，效果和①一样；如果有这句代码，vj上部分不显示，而且超出testOptionView新位置的部分不显示。(xxFlipFromLeft没有这个效果) —— 这个测试还是无法确定UIViewAnimationOptionAllowAnimatedContent代表什么效果
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d", NSStringFromSelector(_cmd), finished);
    }];
}

/** 测试UIViewAnimationOptionShowHideTransitionViews */
- (void)executeAnimationWithUIViewAnimationOptionShowHideTransitionViews {
    UIViewAnimationOptions option;
//    option = UIViewAnimationOptionShowHideTransitionViews;
//    option = 0;
    option = UIViewAnimationOptionShowHideTransitionViews|UIViewAnimationOptionTransitionFlipFromLeft;
    
    // ①这个动画方法默认会将fromView从它的父视图中移除(调用RCCustomView的willRemoveSubview)，将toView添加到fromView的父视图(调用RCCustomView的didAddSubview)，添加位置取决于toView的frame。②如果options设置了UIViewAnimationOptionShowHideTransitionViews，则不会将fromView从它的父视图中移除，而是设置这个视图的hidden为YES，而且会将toView的hidden设置为NO，但是不会修改toView的父视图，所以如果toView不在fromView的父视图中则执行完这个动画方法之后还是不在。③可以使用UIViewAnimationOptionTransitionFlipFromLeft这些transition选项，比如xxTransitionFlipFromLeft会给fromView的父视图添加翻转效果。
    [UIView transitionFromView:self.testOptionView.leftView toView:self.testOptionView.centerView duration:5 options:option completion:^(BOOL finished) {
            NSLog(@"%@: finished=%d, leftView.superview=%@, leftView.hidden=%d", NSStringFromSelector(_cmd), finished, self.testOptionView.leftView.superview, self.testOptionView.leftView.hidden);
    }];
}

/** 测试UIViewAnimationOptionOverrideInheritedOptions */
- (void)executeAnimationWithUIViewAnimationOptionOverrideInheritedOptions {
    UIViewAnimationOptions option;
//    option = UIViewAnimationOptionOverrideInheritedOptions; // 嵌套动画的option设置了xxOverrideInheritedOptions，就不会继承外层的弹簧时间曲线，默认是Linear时间曲线
//    option = 0;
//    option = UIViewAnimationOptionOverrideInheritedCurve|UIViewAnimationOptionCurveEaseInOut; // 设置不生效，还是继承了外层的弹簧效果
    option = UIViewAnimationOptionOverrideInheritedCurve|UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionOverrideInheritedOptions; // 设置生效，嵌套动画时间曲线不是弹簧曲线而是EaseInOut
    
    [UIView animateWithDuration:5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.5 options:0 animations:^{
        self.testView.frame = CGRectMake(150, 50, 100, 120);
        NSLog(@"animation1");
        [UIView animateWithDuration:1 delay:0 options:option animations:^{ // ①即使不设置UIViewAnimationOptionOverrideInheritedOptions，也不会继承外层的options如UIViewAnimationOptionAutoreverse、UIViewAnimationOptionOverrideInheritedDuration等（不管外层动画是弹簧动画还是transition动画还是普通动画）。②不设置xxOverrideInheritedOptions，会继承外层的弹簧效果。
            self.testOptionView.frame = CGRectMake(150, 50, 100, 120);
            NSLog(@"animation2");
        } completion:^(BOOL finished) {
            NSLog(@"%@: finished=%d (animation2)", NSStringFromSelector(_cmd), finished);
        }];
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d (animation1)", NSStringFromSelector(_cmd), finished);
    }];
}

/** 测试UIViewAnimationOptionPreferredFramesPerSecond30 */
- (void)executeAnimationWithUIViewAnimationOptionPreferredFramesPerSecond30 {
    UIViewAnimationOptions option;
    option = UIViewAnimationOptionPreferredFramesPerSecond30; // 这个动画效果看起来有点卡顿，而xx60和Default相对平滑点，官方文档说明“It's recommended that you use the default value unless you have identified a specific need for an explicit rate.”，除非需要明确的帧率，否则不需要设置这个选项。
    option = UIViewAnimationOptionPreferredFramesPerSecond60;
//    option = 0;
    
    [UIView animateWithDuration:0.3 delay:0 options:option animations:^{
        self.testView.frame = CGRectMake(250, 550, 200, 100);
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d", NSStringFromSelector(_cmd), finished);
    }];
}

/** 测试各种动画方法 */
- (void)executeAnimations {
//    [self executeKeyframeAnimation];
//    [self executePerformSystemAnimationOOAC];
//    [self executePerformWithoutAnimation];
    [self executeSetAnimationsEnabled];
}

/** 测试关键帧动画 */
- (void)executeKeyframeAnimation {
    UIViewKeyframeAnimationOptions option;
    option = UIViewKeyframeAnimationOptionCalculationModeDiscrete;
    option = 0;
    [UIView animateKeyframesWithDuration:5 delay:0 options:option animations:^{
        self.testView.alpha = 0.1; // 这个属性变化持续时长5s
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            self.testView.frame = CGRectMake(10, 5, 200, 100); // 这个属性变化持续时长5*0.5=2.5s
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.2 animations:^{
            self.testView.bounds = CGRectMake(0, 0, 50, 50);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.3 animations:^{
            self.testView.frame = CGRectMake(250, 100, 200, 100);
        }];
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d", NSStringFromSelector(_cmd), finished);
    }];
}

/** 测试performSystemAnimation:onViews:options:animations:completion: */
- (void)executePerformSystemAnimationOOAC {
    UISystemAnimation systemAnimation = UISystemAnimationDelete;
    // 这个动画会修改onViews中的视图的transform为[0.25, 0, 0, 0.25, 0, 0]，修改alpha为0，并且从父视图中移除，总体效果是立即放大后缩小且变透明。
    [UIView performSystemAnimation:systemAnimation onViews:@[self.testOptionView.leftView, self.testOptionView.rightView] options:0 animations:^{
        // 在这个block中，不能修改onViews中的视图属性，可以修改其他视图属性或者置空
        self.testView.transform = CGAffineTransformMake(0.25, 0, 0, 0.25, 0, 0);
    } completion:^(BOOL finished) {
        NSLog(@"%@: finished=%d, leftView.transform=%@, leftView.alpha=%f, leftView.frame=%@", NSStringFromSelector(_cmd), finished, NSStringFromCGAffineTransform(self.testOptionView.leftView.transform), self.testOptionView.leftView.alpha, NSStringFromCGRect(self.testOptionView.leftView.frame));
    }];
}

/** 测试performWithoutAnimation */
- (void)executePerformWithoutAnimation {
    [UIView performWithoutAnimation:^{
//        [self executeAnimationWithUIViewAnimationOptionAllowAnimatedContent]; // performWithoutAnimation无法去掉卷页效果，但可以去掉属性动画
        [self executePropertyAnimation]; // 外部包含performWithoutAnimation时，属性变化没有动画而是立即生效
        // 看网上的资料，performWithoutAnimation一般用于UITableView的reloadSections:withRowAnimation:。
    }];
}

/** 测试setAnimationsEnabled: */
- (void)executeSetAnimationsEnabled {
    [UIView animateWithDuration:1 delay:2 options:0 animations:^{
        self.testOptionView.alpha = 0.2;
        NSLog(@"(animation1) areAnimationsEnabled=%d", [UIView areAnimationsEnabled]);
    } completion:^(BOOL finished) {
        NSLog(@"%@: (animation1) finished=%d, areAnimationsEnabled=%d", NSStringFromSelector(_cmd), finished, [UIView areAnimationsEnabled]);
    }];
    [UIView setAnimationsEnabled:NO]; // 设置之后的animation属性修改立即生效没有动画，只对这句代码之后创建的animation有效，而这句之前创建的动画即使延迟还没有启动，在启动时还是有动画效果的
    [UIView animateWithDuration:1 delay:0 options:0 animations:^{
        self.testView.frame = CGRectMake(200, 70, 100, 120);
        NSLog(@"(animation2) areAnimationsEnabled=%d", [UIView areAnimationsEnabled]);
    } completion:^(BOOL finished) {
        NSLog(@"%@: (animation2) finished=%d, areAnimationsEnabled=%d", NSStringFromSelector(_cmd), finished, [UIView areAnimationsEnabled]);
    }];
}

@end
