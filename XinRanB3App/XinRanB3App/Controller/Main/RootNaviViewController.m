//
//  NaviViewController.m
//  XinRanApp
//
//  Created by tianbo on 15-1-13.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "RootNaviViewController.h"
#import "UserModel.h"
#import <XRCommon/XRCommon.h>
#import <XRNetInterface/ResultDataModel.h>
#import <XRNetInterface/NetInterfaceManager.h>
#import <XRNetInterface/EnvPreferences.h>
#import "LoginViewController.h"
#import "MainViewController.h"
#import <XRUIView/TipsView.h>
#import <XRUIView/MBProgressHUD.h>

@interface RootNaviViewController ()

@end

@implementation RootNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态条为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

//  根据版本号区分是否显示引导页
    NSString *locVer = [[EnvPreferences sharedInstance] getAppVersion];
    NSString *curVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (locVer && [curVer isEqualToString:locVer]) {
        //进入登录
        UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"LoginController"];
        [self pushViewController:next animated:NO];
        
    }
    else {
        UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"GuideController"];
        [self pushViewController:next animated:NO];
        [[EnvPreferences sharedInstance] setAppVersion:curVer];
    }
    //注册通知弹回登录控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLoginControler) name:KNotification_GotoLoginControl object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpRequestFinished:) name:KNotification_RequestFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpRequestFailed:) name:KNotification_RequestFailed object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //注销通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---
//跳转到登录控制器
-(void)gotoLoginControler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [[TipsView sharedInstance] showTips:@"请重新登录！"];
        //判断是否是登陆control
        for (UIViewController *tempController in self.viewControllers) {
            if ([tempController isKindOfClass:[LoginViewController class]]) {
                [self popToViewController:tempController animated:YES];
            }
        }
    });
}


#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
    ResultDataModel *result = notification.object;
    if (!result) {
        DBG_MSG(@"http result is nil!");
        return;
    }
    
    switch (result.requestType) {
        default:
            break;
    }
    
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    
}

@end
