//
//  SH_ListViewController.m
//  Smart_Home
//
//  Created by mobisys on 14-6-30.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_ContentListViewController.h"
#import "SH_Settings.h"
#import "SH_LightViewController.h"
#import "SH_RightSideViewController.h"
#import "SH_Light.h"
#import "SH_Equipment.h"

@interface SH_ContentListViewController ()
{
    enum SH_Content_State _state ;
    NSString* _room ;
    NSString* _equipmentName ;
    SH_Settings *_settings ;
    SwitchBlock _switchLeftBlock ;
    SwitchBlock _switchRightBlock ;
    UIImage * _lightImage;
    UIImage * _airConditionImage ;
    SH_LightViewController *_lightVC ;
    SH_RightSideViewController *_rightVC ;
}

@property (nonatomic,retain) UIImage *cellImage ;

@end

@implementation SH_ContentListViewController
{
}

- (id)initWithStyle:(UITableViewStyle)style withLeftSwitch:(SwitchBlock)lblock withRightBlock:(SwitchBlock)rblock
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _settings = [SH_Settings sharedSettings];
        _state = SH_Equipment_Show ;
        _room = @"" ;
        _equipmentName = @"灯具";
        self.title = @"灯具" ;
        _lightImage = [UIImage imageNamed:@"Light.jpg"];
        _airConditionImage = [UIImage imageNamed:@"AirCondition.jpg"];
        _switchLeftBlock = [lblock copy];
        _switchRightBlock = [rblock copy];
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"智能设备"
                                         style:UIBarButtonSystemItemDone
                                        target:self
                                        action:@selector(switch_left_bar)];
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"房间"
                                         style:UIBarButtonSystemItemDone
                                        target:self
                                        action:@selector(switch_right_bar)];
        _lightVC = [[SH_LightViewController alloc] initWithLight:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_state == SH_Equipment_Show) {
        return 1;
    }
    else
    {
        //这里需要返回每个房间的设备种类数量
        return [_settings.roomDeviceDic[_room] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_state == SH_Equipment_Show) {
        return [_settings.smartDeviceDic[_equipmentName] count];
    }
    else
    {
        return [_settings.roomDeviceDic[_room][_settings.smartDeviceList[section]] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    int row = [indexPath row];
    if (_state == SH_Equipment_Show) {
        if (_lightImage == nil) {
            _lightImage = [UIImage imageNamed:[_settings.smartDeviceDic[_equipmentName] getPicName]];
        }
        cell.imageView.image = _lightImage;
        cell.textLabel.text = [(SH_Light*)_settings.smartDeviceDic[_equipmentName][row] getName] ;
    }
    else
    {
        int section = indexPath.section ;
        int row = indexPath.row ;
        SH_Equipment* eq = (SH_Equipment*)_settings.roomDeviceDic[_room][_settings.smartDeviceList[section]][row];
        cell.imageView.image = [UIImage imageNamed:[eq getPicName]];
        cell.textLabel.text = [eq getName];
    }
    // Configure the cell...
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (_state == SH_Equipment_Show) {
        if ([_equipmentName isEqual: @"灯具"]) {
            [_lightVC change_controlled_light:_settings.smartDeviceDic[@"灯具"][row]];
            [self.navigationController pushViewController:_lightVC animated:YES];
        }
        else if([_equipmentName isEqual: @"空调"])
        {
            
        }
        else
        {
            
        }
    }
    else
    {
        int section = indexPath.section ;
        int row = indexPath.row ;
        SH_Equipment* eq = (SH_Equipment*)_settings.roomDeviceDic[_room][_settings.smartDeviceList[section]][row];
        if ([[eq getName] isEqualToString:@"灯具"]) {
            [_lightVC change_controlled_light:(SH_Light*)eq];
            [self.navigationController pushViewController:_lightVC animated:YES];
        }
    }
}

#pragma mark - Private method
-(void)switch_left_bar
{
    _switchLeftBlock();
}

-(void)switch_right_bar
{
    _switchRightBlock();
}

#pragma mark - Public method
-(void)change_tableview_to_equipment:(NSString*)equipmentName
{
    _state = SH_Equipment_Show ;
    _equipmentName = equipmentName ;
    self.title = _equipmentName ;
    [self.tableView reloadData];
}

-(void)change_tableview_to_room:(NSString*)roomName
{
    _state = SH_Room_Show ;
    _room = roomName ;
    self.title = _room ;
    [self.tableView reloadData];
}

@end
