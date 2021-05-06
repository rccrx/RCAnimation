//
//  RCUIViewAnimationController.m
//  RCAnimation
//
//  Created by crx on 2021/5/5.
//

#import "RCUIViewAnimationController.h"

@interface RCUIViewAnimationController ()
/** 测试视图 */
@property (nonatomic, strong) UILabel *testView;
@end

@implementation RCUIViewAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _testView = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 100)];
    self.testView.backgroundColor = [UIColor redColor];
    self.testView.text = @"测试文字";
    [self.view addSubview:self.testView];
    
    [self selfViewAddButtonWithOriginY:200 title:@"测试属性动画" tag:1];
    
    
}

/** self.view添加一个按钮 */
- (void)selfViewAddButtonWithOriginY:(CGFloat)y title:(NSString *)title tag:(NSInteger)tag {
    CGFloat buttonWidth = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat buttonHeight = 30;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, buttonWidth, buttonHeight)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [self.view addSubview:button];
}

/** 按钮点击事件 */
- (void)buttonClicked:(UIButton *)button {
    NSInteger tag = button.tag;
    NSLog(@"点击了按钮（tag=%ld）", tag);
    switch (tag) {
        case 1:
        {
            [self executePropertyAnimation];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - 动画相关代码
/** 测试属性动画 */
- (void)executePropertyAnimation {
    // 将属性恢复成原来的样子，重新执行动画
    self.testView.transform = CGAffineTransformIdentity; // 由于transform不等于identity时，frame是无效的，所以如果想恢复变形之后的视图为原来的样子，必须先将transform修改成identity才能修改frame。如果先修改frame再修改为identity则无法恢复原来的样子。
    self.testView.frame = CGRectMake(50, 50, 200, 100);
    self.testView.backgroundColor = [UIColor redColor];
    
    // 开始执行动画
    [UIView animateWithDuration:1 delay:1 options:0 animations:^{
        /*
         frame、bound、center、transform、alpha、backgroundColor，修改这些属性都有动画效果
         */
//        self.testView.frame = CGRectMake(100, 70, 100, 120); // 修改位置和大小
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



@end
