//
//  SH_HouseHoldViewController.h
//  Smart_Home
//
//  Created by mobisys on 14-6-30.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SH_SwitchViewController;
@class SH_ContentListViewController;

@interface SH_LeftSideViewController : UIViewController

-(id)initWithSideBarController:(SH_SwitchViewController*)sideBarController
               withControllers:(UINavigationController*)contentController
                 withCellInfos:(NSArray*)cellInfoList ;

@end
