//
//  AppDelegate.m
//  RCAnimation
//
//  Created by crx on 2021/4/11.
//

#import "AppDelegate.h"
#import "RCUIViewAnimationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    RCUIViewAnimationController *vc = [RCUIViewAnimationController new];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
