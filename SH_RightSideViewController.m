//
//  SH_RightSideViewController.m
//  Smart_Home
//
//  Created by mobisys on 14-7-13.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_RightSideViewController.h"
#import "SH_SwitchViewController.h"
#import "SH_ContentListViewController.h"
#import "SH_Settings.h"

@interface SH_RightSideViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SH_Settings *_settings ;
    SH_SwitchViewController *_swiftVC ;
    UITableView *_roomTableView ;
    NSArray *_cellInfoList ;
}
@end

@implementation SH_RightSideViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithSideBarController:(SH_SwitchViewController*)sideBarController
               withControllers:(UINavigationController*)contentController
                 withCellInfos:(NSArray *)cellInfoList
{
    self = [super initWithNibName:Nil bundle:Nil];
    if (self) {
        
        _settings = [SH_Settings sharedSettings];
        _swiftVC = sideBarController ;
        _cellInfoList = cellInfoList ;
        
        _swiftVC.rightSideBarViewController = self ;
        if (_swiftVC.contentListNavVC== nil) {
            _swiftVC.contentListNavVC = contentController ;
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0.0f, 0.0f, SH_DefaultSidebarWidth, CGRectGetHeight(self.view.bounds));
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    CGFloat yPosition = 0.0f ;
    if (_settings.iosVersion>=7.0) {
        yPosition = 20.0f ;
    }
    _roomTableView = [[UITableView alloc] initWithFrame:CGRectMake(320.0f-SH_DefaultSidebarWidth, yPosition, SH_DefaultSidebarWidth, CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    _roomTableView.dataSource = self ;
    _roomTableView.delegate = self ;
    _roomTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight ;
    _roomTableView.backgroundColor = [UIColor clearColor];
    _roomTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
    [self.view addSubview:_roomTableView];
    [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animation:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_settings.roomList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"table_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table_cell"];
    }
    UILabel *rlabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SH_DefaultSidebarWidth-10.0f, 44.0f)];
    rlabel.textAlignment = NSTextAlignmentRight;
    rlabel.backgroundColor = [UIColor clearColor];
    NSUInteger row = [indexPath row] ;
    rlabel.text = [_settings.roomList objectAtIndex:row] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:rlabel];
    return cell;
}

#pragma mark - table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_swiftVC.contentListNavVC.topViewController isMemberOfClass:[SH_ContentListViewController class]]) {
        [_swiftVC.contentListNavVC popToRootViewControllerAnimated:NO];;
    }
    [_swiftVC.contentListNavVC.viewControllers[0] change_tableview_to_room:_settings.roomList[indexPath.row]];
    [_swiftVC toggle_right_side_bar:NO];
}


#pragma mark - other method
/*
 *  selectRowAtIndexPath的主要作用是响应用户在左侧边栏选择的内容，可以通知到其他的观察者
 */
-(void)selectRowAtIndexPath:(NSIndexPath*)indexPath   animation:(BOOL)isAnimation scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [_roomTableView selectRowAtIndexPath:indexPath animated:isAnimation scrollPosition:scrollPosition];
}
@end
