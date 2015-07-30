//
//  SeachCustomerListViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/3.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "SeachCustomerListViewController.h"
#import "CustomerListTableViewCell.h"
#import "CustomerModel.h"
#import <XRNetInterface/NetInterfaceManager.h>
#import "CustomerSeachTextField.h"
#import "CustomerOrderListViewController.h"
#import "CustomerPlaceOrderViewController.h"
#import "CustomerModel.h"

//CustomerListTableViewCellDelegate
@interface SeachCustomerListViewController ()<UITableViewDelegate,UITableViewDataSource,CustomerListTableViewCellDelegate,UITextFieldDelegate>{

//    NSMutableArray *dataSource;
    //搜索框
    UITextField *seachField;
}

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation SeachCustomerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(!seachField){
        CGRect tempCGRect = self.navigationController.navigationBar.bounds;
        seachField = [[CustomerSeachTextField alloc] initWithFrame:CGRectMake(40, 7, tempCGRect.size.width - 80, tempCGRect.size.height - 15)];
        [self.navigationController.navigationBar addSubview:seachField];
        [self.navigationController.navigationBar bringSubviewToFront:seachField];
        [seachField setBackgroundColor:[UIColor whiteColor]];
        [seachField setBorderStyle:UITextBorderStyleRoundedRect];
        [seachField setTintColor:[UIColor blueColor]];
        [seachField setTextColor:[UIColor darkGrayColor]];
        [seachField setFont:[UIFont fontWithName:nil size:15.f]];
        seachField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //左边加搜索标签
        UIImageView *seachImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_seach"]];
        [seachImage setFrame:CGRectMake(0, 0, 17, 17)];
        seachField.leftView = seachImage;

        seachField.leftViewMode = UITextFieldViewModeAlways;
        seachField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        seachField.placeholder = @"搜索";
        seachField.delegate = self;
        seachField.returnKeyType = UIReturnKeySearch;

    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //清楚输入框
    if (seachField) {
        [seachField removeFromSuperview];
        seachField = nil;
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
#pragma mark ---

-(void) initInterface{
    
    //设置协议
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    
    //数据请求客户列表 不需要第一次加载
//    [[NetInterfaceManager sharedInstance] getCustomerlist];
//    [self startWait];
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
    
    if (seachField) {
        [[NetInterfaceManager sharedInstance] customerSearch:seachField.text];
        [self startWait];
    }
    
    return YES;
}
#pragma mark- 点击背景回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1 && seachField) {
        [seachField resignFirstResponder];
    }
}

#pragma mark ---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId=@"cellId";
    CustomerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerListTableViewCell" owner:self options:0] firstObject];
    }
    CustomerModel *tempCustomerModel = (CustomerModel *)self.dataSource[indexPath.row];
    cell.delegate = self;
    cell.lblName.text = tempCustomerModel.name;
    cell.lblTelephone.text= tempCustomerModel.telephone;
    cell.lblGender.text = tempCustomerModel.gender == 19001 ? @"男" : @"女";
    
    return cell;
}
#pragma mark --CustomerListTableViewCellDelegate
//下单协议
-(void) placeOrderClick:(CustomerListTableViewCell*)cell index:(int)index{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CustomerPlaceOrderViewController *customerPlaceOrderController = [storyboard instantiateViewControllerWithIdentifier:@"CustomerPlaceOrderIdent"];
    CustomerModel *tempCustomerModel = (CustomerModel *)self.dataSource[index];
    customerPlaceOrderController.customerId = tempCustomerModel.cId;
    
    [self.navigationController pushViewController:customerPlaceOrderController animated:YES];
}

#pragma mark ---UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}
#pragma mark ---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CustomerOrderListViewController *customerOrderListViewController = [storyboard instantiateViewControllerWithIdentifier:@"customerOrderListIdent"];
    CustomerModel *tempCustomerModel = (CustomerModel *)self.dataSource[indexPath.row];
    customerOrderListViewController.customerId = tempCustomerModel.cId;
    customerOrderListViewController.customername = tempCustomerModel.name;
    [self.navigationController pushViewController:customerOrderListViewController animated:YES];
}

#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_GetCustomerlist:
            if (result.resultCode == 0) {
                //刷新的时候清空数据
                self.dataSource = [[NSMutableArray alloc] init];
                for (NSDictionary *dicTemp in result.data) {
                    CustomerModel *tempCustomer = [[CustomerModel alloc] initWithDictionary:dicTemp];
                    [self.dataSource addObject:tempCustomer];
                }
                //从新加载数据
                [self.mainTableView reloadData];
            }
            break;
        case KReqestType_CustomerSearch:
            if (result.resultCode == 0) {
                //刷新的时候清空数据
                self.dataSource = [[NSMutableArray alloc] init];
                for (NSDictionary *dicTemp in result.data) {
                    CustomerModel *tempCustomer = [[CustomerModel alloc] initWithDictionary:dicTemp];
                    [self.dataSource addObject:tempCustomer];
                }
                //从新加载数据
                [self.mainTableView reloadData];
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
