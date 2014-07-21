//
//  SH_LightViewController.m
//  Smart_Home
//
//  Created by mobisys on 14-7-3.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_LightViewController.h"
#import "SH_Light.h"
#import "SH_Settings.h"

@interface SH_LightViewController ()
{
    SH_Settings * _settings;
    SH_Light    * _light ;
    UIImage     * _lightImage ;
    UILabel     * _labelBrightness ;
    UISlider    * _sliderBrightness ;
    UISwitch    * _switchLight ;
}


@end

@implementation SH_LightViewController

-(id)initWithLight:(SH_Light*)light
{
    self = [super init];
    if (self) {
        _light = light;
        
        _settings = [SH_Settings sharedSettings];
        _lightImage = [UIImage imageNamed:@"Light.jpg"];
        
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        _detailTableView.delegate = self ;
        _detailTableView.dataSource = self ;
        
        _labelBrightness = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80 , 44)];
        _labelBrightness.text =  @"亮度" ;
        _labelBrightness.backgroundColor = [UIColor clearColor];
        
        _sliderBrightness = [[UISlider alloc] initWithFrame:CGRectMake(100.0,6.0,200.0,0.0)];
        _sliderBrightness.maximumValue = 100.0f ;
        _sliderBrightness.minimumValue = 0.0f  ;
        _sliderBrightness.tag = 1 ;
        _sliderBrightness.continuous = YES ;
        [_sliderBrightness addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_sliderBrightness addTarget:self action:@selector(sliderchangeDone:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        CGRect switchFrame ;
        if (_settings.iosVersion >= 7.0) {
            switchFrame = CGRectMake(250, 7, 0, 0);
        }
        else
        {
            switchFrame = CGRectMake(220.0, 9, 0, 0) ;
        }
        _switchLight= [[UISwitch alloc]initWithFrame:switchFrame];
        [_switchLight addTarget:self action:@selector(switchLightTo:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _imageView.image = _lightImage ;
    self.title = [_light getName] ;
    _sliderBrightness.value = [_light getBrightness] ;
    [_switchLight setOn:_light.isOn animated:YES];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table_cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger row = [indexPath row] ;
    if (row == 0) {
        if (![_light isSupportBrightness]) {
            cell.textLabel.text = @"此灯不支持亮度调节" ;
            cell.textLabel.textColor = [UIColor grayColor];
            return cell ;
        }
        if ([_light isOn]) {
            _sliderBrightness.userInteractionEnabled = YES ;
        }
        else
        {
            _sliderBrightness.userInteractionEnabled = NO ;
        }
        [cell addSubview:_labelBrightness] ;
        [cell addSubview:_sliderBrightness];
    }
    else
    {
        cell.textLabel.text = @"开关" ;
        [cell addSubview:_switchLight];
    }
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
    
}

#pragma mark - public method
-(void)change_controlled_light:(SH_Light*)light
{
    _light = light ;
    self.title = [_light getName];
    [_detailTableView reloadData];
}

#pragma mark - Slider method
-(void)sliderValueChanged:(id)sender
{
    UISlider *act = (UISlider*)sender ;
    if (act.tag == 1 ) {
        int a = act.value ;
        _labelBrightness.text = [[NSString alloc] initWithFormat: @"%d",a];
    }
}

-(void)sliderchangeDone:(id)sender
{
    UISlider *act = (UISlider*)sender ;
    if (act.tag == 1 ) {// duration handle
        [_light setBrightness:act.value];
        _labelBrightness.text = @"亮度";
    }
}

#pragma mark - Switch action
-(void)switchLightTo:(id)sender
{
    UISwitch* sw = (UISwitch*)sender ;
    [_light turnLight:sw.isOn] ;
    if ([_light isOn] && [_light isSupportBrightness]) {
        _sliderBrightness.userInteractionEnabled = YES ;
    }
    else
    {
        _sliderBrightness.userInteractionEnabled = NO ;
    }
    //可以改变视图的颜色，或者其他的开关表现
}

@end
