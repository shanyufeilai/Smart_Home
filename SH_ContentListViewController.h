//
//  SH_ListViewController.h
//  Smart_Home
//
//  Created by mobisys on 14-6-30.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_Settings.h"
typedef void (^SwitchBlock)();

@interface SH_ContentListViewController : UITableViewController
{
    
}
- (id)initWithStyle:(UITableViewStyle)style withLeftSwitch:(SwitchBlock)lblock withRightBlock:(SwitchBlock)rblock ;

-(void)change_tableview_to_equipment:(NSString*)equipmentName ;

-(void)change_tableview_to_room:(NSString*)roomName ;


@end
