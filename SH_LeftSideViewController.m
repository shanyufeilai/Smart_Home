//
//  SH_HouseHoldViewController.m
//  Smart_Home
//
//  Created by mobisys on 14-6-30.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_LeftSideViewController.h"
#import "SH_SwitchViewController.h"
#import "SH_ContentListViewController.h"
#import "SH_Settings.h"
#import "SH_Equipment.h"

@interface SH_LeftSideViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SH_Settings *_settings ;
    SH_SwitchViewController *_swiftVC ;
    UITableView *_houseHoldTableView ;
    NSArray *_cellInfoList ;
}

@end

@implementation SH_LeftSideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
        
        _swiftVC.leftSideBarViewController = self ;
        _swiftVC.contentListNavVC = contentController ;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0.0f, 0.0f, SH_DefaultSidebarWidth, CGRectGetHeight(self.view.bounds));
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    CGFloat yPosition = 0.0f ;
    if (_settings.iosVersion>=7.0) {
        yPosition = 20.0f ;
    }
    _houseHoldTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, yPosition, SH_DefaultSidebarWidth, CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    _houseHoldTableView.dataSource = self ;
    _houseHoldTableView.delegate = self ;
    _houseHoldTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight ;
    _houseHoldTableView.backgroundColor = [UIColor clearColor];
    _houseHoldTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
    [self.view addSubview:_houseHoldTableView];
    [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animation:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_settings.smartDeviceList count] ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"table_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table_cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger row = [indexPath row] ;
    cell.textLabel.text = [_settings.smartDeviceList objectAtIndex:row] ;
    
    return cell;
}

#pragma mark - table view delegate
/*
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_swiftVC.contentListNavVC.topViewController isMemberOfClass:[SH_ContentListViewController class]]) {
        [_swiftVC.contentListNavVC popToRootViewControllerAnimated:NO];;
    }
    [_swiftVC.contentListNavVC.viewControllers[0] change_tableview_to_equipment:_settings.smartDeviceList[indexPath.row]];
    [_swiftVC toggle_left_side_bar:NO];
}

#pragma mark - other method
/*
 *  selectRowAtIndexPath的主要作用是响应用户在左侧边栏选择的内容，可以通知到其他的观察者
 */
-(void)selectRowAtIndexPath:(NSIndexPath*)indexPath   animation:(BOOL)isAnimation scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [_houseHoldTableView selectRowAtIndexPath:indexPath animated:isAnimation scrollPosition:scrollPosition];
}

@end
