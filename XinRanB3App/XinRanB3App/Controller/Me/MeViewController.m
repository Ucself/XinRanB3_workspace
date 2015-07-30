//
//  MeViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/19.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "MeViewController.h"
#import <XRNetInterface/EnvPreferences.h>
#import "AddCommonView.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>{

    AddCommonView *addCommonView;

}

@end

@implementation MeViewController

- (void)viewDidLoad {
    //设置数据
    isShowRequestPrompt = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载界面相关信息
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
-(void) initInterface{
    
    //UITableViewDataSource 数据源协议
    self.mainTableView.dataSource = self;
    //UITableViewDelegate
    self.mainTableView.delegate = self;
    //添加小图标
    [self setupNavBar];
}

//退出登录按钮
-(void)loginOut{
    [[NetInterfaceManager sharedInstance] logout];
    [self startWait];
}

-(void)setupNavBar
{
    UIButton *btnR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnR setFrame:CGRectMake(0, 0, 50, 40)];
    [btnR setImage:[UIImage imageNamed:@"icon_itemBarAdd"] forState:UIControlStateNormal];
    [btnR addTarget:self action:@selector(btnRClick) forControlEvents:UIControlEventTouchUpInside];
    [btnR setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = barItem;
}

-(void)btnRClick {
    if (!addCommonView) {
        addCommonView = [[AddCommonView alloc] initWithPoint:CGPointMake(self.view.bounds.size.width - 124, 64) size:CGSizeMake(104, 100)];
        //添加弹出视图
        [self.view addSubview:addCommonView];
        //设置协议
        addCommonView.delegate = self;
    }
    addCommonView.isShow = !addCommonView.isShow;
}
#pragma mark --- AddCommonViewDelegate
//点击添加客户协议
-(void)addCustomerViewClick{
    //跳转到添加客户
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    UINavigationController *procurementController = [storyboard instantiateViewControllerWithIdentifier:@"AddCustomViewIdent"];
    [self.navigationController pushViewController:procurementController animated:YES];
    addCommonView.isShow = NO;
}
//点击添加商品协议
-(void)meBuyGoodsViewClick{
    //跳转控制器
    //采购管理
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Procurement" bundle:nil];
    UINavigationController *procurementController = [storyboard instantiateViewControllerWithIdentifier:@"procurementGoodsListId"];
    [self.navigationController pushViewController:procurementController animated:YES];
    addCommonView.isShow = NO;
}
#pragma mark --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId =@"MeCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 2) {
            //如果是第三行不需要右方向样式
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
    }
    //不需要点击选中样式
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //第一个cell添加两线条 后面的cell添加一根
    if (indexPath.row == 0) {
        //添加上布局线条
        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lineGray"]];
        [cell addSubview:lineImage];
        [lineImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.left);
            make.right.equalTo(cell.right);
            make.top.equalTo(cell.top);
            make.height.equalTo(1);
        }];
    }
    //第三列不需要加线条
    if (indexPath.row != 2) {
        //添加下部线条
        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lineGray"]];
        [cell addSubview:lineImage];
        [lineImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.left);
            make.right.equalTo(cell.right);
            make.bottom.equalTo(cell.bottom);
            make.height.equalTo(1);
        }];
    }
    //添加左边图标
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"修改密码";
            [cell.textLabel setTextColor:[UIColor darkGrayColor]];
            [cell.imageView setImage:[UIImage imageNamed:@"icon_mepassword"]];
        }
            
            break;
        case 1:
        {
            cell.textLabel.text = @"管理收货地址";
            [cell.textLabel setTextColor:[UIColor darkGrayColor]];
            [cell.imageView setImage:[UIImage imageNamed:@"icon_address"]];
        }
            
            break;
        case 2:
        {
            UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
            [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [exitButton setBackgroundImage:[UIImage imageNamed:@"btnbkRed"] forState:UIControlStateNormal];
            exitButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
            [cell addSubview:exitButton];
            [exitButton makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.left).offset(10);
                make.right.equalTo(cell.right).offset(-10);
                make.top.equalTo(cell.top).offset(12);
                make.height.equalTo(40.f);
            }];
            [exitButton addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        }
            
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark -- http request handler

-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_Logout:
            if (result.resultCode == 0) {
                //退出登录token消除
                [[EnvPreferences sharedInstance] setToken:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GotoLoginControl object:nil];
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

#pragma mark --- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"ToChangPassword" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"ToShipAddress" sender:self];
            break;
        default:
            break;
    }
    
    
}
//返回高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 60.f;
    }
    return 45.f;
}

@end





