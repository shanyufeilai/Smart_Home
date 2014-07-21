//
//  SH_LightViewController.h
//  Smart_Home
//
//  Created by mobisys on 14-7-3.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SH_Light;

@interface SH_LightViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITableView *detailTableView;

-(id)initWithLight:(SH_Light*)light ;

-(void)change_controlled_light:(SH_Light*)light ;


@end
