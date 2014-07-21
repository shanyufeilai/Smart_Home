//
//  SH_AppDelegate.m
//  Smart_Home
//
//  Created by mobisys on 14-6-27.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_AppDelegate.h"
#import "SH_SwitchViewController.h"
#import "SH_Settings.h"
#import "SH_LeftSideViewController.h"
#import "SH_ContentListViewController.h"
#import "SH_Equipment.h"
#import "SH_RightSideViewController.h"

@interface SH_AppDelegate()
@property (nonatomic,retain) SH_SwitchViewController* switchController ;
@property (nonatomic,retain) SH_LeftSideViewController* leftSideBarController ;
@property (nonatomic,retain) SH_RightSideViewController* rightSideBarController ;
@property (nonatomic,retain) SH_ContentListViewController* contentController ;

@end

@implementation SH_AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.switchController = [[SH_SwitchViewController alloc] initWithNibName:Nil bundle:nil];
    self.switchController.view.backgroundColor = bgColor ;
    SwitchBlock switchLightBlock = ^(){
		[self.switchController toggle_left_side_bar:!self.switchController.leftSideBarShowing];
	};
    SwitchBlock switchRightBlock = ^(){
		[self.switchController toggle_right_side_bar:!self.switchController.rightSideBarShowing];
	};
    
    self.contentController = [[SH_ContentListViewController alloc] initWithStyle:UITableViewStylePlain
                                                                  withLeftSwitch:switchLightBlock
                                                                  withRightBlock:switchRightBlock];
    
    UINavigationController* contentNavVC = [[UINavigationController alloc] initWithRootViewController:self.contentController];
    self.leftSideBarController = [[SH_LeftSideViewController alloc] initWithSideBarController:self.switchController
                                                                               withControllers:contentNavVC
                                                                                 withCellInfos:nil];
    self.rightSideBarController = [[SH_RightSideViewController alloc] initWithSideBarController:self.switchController
                                                                                withControllers:contentNavVC
                                                                                  withCellInfos:nil];
    
    self.window.rootViewController = self.switchController ;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
