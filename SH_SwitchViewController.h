//
//  SH_SwitchViewController.h
//  Smart_Home
//
//  Created by mobisys on 14-6-30.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_ContentListViewController.h"
#import "SH_LeftSideViewController.h"
#import "SH_RightSideViewController.h"

extern const NSTimeInterval SH_SwitchDefaultAnimationDuration;
extern const CGFloat SH_DefaultSidebarWidth;

@interface SH_SwitchViewController : UIViewController
@property (nonatomic ) BOOL leftSideBarShowing ;
@property (nonatomic ) BOOL rightSideBarShowing ;
@property (nonatomic,retain) SH_LeftSideViewController *leftSideBarViewController ;
@property (nonatomic,retain) SH_RightSideViewController *rightSideBarViewController ;
@property (nonatomic,retain) UINavigationController *contentListNavVC ;

-(void)toggle_left_side_bar:(BOOL)istoshow ;
-(void)toggle_right_side_bar:(BOOL)istoshow ;
@end
