//
//  AddCustomViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "AddCustomViewController.h"
#import <XRShareSDK/XDShareManager.h>

@interface AddCustomViewController ()<UITextFieldDelegate>{
    int gender;
}

@end

@implementation AddCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
#pragma mark ----
- (IBAction)addCustomer:(id)sender {
    //隐藏键盘
    [self.userName resignFirstResponder];
    [self.userPhone resignFirstResponder];
    //收货人验证
    if ([self.userName.text isEqualToString:@""]) {
        [self showTipsView:@"请先填写客户的姓名!"];
        return;
    }
    if (self.userName.text.length < 2 || self.userName.text.length > 24 || ![BCBaseObject isChineseStr:self.userName.text]) {
        [self showTipsView:@"客户姓名是2-24个中文字符!"];
        return;
    }
    //手机号码验证
    if (![BCBaseObject isAllMobileNumber:self.userPhone.text]) {
        [self showTipsView:@"电话号码是座机号，手机号，小灵通!"];
        return;
    }
    //发送数据请求
    [[NetInterfaceManager sharedInstance] addCustomer:self.userName.text gender:gender telephone:self.userPhone.text];
    [self startWait];
}

//加载界面
-(void) initInterface{
    //默认设置为
    gender = 19001;
    [self.maleImageView setImage:[UIImage imageNamed:@"icon_selected"]];
    [self.femaleImageView setImage:[UIImage imageNamed:@"icon_not_selected"]];
    //添加手势
    UITapGestureRecognizer *maleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maleViewClick)];
    [self.maleView addGestureRecognizer:maleTap];
    UITapGestureRecognizer *femaleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(femaleViewClick)];
    [self.femaleView addGestureRecognizer:femaleTap];
    
    //设置协议
    self.userName.delegate = self;
    self.userPhone.delegate = self;
}

//点击男的视图
-(void) maleViewClick{
    [self.maleImageView setImage:[UIImage imageNamed:@"icon_selected"]];
    [self.femaleImageView setImage:[UIImage imageNamed:@"icon_not_selected"]];
    gender = 19001;
}
//点击女的视图
-(void) femaleViewClick{
    [self.maleImageView setImage:[UIImage imageNamed:@"icon_not_selected"]];
    [self.femaleImageView setImage:[UIImage imageNamed:@"icon_selected"]];
    gender = 19002;
}

#pragma mark- <UITextFieldDelegate>
//开始编辑的时候键盘遮住输入框
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //转换到当前坐标
    CGRect frame = textField.frame;
    frame = [self.view convertRect:frame fromView:textField.superview ];
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 255.0);//键盘高度250
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
        [self.userName resignFirstResponder];
        [self.userPhone resignFirstResponder];
    }
}
#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_AddCustomer:
            if (result.resultCode == 0) {
                //返回客户列表
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GotoCustomerListControl object:nil];
            }
            else if (result.resultCode == 1){
                [self showTipsView:result.desc];
            }
            else{
                [self showTipsView:@"客户添加失败！请重试"];
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















