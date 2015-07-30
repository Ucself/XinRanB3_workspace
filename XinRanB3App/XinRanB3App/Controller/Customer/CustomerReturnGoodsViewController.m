//
//  CustomerReturnGoodsViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerReturnGoodsViewController.h"
#import "ReturnGoodsPickerView.h"

@interface CustomerReturnGoodsViewController ()<UITextFieldDelegate,UITextViewDelegate,ReturnGoodsPickerViewDelegate>{
    ReturnGoodsPickerView *pickerView;
}

@end

@implementation CustomerReturnGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置边框
    [self.returnRemark.layer setCornerRadius:5];
    self.returnRemark.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.returnRemark.layer.borderWidth= 0.5f;
    
    self.returnCount.delegate = self;
    self.returnReason.delegate = self;
    self.returnRemark.delegate = self;
    
    
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

- (IBAction)retunReasonClick:(id)sender {
    //键盘回收
    [self.returnCount resignFirstResponder];
    [self.returnReason resignFirstResponder];
    [self.returnRemark resignFirstResponder];
    
    if (!pickerView) {
        pickerView = [[ReturnGoodsPickerView alloc] initWithName:self.returnReason.text];
        pickerView.isShow = NO;
        pickerView.delegate = self;
    }
    //点击隐藏或者显示
    if (pickerView.isShow) {
        [pickerView cancelPicker:self.view];
    }
    else{
        [pickerView showInView:self.view];
    }
    
}



- (IBAction)backOrderClick:(id)sender {
    //键盘回收
    [self.returnCount resignFirstResponder];
    [self.returnReason resignFirstResponder];
    [self.returnRemark resignFirstResponder];
    [pickerView cancelPicker:self.view];
    
    //提交请求前判断
    if ([self.returnCount.text isEqualToString:@""]) {
        [self showTipsView:@"未填写退货数量！"];
        return;
    }
    if ([self.returnReason.text isEqualToString:@""]) {
        [self showTipsView:@"未选择退货原因！"];
        return;
    }
    //取消备注
//    if ([self.returnRemark.text isEqualToString:@""]) {
//        [self showTipsView:@"未填写退货备注！"];
//        return;
//    }
    
    [[NetInterfaceManager sharedInstance] customerBackorder:self.goodsId customerId:self.customerId saleorderId:self.saleorderId saleDetailId:self.saleDetailId reason:self.returnReason.text remark:self.returnRemark.text num:[self.returnCount.text integerValue]];
    [self startWait];
}
#pragma mark- 点击背景回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        [self.returnCount resignFirstResponder];
        [self.returnReason resignFirstResponder];
        [self.returnRemark resignFirstResponder];
        [pickerView cancelPicker:self.view];
    }
}
#pragma mark -- <ReturnGoodsPickerViewDelegate>
- (void)pickerViewCancel{
    
    [pickerView cancelPicker:self.view];
}
- (void)pickerViewOK:(NSString *)selectedName{
    
    self.returnReason.text = selectedName;
    
    [pickerView cancelPicker:self.view];
}

#pragma mark -- <UITextViewDelegate>
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [pickerView cancelPicker:self.view];
    self.lblTipRemark.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.returnRemark.text isEqualToString:@""]) {
        self.lblTipRemark.hidden = NO;
    }
    else{
        self.lblTipRemark.hidden = YES;
    }
}

#pragma mark- <UITextFieldDelegate>
//开始编辑的时候键盘遮住输入框
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [pickerView cancelPicker:self.view];
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

#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_CustomerBackorder:
        {
            if (result.resultCode == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [self showTipsView:result.desc];
            }
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
