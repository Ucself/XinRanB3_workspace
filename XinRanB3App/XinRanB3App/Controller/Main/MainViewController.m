//
//  MainViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-4.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "MainViewController.h"
#import <XRCommon/ProtocolDefine.h>
#import <XRCommon/PhoneQuery.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabController];
    //注册通知弹回客户列表控制器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCustomerListControl:) name:KNotification_GotoCustomerListControl object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoProcurementListControl:) name:KNotification_GotoProcurementListControl object:nil];
}

//初始化主页面
-(void)initTabController
{
    //设置字体
    [[UITabBarItem appearance] setTitleTextAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                             forState: UIControlStateNormal];
    //客户管理
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    UINavigationController *customerController = [storyboard instantiateInitialViewController];
    
    //采购管理
    storyboard = [UIStoryboard storyboardWithName:@"Procurement" bundle:nil];
    UINavigationController *procurementController = [storyboard instantiateInitialViewController];
    
    //库存管理
    storyboard = [UIStoryboard storyboardWithName:@"Inventory" bundle:nil];
    UINavigationController *inventoryController = [storyboard instantiateInitialViewController];
    
    //我的管理
    storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    UINavigationController *meController = [storyboard instantiateInitialViewController];
    
    NSArray *controllers = [NSArray arrayWithObjects:customerController,procurementController, inventoryController,meController, nil];
    
    [self setViewControllers:controllers];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark --
//跳转到客户列表控制器
-(void)gotoCustomerListControl:(NSNotification*)notification
{
    //延迟处理解决tableBar隐藏问题
    [self performSelector:@selector(setMainSelectedIndex:) withObject:0 afterDelay:0.1f];
}
//跳转到采购单列表
-(void)gotoProcurementListControl:(NSNotification*)notification
{
    //延迟处理解决tableBar隐藏问题
    [self performSelector:@selector(setMainSelectedIndex:) withObject:[NSNumber numberWithInt:1] afterDelay:0.1f];
}
//延迟跳转
-(void) setMainSelectedIndex:(id)index {
    int barIndex = [index integerValue];
    //设置返回顶部
    UINavigationController *tempNavigationController = self.viewControllers[barIndex];
    [tempNavigationController popToRootViewControllerAnimated:YES];
    //设置tab选项
    [self setSelectedIndex:barIndex];
}

//跳转到我的订单
//-(void)gotoMyCouponsControler
//{
//    self.selectedIndex = 1;
//    
//    UINavigationController *naviController = [self.viewControllers objectAtIndex:1];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//    MyOrderViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"MyOrderViewController"];
//    [naviController popToRootViewControllerAnimated:NO];
//    [naviController.topViewController.navigationController pushViewController:c animated:YES];
//}

//跳转到选择常用地址
//-(void)gotoSelectStoreController:(NSNotification*)notification
//{
//    DBG_MSG(@"enter");
//    
//    NSString *phoneNumber = notification.object;
//    
//    [PhoneQuery query:phoneNumber finished:^(NSString *addr) {
//        UINavigationController *naviController = [self.viewControllers objectAtIndex:2];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//        OftenStoreViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"OftenStoreViewController"];
//        c.goSelStore = YES;
//        c.arearName = addr;
//        [naviController.topViewController.navigationController pushViewController:c animated:NO];
//        
//    }];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
