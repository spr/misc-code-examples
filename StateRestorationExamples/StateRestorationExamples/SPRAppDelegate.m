//
//  SPRAppDelegate.m
//  StateRestorationExamples
//
//  Created by Scott Robertson on 1/13/14.
//  Copyright (c) 2014 Scott Robertson. All rights reserved.
//

#import "SPRAppDelegate.h"

#import "SPRBasicViewController.h"

@implementation SPRAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Create a UINavigation Controller
    UINavigationController *rootVC = [[UINavigationController alloc] init];
    rootVC.restorationIdentifier = @"theRoot";
    
    self.window.rootViewController = rootVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UINavigationController *rootVC = (UINavigationController *)self.window.rootViewController;
    if (!rootVC.topViewController) {
        NSLog(@"Not coming back from a state restore");
        // Create a root node for our nav controller
        SPRBasicViewController *basic = [[SPRBasicViewController alloc] init];
        // we made it so this automatically participates in the init function, so we're done
        [rootVC pushViewController:basic animated:NO];
    } else {
        NSLog(@"Coming back from state restoration");
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
