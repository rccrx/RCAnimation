//
//  RCCoreAnimationController.m
//  RCAnimation
//
//  Created by crx on 2021/8/16.
//

#import "RCCoreAnimationController.h"

#define TempLayerName @"D" /**< 重置视图时应该移除的图层的name */
#define TempViewTag 100 /**< 重置视图时应该移除的视图的tag */
#define TempAnimationKey @"K" /**< 动画的key */

@interface RCCoreAnimationController () <CALayerDelegate>

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
    
    [self selfViewAddButtonWithOriginY:250 leftOrRight:NO title:@"重置视图" tag:99];
    [self selfViewAddButtonWithOriginY:250 leftOrRight:YES title:@"CALayer和CAShapeLayer" tag:1];
    [self selfViewAddButtonWithOriginY:300 leftOrRight:YES title:@"CATextLayer" tag:2];
    [self selfViewAddButtonWithOriginY:300 leftOrRight:NO title:@"CAGradientLayer" tag:3];
    [self selfViewAddButtonWithOriginY:350 leftOrRight:YES title:@"CAEmitterLayer" tag:4];
    [self selfViewAddButtonWithOriginY:350 leftOrRight:NO title:@"CAScrollLayer" tag:5];
    [self selfViewAddButtonWithOriginY:400 leftOrRight:YES title:@"CATiledLayer" tag:6];
    [self selfViewAddButtonWithOriginY:400 leftOrRight:NO title:@"CAReplicatorLayer" tag:7];
    [self selfViewAddButtonWithOriginY:450 leftOrRight:YES title:@"CABasicAnimation" tag:8];
    [self selfViewAddButtonWithOriginY:450 leftOrRight:NO title:@"CAKeyframeAnimation" tag:9];
    [self selfViewAddButtonWithOriginY:500 leftOrRight:YES title:@"CASpringAnimation" tag:10];
    [self selfViewAddButtonWithOriginY:500 leftOrRight:NO title:@"CATransition" tag:11];
    [self selfViewAddButtonWithOriginY:550 leftOrRight:YES title:@"CAAnimationGroup" tag:12];
    [self selfViewAddButtonWithOriginY:550 leftOrRight:NO title:@"CADisplayLink或其他" tag:13]; // 修改buttonClicked的”case 13:“的代码
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
        case 3:
        {
            [self testCAGradientLayer];
            break;
        }
        case 4:
        {
            [self testCAEmitterLayer];
            break;
        }
        case 5:
        {
            [self testCAScrollLayer];
            break;
        }
        case 6:
        {
            [self testCATiledLayer];
            break;
        }
        case 7:
        {
            [self testCAReplicatorLayer];
            break;
        }
        case 8:
        {
            [self testCABasicAnimation];
            break;
        }
        case 9:
        {
            [self testCAKeyframeAnimation];
            break;
        }
        case 10:
        {
            [self testCASpringAnimation];
            break;
        }
        case 11:
        {
            [self testCATransition];
            break;
        }
        case 12:
        {
            [self testCAAnimationGroup];
            break;
        }
        case 13:
        {
//            [self testCADisplayLink];
//            [self testCAMediaTimingFunction];
            [self testCalculationMode];
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
    
    UIView *subview = [self.view viewWithTag:TempViewTag];
    [subview removeFromSuperview];
    
    NSLog(@"%@", [self.view.layer animationForKey:TempAnimationKey]);
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
    for (int i = 0; i < 3; i++) {
        CATextLayer *layer = [CATextLayer layer];
        layer.name = TempLayerName;
        layer.string = @"CATextLayer";
        layer.backgroundColor = [UIColor blueColor].CGColor;
        layer.fontSize = 17;
        
        if (i == 0) {
            layer.frame = CGRectMake(20, 50, 100, 50);
            layer.allowsFontSubpixelQuantization = NO;
        } else if (i == 1) {
            layer.frame = CGRectMake(150, 50, 100, 50);
            layer.allowsFontSubpixelQuantization = YES;
        } else {
            layer.frame = CGRectMake(20, 150, 100, 50);
//            layer.frame = CGRectMake(150, 300+4.5, 100, 30);
//            layer.allowsFontSubpixelQuantization = NO;
//            layer.allowsFontSubpixelQuantization = YES; // 不知道allowsFontSubpixelQuantization有什么作用
            layer.contentsScale = [UIScreen mainScreen].scale; // 一开始文字比UIButton模糊，修改contentsScale可以让文字和UIButton的文字一样
            
        }
        
        [self.view.layer addSublayer:layer];
    }
}

/** 测试CAGradientLayer */
- (void)testCAGradientLayer {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.name = TempLayerName;
    layer.frame = CGRectMake(20, 50, 320, 50);
    layer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor blueColor].CGColor];
    layer.locations = @[@0.2, @0.5, @0.6]; // 表示0.2的位置是红色，0.5的位置是绿色，0-0.2之间为红色，0.2-0.5之间从红色过渡到绿色
    NSLog(@"%@: startPoint=%@", NSStringFromSelector(_cmd), NSStringFromCGPoint(layer.startPoint));
    layer.startPoint = CGPointMake(1, 1); // 默认是{0.5, 0}，表示上边界中间，是颜色梯度的起始点，也就是红色的位置
    layer.endPoint = CGPointMake(0.2, 0.3);
//    layer.type = kCAGradientLayerAxial; // kCAGradientLayerAxial颜色交接处为直线；kCAGradientLayerRadial颜色交接处为弧形
    [self.view.layer addSublayer:layer];
}

/** 测试CAEmitterLayer */
- (void)testCAEmitterLayer {
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 50; // 每秒发射多少个
    cell.lifetime = 10;
    cell.velocity = -100; // 负数则方向向下
    cell.scale = 0.2; // 对原图片的缩放
    cell.emissionRange = M_PI_4 * 2; // 发射范围
    cell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"petal"].CGImage);
    cell.color = [UIColor systemPinkColor].CGColor; // 修改图片颜色
    cell.blueRange = 0.9;
    cell.spin = M_PI / 6.0; // 设置图片旋转，每秒多少弧度
    
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.name = TempLayerName;
    layer.emitterPosition = CGPointMake(50, 50); // 发射位置
    layer.emitterCells = @[cell];
    
    layer.emitterSize = CGSizeMake(600, 1); // 设置发射器的shape的大小，为了实现从一条水平线中出现粒子，需要设置足够宽
    layer.emitterShape = kCAEmitterLayerLine; // 发射器形状，默认是point
    
    [self.view.layer addSublayer:layer];
}

/** 测试CAScrollLayer */
- (void)testCAScrollLayer {
    CAGradientLayer *sublayer = [CAGradientLayer new];
    sublayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    sublayer.startPoint = CGPointMake(0, 0);
    sublayer.endPoint = CGPointMake(1, 1);
    sublayer.frame = CGRectMake(50, 50, 500, 600);
    
    CAScrollLayer *layer = [CAScrollLayer layer];
    layer.frame = CGRectMake(20, 50, 200, 150);
    layer.name = TempLayerName;
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [layer addSublayer:sublayer];
//    [layer scrollToPoint:CGPointMake(30, 0)]; // 只有scrollMode包含水平方向时，point.x才会生效，将sublayer在原frame的基础上向左平移30
//    [layer scrollToPoint:CGPointMake(-30, 0)]; // sublayer向右平移30
//    [layer scrollToPoint:CGPointMake(0, -30)]; // 30向上，-30向下
//    [layer scrollToPoint:CGPointMake(300, 300)];
    [self.view.layer addSublayer:layer];
    // CAScrollLayer创建后，并不响应任何手势
    
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(230, 50, 100, 150);
    scrollView.backgroundColor = [UIColor greenColor];
    scrollView.tag = TempViewTag;
    UIView *view = [UIView new];
    view.frame = CGRectMake(50, 50, 500, 600);
    view.backgroundColor = [UIColor cyanColor];
    [scrollView addSubview:view];
    scrollView.contentSize = CGSizeMake(500+50, 600); // 设置contentSize才能滚动
    [self.view addSubview:scrollView];
}

/** 测试CATiledLayer */
- (void)testCATiledLayer {
    CATiledLayer *layer = [CATiledLayer layer];
    layer.name = TempLayerName;
    layer.backgroundColor = [UIColor blueColor].CGColor;
//    layer.contents = (__bridge id)[UIImage imageNamed:@"butterfly.jpeg"].CGImage; // CATiledLayer不能直接设置contents，而应该在drawLayer:inContext:中添加，这个方法会在填充tile时多次调用
    layer.delegate = self;
    layer.frame = CGRectMake(20, 50, 300, 150);
    layer.tileSize = CGSizeMake(20, 20);
    [self.view.layer addSublayer:layer];
}
/** CALayerDelegate的方法 */
- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx {
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    UIGraphicsPushContext(ctx);
    UIImage *tileImage = nil; // CATiledLayer一般用于显示大图的一部分
    if (arc4random_uniform(2) == 0) {
        tileImage = [UIImage imageNamed:@"mountain"];
    } else {
        tileImage = [UIImage imageNamed:@"petal"];
    }
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

/** 测试CAReplicatorLayer */
- (void)testCAReplicatorLayer {
    CALayer *sublayer = [CALayer layer];
    sublayer.frame = CGRectMake(0, 0, 50, 50);
    sublayer.cornerRadius = CGRectGetWidth(sublayer.frame) * 0.5;
    sublayer.backgroundColor = [UIColor redColor].CGColor;
    sublayer.borderWidth = 1;
    
    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
    layer.name = TempLayerName;
    layer.frame = CGRectMake(20, 50, 300, 150);
    [layer addSublayer:sublayer];
    layer.instanceCount = 5;
    layer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0); // 第k个实例相对于第k-1的偏移，不设置时是重合的
//    layer.instanceDelay = 2; // 给sublayer加动画时才生效
    [self.view.layer addSublayer:layer];
}

- (void)testCABasicAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 1;
    animation.repeatCount = 3;
    animation.removedOnCompletion = YES; // YES表示动画结束之后移除，移除之后使用animationForKey获取不到这个动画；但是，使用dispatch_after会获取到，点击其他按钮调用animationForKey获取不到，也许是因为要等到下一个runloop才移除动画？
    [self.view.layer addAnimation:animation forKey:TempAnimationKey];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", [self.view.layer animationForKey:TempAnimationKey]);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", [self.view.layer animationForKey:TempAnimationKey]);
    });
}

- (void)testCAKeyframeAnimation {
    CALayer *layer = [CALayer layer];
    layer.name = TempLayerName;
    layer.frame = CGRectMake(20, 50, 10, 10);
    layer.backgroundColor = UIColor.redColor.CGColor;
    [self.view.layer addSublayer:layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 20, 50); // 其实layer的初始position是(25, 55)，所以设置点为(20, 50)会导致动画结束时layer的位置从(20, 50)跳到(25, 55)
    CGPathAddLineToPoint(path, NULL, 120, 50);
    CGPathAddLineToPoint(path, NULL, 120, 150);
    CGPathAddLineToPoint(path, NULL, 20, 150);
    CGPathAddLineToPoint(path, NULL, 20, 50);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    animation.path = CGPathCreateWithRoundedRect(CGRectMake(20, 50, 200, 200), 100, 100, nil); // 默认calculationMode是linear，不设置keyTimes，这个path会在四个关键点有停顿
    animation.path = path;
    animation.duration = 5;
    animation.keyTimes = @[@0, @0.25, @0.5, @0.75, @1]; // 元素数量和path控制点数量一样
    [layer addAnimation:animation forKey:TempAnimationKey];
}

- (void)testCASpringAnimation {
    CALayer *layer = [CALayer layer];
    layer.name = TempLayerName;
    layer.frame = CGRectMake(20, 50, 10, 10);
    layer.backgroundColor = UIColor.redColor.CGColor;
    [self.view.layer addSublayer:layer];
    
    CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"position"];
    animation.duration = 1;
    animation.damping = 2;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(25, 55)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 55)];
    animation.fillMode = kCAFillModeForwards; // 动画结束时使layer保持终止状态，xxForwards必须设置removedOnCompletion为NO才生效
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:TempAnimationKey];
}

- (void)testCATransition {
    CALayer *layer = [CALayer layer];
    layer.name = TempLayerName;
    layer.frame = CGRectMake(20, 50, 300, 150);
    layer.backgroundColor = UIColor.redColor.CGColor;
    [self.view.layer addSublayer:layer];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:TempAnimationKey]; // self.view.layer图层的变化会有从右往左显露的效果，比如从无红色子图层layer到有
}

- (void)testCAAnimationGroup {
    CALayer *sublayer = [CALayer layer];
    sublayer.frame = CGRectMake(0, 0, 50, 50);
    sublayer.cornerRadius = CGRectGetWidth(sublayer.frame) * 0.5;
    sublayer.backgroundColor = [UIColor redColor].CGColor;
    sublayer.borderWidth = 1;

    
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @1;
    alpha.toValue = @0;
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 2)];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[alpha, scale];
    animationGroup.duration = 3;
    [sublayer addAnimation:animationGroup forKey:TempAnimationKey];
    
    
    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
    layer.name = TempLayerName;
    layer.frame = CGRectMake(120, 100, 300, 150);
    [layer addSublayer:sublayer];
    layer.instanceCount = 2;
    layer.instanceDelay = 1; // 给sublayer加动画时才生效
    [self.view.layer addSublayer:layer];
}

- (void)testCADisplayLink {
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkSelector:)];
    displayLink.preferredFramesPerSecond = 30; // 如果不设置，则偏好帧率等于显示的最大刷新率即maximumFramesPerSecond
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkSelector:(CADisplayLink *)sender {
    // 这个方法的调用间隔时间由preferredFramesPerSecond控制
    // duration是每帧持续时间，但这个时间不是实际的帧持续时间，而是maximumFramesPerSecond（即60）的帧之间的时间，等于0.016667
    // 实际的帧持续时间，用targetTimestamp-timestamp
    // timestamp上一帧显示的时间，targetTimestamp下一帧显示的时间
    // targetTimestamp-CACurrentMediaTime表示系统提供了这么多时间可用于渲染下一帧，如果这段时间内无法提供下一帧，则会导致丢帧。所以可以设置preferredFramesPerSecond使用低帧率，一个较慢但是连续的帧率看起来会比丢帧更平缓。
    NSLog(@"[%@ : %@], duration=%f, timestamp=%f, targetTimestamp=%f, targetTimestamp-timestamp=%f, targetTimestamp-CACurrentMediaTime=%f", NSStringFromClass(self.class), NSStringFromSelector(_cmd),
          sender.duration,
          sender.timestamp,
          sender.targetTimestamp,
          sender.targetTimestamp - sender.timestamp,
          sender.targetTimestamp - CACurrentMediaTime());
}

- (void)testCAMediaTimingFunction {
    CALayer *layer = [CALayer layer];
    layer.name = TempLayerName;
    layer.frame = CGRectMake(80, 50, 10, 10);
    layer.backgroundColor = UIColor.redColor.CGColor;
    [self.view.layer addSublayer:layer];
    
//    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // [(0,0), c1, c2, (1,1)]为贝塞尔曲线控制点，第一、二参数表示(c1x, c1y)，第三、四参数表示(c2x, c2y)。
//    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:0.8 :0.2 :1 :0.2]; // 前期很慢，后面很快
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:0.5 :-1 :1 :0]; // 前期增量为负值，从大约时间*0.4开始，开始增量为正，且增量越来越快。CAMediaTimingFunction的x轴表示时间，y轴表示fromValue到toValue的增量，y轴值为1表示到达toValue，为0.2表示到达fromValue+(toValue-fromValue)*0.2。
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(85, 55)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(UIScreen.mainScreen.bounds.size.width * 0.5, 55)];
    animation.duration = 1;
    animation.timingFunction = function;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:TempAnimationKey];
}

- (void)testCalculationMode {
    CALayer *layer = [CALayer layer];
    layer.name = TempLayerName;
    layer.frame = CGRectMake(20, 50, 10, 10);
    layer.backgroundColor = UIColor.redColor.CGColor;
    [self.view.layer addSublayer:layer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(25, 55)],
                         [NSValue valueWithCGPoint:CGPointMake(125, 55)],
                         [NSValue valueWithCGPoint:CGPointMake(125, 155)]];
//    animation.path = CGPathCreateWithRoundedRect(CGRectMake(20, 50, 200, 200), 100, 100, nil); // 设置calculationMode为paced，就不会在四个关键点有停顿，默认的linear会
    animation.duration = 2;
    animation.keyTimes = @[@0, @0.2, @1];
//    animation.calculationMode = kCAAnimationDiscrete; // 位置跳变，且无最后一个点位置
    animation.calculationMode = kCAAnimationPaced; // keyTimes设置被忽略
//    animation.calculationMode = kCAAnimationCubic; // 路径像一个曲线
    [layer addAnimation:animation forKey:TempAnimationKey];
}

@end
