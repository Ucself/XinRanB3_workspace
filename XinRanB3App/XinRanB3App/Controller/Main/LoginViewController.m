//
//  LoginViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/19.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "LoginViewController.h"
#import <XRNetInterface/EnvPreferences.h>

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    //不提示网络中断
    isShowNetPrompt = NO;
    isShowRequestPrompt = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //登录过存在Token与用户名，密码直接进入
    if ([[EnvPreferences sharedInstance] getUser] && [[EnvPreferences sharedInstance] getToken]) {
        //进入main
        UIViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"MainControllerIdent"];
        [self.navigationController pushViewController:next animated:NO];
    }
    
    //界面相关加载
    [self initInterface];
    
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

#pragma mark ---

//初始化界面
-(void) initInterface{
    [self.navigationController.navigationBar setHidden:YES];
    //设置委托
    self.userNameTextField.delegate = self;
    self.userPasswordTextField.delegate = self;
    //设置输入的UIView边框圆角
    [[self.nameView layer] setBorderWidth:0.4];//画线的宽度
    [[self.nameView layer] setBorderColor:[UIColor lightGrayColor].CGColor];//颜色
    [[self.nameView layer] setCornerRadius:3.0];//圆角
    [[self.passwordView layer] setBorderWidth:0.3];//画线的宽度
    [[self.passwordView layer] setBorderColor:[UIColor lightGrayColor].CGColor];//颜色
    [[self.passwordView layer] setCornerRadius:3.0];//圆角
    
    //布局高度
    [self.headView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(deviceHeight*(400.f/1330.f));
    }];
}


- (IBAction)loginClick:(id)sender {
    //隐藏键盘
    [self.userNameTextField resignFirstResponder];
    [self.userPasswordTextField resignFirstResponder];
    
    //无网络的时候进入主页
//    [self performSegueWithIdentifier:@"ToMain" sender:self];
//    return;
    
    if ([self.userNameTextField.text isEqualToString:@""] || [self.userPasswordTextField.text isEqualToString:@""]) {
        [self showTipsView:@"用户名或密码不能为空！"];
    }
    //登录
    [[NetInterfaceManager sharedInstance] login:self.userNameTextField.text pwd:self.userPasswordTextField.text ];
    //弹出加载框
    [self startWait];
}

#pragma mark- <UITextFieldDelegate>
//开始编辑的时候键盘遮住输入框
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //转换到当前坐标
    CGRect frame = textField.frame;
    frame = [self.view convertRect:frame fromView:textField.superview ];
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 280.0);//键盘高度250
    if (offset <= 0) {
        return;
    }
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    [UIView animateWithDuration:0.30f animations:^{
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
//动画视图还原
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //动画还原
    [UIView animateWithDuration:0.30f animations:^{
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

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
        [self.userNameTextField resignFirstResponder];
        [self.userPasswordTextField resignFirstResponder];
    }
}

#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    //父亲类请求
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_Login:
            //登录成功
            if (result.resultCode == 0) {
                //存入Token数据 凭据
//                [[EnvPreferences sharedInstance] setToken:(NSString *)result.data];
                //设置用户名，密码缓存
                NSMutableDictionary *dicUserInfor = [[NSMutableDictionary alloc] init];
                [dicUserInfor setObject:self.userNameTextField.text forKey:KJsonElement_UserName];
                [dicUserInfor setObject:self.userPasswordTextField.text forKey:KJsonElement_Password];
                [[EnvPreferences sharedInstance] setUser:dicUserInfor];
                //登录跳转
                [self performSegueWithIdentifier:@"ToMain" sender:self];
            }
            else if (result.resultCode == 1){
                [self showTipsView:@"账号或者密码错误!"];
            }
            else if (result.resultCode == 3){
                [self showTipsView:@"你的账号已被禁用!"];
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
    //父类请求
    [super httpRequestFailed:notification];
}
@end
