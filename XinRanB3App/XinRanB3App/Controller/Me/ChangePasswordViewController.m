//
//  ChangePasswordViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/20.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <XRNetInterface/EnvPreferences.h>

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    isShowRequestPrompt = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置委托
    self.txtOldPassword.delegate = self;
    self.txtNewPassword.delegate = self;
    self.txtConfirmPassword.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeClick:(id)sender {
    //收回键盘
    [self.txtOldPassword resignFirstResponder];
    [self.txtNewPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    
    if ([self.txtOldPassword.text isEqualToString:@""]) {
        [self showTipsView:@"原始密码不能为空!"];
        return;
    }
    if ([self.txtNewPassword.text isEqualToString:@""]) {
        [self showTipsView:@"新密码密码不能为空!"];
        return;
    }
    if ([self.txtConfirmPassword.text isEqualToString:@""]) {
        [self showTipsView:@"确认密码不能为空!"];
        return;
    }
    
    if (![self.txtConfirmPassword.text isEqualToString:self.txtNewPassword.text]) {
        [self showTipsView:@"确认密码与新密码不一致!"];
        return;
    }
    
    [self startWait];
    [[NetInterfaceManager sharedInstance] changPassword:self.txtOldPassword.text newpwd:self.txtNewPassword.text];
}

#pragma mark- <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //回收键盘
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- 点击背景回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        [self.txtOldPassword resignFirstResponder];
        [self.txtNewPassword resignFirstResponder];
        [self.txtConfirmPassword resignFirstResponder];
    }
}

#pragma mark -- http request handler

-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_ChangPassword:
            if (result.resultCode == 0) {
                //退出登录token消除
                [[EnvPreferences sharedInstance] setToken:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GotoLoginControl object:nil];
            }
            else if (result.resultCode == 1){
                //返回的其他状态
                [self showTipsView:@"原始密码错误"];
            }
            else {
                //返回的其他状态
                [self showTipsView:result.desc];
            }
            break;
        default:
            break;
    }
}
-(void)httpRequestFailed:(NSNotification *)notification{
    [super httpRequestFailed:notification];
}

@end
