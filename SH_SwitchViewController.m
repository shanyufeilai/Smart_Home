//
//  SH_SwitchViewController.m
//  Smart_Home
//
//  Created by mobisys on 14-6-30.
//  Copyright (c) 2014年 mobisys. All rights reserved.
//

#import "SH_SwitchViewController.h"
#import "SH_Settings.h"
#import "SH_HTTPRequestAndHandler.h"

const NSTimeInterval SH_SwitchDefaultAnimationDuration = 0.25 ;
const CGFloat SH_DefaultSidebarWidth = 260.0f ;

@interface SH_SwitchViewController ()
{
    UIView *_leftSideBarView ;
    UIView *_rightSideBarView ;
	UIView *_contentView ;
    UITapGestureRecognizer *_tapGer ;
    SH_Settings *_settings;
    SH_HTTPRequestAndHandler *_httpHandler ;
    
}

@end

@implementation SH_SwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.leftSideBarShowing = NO ;
        self.rightSideBarShowing = NO ;
        
        _settings = [SH_Settings sharedSettings];
        _httpHandler = [SH_HTTPRequestAndHandler Shared];
        
        _tapGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide_side_bar)];
        _tapGer.cancelsTouchesInView = YES ;
        
        self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ;
        
        _rightSideBarView = [[UIView alloc] initWithFrame:self.view.bounds] ;
        //[_rightSideBarView addSubview:self.leftSideBarViewController.view] ;
        _rightSideBarView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ;
        _rightSideBarView.backgroundColor = [UIColor clearColor] ;
        [self.view addSubview:_rightSideBarView];
        
        _leftSideBarView = [[UIView alloc] initWithFrame:self.view.bounds] ;
        //[_leftSideBarView addSubview:self.leftSideBarViewController.view] ;
        _leftSideBarView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ;
        _leftSideBarView.backgroundColor = [UIColor clearColor] ;
        [self.view addSubview:_leftSideBarView];
        
        /*
         * Test UIView
         *
        UIView* testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
        testView.backgroundColor = [UIColor whiteColor];
         *
         *
         */
        
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds] ;
        //UITableView* tableView_temp = ((UITableViewController*)self.contentListNavVC.viewControllers[0]).tableView;
        //[_contentView addSubview:tableView_temp];
        //[_contentView addSubview:testView];
        _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight) ;
        _contentView.backgroundColor = [UIColor clearColor] ;
        _contentView.layer.masksToBounds = NO ;
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f) ;
        _contentView.layer.shadowOpacity = 1.0f ;
        _contentView.layer.shadowRadius = 2.5f ;
        _contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_contentView.bounds].CGPath ;
        [self.view addSubview:_contentView];
    }
    return self;
}

#pragma mark - override setter method
-(void)setLeftSideBarViewController:(SH_LeftSideViewController*)leftVC
{
    if (_leftSideBarViewController == nil) {
        leftVC.view.frame = _leftSideBarView.bounds;
        leftVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight ;
        _leftSideBarViewController = leftVC ;
        [self addChildViewController:_leftSideBarViewController];
        [_leftSideBarView addSubview:_leftSideBarViewController.view];
        [_leftSideBarViewController didMoveToParentViewController:self];
    }
    else if (_leftSideBarViewController != leftVC)
    {
        leftVC.view.frame = _leftSideBarView.bounds;
        leftVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[_leftSideBarViewController willMoveToParentViewController:nil];
		[self addChildViewController:leftVC];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_leftSideBarViewController
						  toViewController:leftVC
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_leftSideBarViewController removeFromParentViewController];
									[leftVC didMoveToParentViewController:self];
									_leftSideBarViewController = leftVC;
								}
		 ];
    }
}

-(void)setRightSideBarViewController:(SH_RightSideViewController*)rightVC
{
    if (_rightSideBarViewController == nil) {
        rightVC.view.frame = _rightSideBarView.bounds;
        rightVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight ;
        _rightSideBarViewController = rightVC ;
        [self addChildViewController:_rightSideBarViewController];
        [_rightSideBarView addSubview:_rightSideBarViewController.view];
        [_rightSideBarViewController didMoveToParentViewController:self];
    }
    else if (_rightSideBarViewController != rightVC)
    {
        rightVC.view.frame = _rightSideBarView.bounds;
        rightVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		[_rightSideBarViewController willMoveToParentViewController:nil];
		[self addChildViewController:rightVC];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_rightSideBarViewController
						  toViewController:rightVC
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_rightSideBarViewController removeFromParentViewController];
									[rightVC didMoveToParentViewController:self];
									_rightSideBarViewController = rightVC;
								}
		 ];
    }
}

-(void)setContentListNavVC:(UINavigationController*)cNavVC
{
    if (_contentListNavVC == nil) {
		cNavVC.view.frame = _contentView.bounds;
		_contentListNavVC = cNavVC;
		[self addChildViewController:_contentListNavVC];
		[_contentView addSubview:_contentListNavVC.view];
		[_contentListNavVC didMoveToParentViewController:self];
	} else if (_contentListNavVC != cNavVC) {
		cNavVC.view.frame = _contentView.bounds;
		[_contentListNavVC willMoveToParentViewController:nil];
		[self addChildViewController:cNavVC];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_contentListNavVC
						  toViewController:cNavVC
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_contentListNavVC removeFromParentViewController];
									[cNavVC didMoveToParentViewController:self];
									_contentListNavVC = cNavVC;
								}
         ];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hide_side_bar
{
    if (_leftSideBarShowing) {
        [self toggle_left_side_bar:NO];
    }
    
    if (_rightSideBarShowing) {
        [self toggle_right_side_bar:NO];
    }
    
}

#pragma mark - private method
-(void)start_fetch_infos_http_request
{
    __weak SH_Settings *_weakSettings = _settings ;
    NSDictionary* dic = @{@"method":@"fetchInfos",
                          @"userName":@"admin",
                          @"password":@"cy_pwd",
                          };
    void (^fetchInfoCallBackBlock)(NSData* infos , enum SH_HTTP_Request_State state)=^(NSData* infos , enum SH_HTTP_Request_State state)
    {
        if (state == SH_Request_Success) {
            NSDictionary *info_dic = [NSJSONSerialization JSONObjectWithData:infos
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:Nil];
            _weakSettings.smartDeviceDic = info_dic ;
        }
        else
        {
            NSLog(@"Fetching all devices' info failed, because %@",infos);
        }
    };
    [_httpHandler httpRequest:dic
                  requestMethod:HTTP_POST
                withURLString:@"/fetchAllInfos"
                    withBlock:fetchInfoCallBackBlock];
}

#pragma mark - public method
-(void)toggle_left_side_bar:(BOOL)istoshow
{
    //NSLog(@"left side bar user interact is %d",_leftSideBarView.userInteractionEnabled);
    __weak SH_SwitchViewController *selfRef = self ;
    void(^animations)(void) = ^{
        if (istoshow) {
            _contentView.frame = CGRectOffset(_contentView.bounds, SH_DefaultSidebarWidth, 0.0f) ;
            [_contentView addGestureRecognizer:_tapGer];
            [selfRef.contentListNavVC.view setUserInteractionEnabled:NO];
            [_leftSideBarView setUserInteractionEnabled:YES];
        }
        else
        {
            [_contentView removeGestureRecognizer:_tapGer];
            _contentView.frame = _contentView.bounds ;
            [selfRef.contentListNavVC.view setUserInteractionEnabled:YES];
        }
        selfRef.leftSideBarShowing = istoshow ;
    };
    [UIView animateWithDuration:SH_SwitchDefaultAnimationDuration
                                   delay:0
                                 options:UIViewAnimationOptionCurveEaseInOut
                              animations:animations
                              completion:^(BOOL finished) {
    }];
}

-(void)toggle_right_side_bar:(BOOL)istoshow
{
    __weak SH_SwitchViewController *selfRef = self ;
    void(^animations)(void) = ^{
        if (istoshow) {
            _contentView.frame = CGRectOffset(_contentView.bounds, -SH_DefaultSidebarWidth, 0.0f) ;
            _leftSideBarView.frame = CGRectOffset(_leftSideBarView.bounds, -SH_DefaultSidebarWidth, 0.0f) ;
            [_contentView addGestureRecognizer:_tapGer];
            [selfRef.contentListNavVC.view setUserInteractionEnabled:NO];
            [_rightSideBarView setUserInteractionEnabled:YES];
        }
        else
        {
            [_contentView removeGestureRecognizer:_tapGer];
            _contentView.frame = _contentView.bounds ;
            _leftSideBarView.frame = _leftSideBarView.bounds ;
            [selfRef.contentListNavVC.view setUserInteractionEnabled:YES];
        }
        selfRef.rightSideBarShowing = istoshow ;
    };
    [UIView animateWithDuration:SH_SwitchDefaultAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:animations
                     completion:^(BOOL finished) {
                     }];
}
@end
