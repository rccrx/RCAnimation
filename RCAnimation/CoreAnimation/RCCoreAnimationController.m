//
//  RCCoreAnimationController.m
//  RCAnimation
//
//  Created by crx on 2021/8/16.
//

#import "RCCoreAnimationController.h"

#define TempLayerName @"D" /**< 重置视图时应该移除的图层的name */

@interface RCCoreAnimationController ()

@end

@implementation RCCoreAnimationController

#pragma mark - 生命周期 与 按钮点击
/** self.view添加一个按钮 */
- (void)selfViewAddButtonWithOriginY:(CGFloat)y leftOrRight:(BOOL)isLeft title:(NSString *)title tag:(NSInteger)tag {
    CGFloat marginH = 5;
    CGFloat buttonWidth = (CGRectGetWidth(UIScreen.mainScreen.bounds)-marginH) * 0.5;
    CGFloat buttonHeight = 30;
    CGFloat x = isLeft? 0 : (buttonWidth+marginH);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, buttonWidth, buttonHeight)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [self.view addSubview:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:208/255.0 green:255/255.0 blue:216/255.0 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self selfViewAddButtonWithOriginY:250 leftOrRight:YES title:@"重置视图" tag:99];
    [self selfViewAddButtonWithOriginY:250 leftOrRight:NO title:@"CALayer和CAShapeLayer" tag:1];
    [self selfViewAddButtonWithOriginY:300 leftOrRight:YES title:@"CATextLayer" tag:2];
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
            [self testCALayerAndCAShapeLayer];
            break;
        }
        case 2:
        {
            [self testCATextLayer];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Core Animation相关代码
/** 恢复视图 */
- (void)resetView {
    NSArray *sublayers = [self.view.layer.sublayers copy];
    for (CALayer *layer in sublayers) {
        if ([layer.name isEqualToString:TempLayerName]) {
            [layer removeFromSuperlayer];
        }
    }
}

/** 测试CALayer和CAShapeLayer */
- (void)testCALayerAndCAShapeLayer {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(20, 50, 200, 150);
//    layer.backgroundColor = [UIColor blueColor].CGColor;
    layer.borderColor = [UIColor greenColor].CGColor;
    layer.borderWidth = 5;
    layer.shadowColor = [UIColor redColor].CGColor; // ❗️⚠️没有设置shadowPath时：阴影也会应用到子图层，本图层和子图层的不透明边框、带有alpha通道的图片不透明部分有阴影；backgroundColor会遮盖阴影
    layer.shadowOffset = CGSizeMake(15, 15);
    layer.shadowOpacity = 1;
//    layer.shadowPath = CGPathCreateWithRoundedRect(layer.bounds, 50, 50, nil); // 设置阴影的形状，所以阴影的形状不再是本图层和子图层的不透明部分的形状
    layer.contents = (id)[UIImage imageNamed:@"butterfly"].CGImage;
    layer.contentsGravity = kCAGravityResizeAspect; // 对内容图片进行调整
    layer.name = TempLayerName;
    [self.view.layer addSublayer:layer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.bounds = CGRectMake(0, 0, 30, 100);
    shapeLayer.position = CGPointMake(CGRectGetWidth(shapeLayer.bounds)*0.5, 50); // position指的是子图层的anchorPoint相对于父图层的位置，子图层的anchorPoint在中心点，由于anchorPoint的取值在0-1所以是{0.5, 0.5}
    NSLog(@"%@: shapeLayer.anchorPoint=%@", NSStringFromSelector(_cmd), NSStringFromCGPoint(shapeLayer.anchorPoint));
    shapeLayer.borderColor = [UIColor purpleColor].CGColor;
    shapeLayer.borderWidth = 2;
    shapeLayer.path = CGPathCreateWithEllipseInRect(CGRectMake(5, 20, 20, 60), nil);
    [layer addSublayer:shapeLayer];
}

/** 测试CATextLayer */
- (void)testCATextLayer {
//    CATextLayer
}

@end
