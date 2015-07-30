//
//  BaseUIViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/19.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"
#import <XRUIView/TipsView.h>
#import <XRUIView/WaitView.h>
#import "AppDelegate.h"
#import <XRUIView/MBProgressHUD.h>

@interface BaseUIViewController () <NetPromptDelegate>
{
    BOOL bNetMonitor;
}

@property(nonatomic, weak)UIView *blowView;

@end

@implementation BaseUIViewController

-(void)loadView{
    [super loadView];
    //设置默认网络出现连接情况的配置
    isShowNetPrompt = YES;
    isShowRequestPrompt = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.extendedLayoutIncludesOpaqueBars = YES;
    //设置状态条颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置背景颜色
    [self.view setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    //监测网络状态
    [self netStatusMonitor];
    //设置网络错误提示
    [self getNetPrompt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册系统通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationEnterBackGround) name:KNotifyEnterBackGround object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationBecomeActive) name:KNotifyBecomeActive object:nil];
    
    //注册网络请求通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpRequestFinished:) name:KNotification_RequestFinished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpRequestFailed:) name:KNotification_RequestFailed object:nil];
    
    //设置网络控制器请求标识
    [[NetInterfaceManager sharedInstance] setReqControllerId:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //更新网络状态
    [self updateInterfaceWithNetStatus];
}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    //通知取消注册
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DBG_MSG(@"enter");
    if (bNetMonitor) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate removeObserver:self forKeyPath:@"netStatus"];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ----

-(void)netStatusMonitor
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate addObserver:self forKeyPath:@"netStatus" options:NSKeyValueObservingOptionNew context:nil];
    bNetMonitor = YES;
}

-(void)setNavigationBar
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"loginbkBlue"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (NetPrompt *)getNetPrompt
{
    //即将显示的时候创建
    if (!netPrompt) {
        netPrompt = [[NetPrompt alloc] initWithView:self.view
                                      showTopUIView:NO
                                   showMiddleUIView:NO];
    }
    netPrompt.delegate = self;
    
    return netPrompt;
}

-(void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- system notification
-(void)onApplicationEnterBackGround
{
    DBG_MSG(@"Enter");
}

-(void)onApplicationBecomeActive
{
    DBG_MSG(@"Enter");
}

#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    //获取主线程清空视图加载符号
//    dispatch_async(dispatch_get_main_queue(), ^{
        DBG_MSG(@"enter");
        //当前的类名
        NSString *className= [NSString  stringWithUTF8String:object_getClassName(self)];
        //请求时候的类名
        NSString *reqClassName =  [[NetInterfaceManager sharedInstance] getReqControllerId];
        //再次请求成功清除无网络提示
        if ([reqClassName isEqualToString:className]) {
            [netPrompt setIsShowMiddleUIView:NO];
        };
        
        [self stopWait];
//    });
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    //获取主线程清空视图加载符号
    //如果是默认登录那边过来，需要在主线程中提示
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopWait];
        ResultDataModel *result = notification.object;
        if (!result) {
            DBG_MSG(@"httpRequestFailed: result is nil!");
            return;
        }
        DBG_MSG(@"httpRequestFailed: resultcode= %d", result.resultCode);
        
        //当前的类名
        NSString *className= [NSString  stringWithUTF8String:object_getClassName(self)];
        //请求时候的类名
        NSString *reqClassName =  [[NetInterfaceManager sharedInstance] getReqControllerId];
        //无网络状态
        if (isShowRequestPrompt && [reqClassName isEqualToString:className]) {
            //这里是本control 设置不显示中部的
            [netPrompt setIsShowMiddleUIView:isShowRequestPrompt];
            return;
        }
    
        [self showTipsView:result.desc];
//    });
}

#pragma mark - show alert view
-(void) showAlertWithTitle:(NSString*)title msg:(NSString*)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alert.delegate = self;
    [alert show];
}

- (void) showAlertWithTitle:(NSString*)title msg:(NSString*)msg showCancel:(BOOL)showCancel
{
    if (!showCancel) {
        [self showAlertWithTitle:title msg:msg];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
        alert.delegate = self;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)showTipsView:(NSString*)tips
{
    [[TipsView sharedInstance] showTips:tips];
}

- (void) startWait
{
//    [[WaitView sharedInstance] start];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

- (void) stopWait
{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

#pragma mark- networkStatusChanged
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self updateInterfaceWithNetStatus];
}

-(void) updateInterfaceWithNetStatus
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    switch (appDelegate.netStatus)
    {
        case NotNetwork: //无网络
        {
            //如果设置为不显示无网络提示
            if (!isShowNetPrompt) {
                return;
            }
            //显示顶部的显示
            [netPrompt setIsShowTopUIView:isShowNetPrompt];
            //整个视图向下移动40像素
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 40, self.view.frame.size.width, self.view.frame.size.height)];
            break;
        }
        default:
        {
            [netPrompt setIsShowTopUIView:NO];
            [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            break;
        }
    }
}

#pragma mark- http RequestPromptDelegate

- (void) requestNetReloadClick{
    [netPrompt setIsShowMiddleUIView:NO];
    [self startWait];
    [[NetInterfaceManager sharedInstance] reloadRecordData];
}

@end















