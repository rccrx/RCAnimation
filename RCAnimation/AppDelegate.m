//
//  AppDelegate.m
//  RCAnimation
//
//  Created by crx on 2021/4/11.
//

#import "AppDelegate.h"
#import "RCUIViewAnimationController.h"
#import "RCCoreAnimationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UITabBarController *tbController = [[UITabBarController alloc] init];
    
    RCCoreAnimationController *caVC = [RCCoreAnimationController new];
    caVC.tabBarItem.title = @"Core Animation";
    [tbController addChildViewController:caVC];
    
    RCUIViewAnimationController *vaVC = [RCUIViewAnimationController new];
    vaVC.tabBarItem.title = @"UIView动画";
    [tbController addChildViewController:vaVC];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tbController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
