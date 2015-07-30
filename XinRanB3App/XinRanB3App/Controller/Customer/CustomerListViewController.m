//
//  CustomerListViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/1.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerListViewController.h"
#import "CustomerListTableViewCell.h"
#import "AddCommonView.h"
#import <XRNetInterface/NetInterfaceManager.h>
#import "CustomerModel.h"
#import "CustomerPlaceOrderViewController.h"
#import "CustomerOrderListViewController.h"
#import <XRNetInterface/HomeInfoCache.h>

@interface CustomerListViewController ()<UITableViewDelegate,UITableViewDataSource,CustomerListTableViewCellDelegate,RefreshTableViewDelegate>
{
    AddCommonView *addCommonView;
    NSMutableArray *dataSource;

}

@end

@implementation CustomerListViewController

- (void)viewDidLoad {
    //网络请求提示
    isShowRequestPrompt = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //数据请求客户列表
    [[NetInterfaceManager sharedInstance] getCustomerlist];
    [self startWait];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        if (addCommonView) {
            addCommonView.isShow = NO;
        }
    }
}
#pragma mark ---

-(void) initInterface{
    self.mainTableView.refreshDelegate = self;
    [self.mainTableView addHeaderView];
    
    //设置协议
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    //设置缓存数据源
    dataSource = (NSMutableArray *)[[HomeInfoCache sharedInstance] getCustomerInfor];
    //添加小图标
    [self setupNavBar];
}
-(void)setupNavBar
{
    //右边的btn
    UIButton *btnR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnR setFrame:CGRectMake(0, 0, 40, 40)];
    [btnR setImage:[UIImage imageNamed:@"icon_itemBarAdd"] forState:UIControlStateNormal];
    [btnR addTarget:self action:@selector(btnRClick) forControlEvents:UIControlEventTouchUpInside];
    [btnR setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barRItem = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = barRItem;
    //左边的btn
    UIButton *btnL = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnL setFrame:CGRectMake(0, 0, 40, 40)];
    [btnL setImage:[UIImage imageNamed:@"icon_itemBarSeach"] forState:UIControlStateNormal];
    [btnL addTarget:self action:@selector(btnLClick) forControlEvents:UIControlEventTouchUpInside];
    [btnL setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barLItem = [[UIBarButtonItem alloc]initWithCustomView:btnL];
    self.navigationItem.leftBarButtonItem = barLItem;
}
-(void)btnRClick {
    if (!addCommonView) {
        addCommonView = [[AddCommonView alloc] initWithPoint:CGPointMake(self.view.bounds.size.width - 120, 64) size:CGSizeMake(104, 100)];
        //添加弹出视图
        [self.view addSubview:addCommonView];
        //设置协议
        addCommonView.delegate = self;
    }
    addCommonView.isShow = !addCommonView.isShow;
}
//设置无客户提示
-(void)showPromptCustomer:(BOOL)isShow
{
    UIView *tipUIView = [self.view viewWithTag:522];
    //消除无客户提示
    if (!isShow) {
        if (tipUIView) {
            [tipUIView removeFromSuperview];
        }
        return;
    }
    //显示无客户提示
    if (tipUIView) {
        //如果存在就不再次显示了
        return;
    }
    //设置提示显示视图
    tipUIView = [[UIView alloc] init];
    tipUIView.tag = 522;
    [tipUIView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tipUIView];
    [tipUIView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    //设置图标
    UIImageView *tipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iocn_noCustomer"]];
    [tipUIView addSubview:tipIcon];
    [tipIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipUIView.centerX);
        make.width.equalTo(76);
        make.height.equalTo(70);
        make.centerY.equalTo(tipUIView.centerY).offset(-70);
    }];
    //中间字设置
    UILabel *tipLbl = [[UILabel alloc] init];
    tipLbl.text = @"你还没有客户，赶快去添加吧！";
    [tipLbl setFont:[UIFont systemFontOfSize:15.f]];
    [tipLbl setTextAlignment:NSTextAlignmentCenter];
    [tipLbl setTextColor:[UIColor darkGrayColor]];
    [tipUIView addSubview:tipLbl];
    [tipLbl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipUIView.centerX);
        make.width.equalTo(tipUIView.width);
        make.height.equalTo(21);
        make.centerY.equalTo(tipUIView.centerY);
    }];
    //按钮
    UIButton *tipBtn = [[UIButton alloc] init];
    [tipBtn setTitle:@"添加客户" forState:UIControlStateNormal];
    [tipBtn setBackgroundImage:[UIImage imageNamed:@"btnbkRed"] forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(addCustomerViewClick) forControlEvents:UIControlEventTouchUpInside];
    [tipUIView addSubview:tipBtn];
    [tipBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipUIView.centerX);
        make.width.equalTo(140);
        make.height.equalTo(40);
        make.centerY.equalTo(tipUIView.centerY).offset(55);
    }];
    
}
//搜索点击
-(void)btnLClick{
    [self performSegueWithIdentifier:@"toSeachCustomer" sender:self];
}


#pragma mark ---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    CustomerOrderListViewController *customerOrderListViewController = [storyboard instantiateViewControllerWithIdentifier:@"customerOrderListIdent"];
    CustomerModel *tempCustomerModel = (CustomerModel *)dataSource[indexPath.row];
    customerOrderListViewController.customerId = tempCustomerModel.cId;
    customerOrderListViewController.customername = tempCustomerModel.name;
    [self.navigationController pushViewController:customerOrderListViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62.f;
}

#pragma mark ---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId=@"cellId";
    CustomerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerListTableViewCell" owner:self options:0] firstObject];
    }
    CustomerModel *tempCustomerModel = (CustomerModel *)dataSource[indexPath.row];
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
    CustomerModel *tempCustomerModel = (CustomerModel *)dataSource[index];
    customerPlaceOrderController.customerId = tempCustomerModel.cId;
    
    [self.navigationController pushViewController:customerPlaceOrderController animated:YES];
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
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.mainTableView scrollViewWillBeginDecelerating:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.mainTableView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.mainTableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.mainTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
}
#pragma mark - RefreshTableViewDelegate
-(void) refreshData
{
    //刷新完成隐藏
    [[NetInterfaceManager sharedInstance] getCustomerlist];
}

-(void) loadMoreData
{
    //加载更多
}
#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_GetCustomerlist:
        {
            if (result.resultCode == 0) {
                //先释放内存
                dataSource = nil;
                //刷新的时候清空数据
                dataSource = [[NSMutableArray alloc] init];
                for (NSDictionary *dicTemp in result.data) {
                    CustomerModel *tempCustomer = [[CustomerModel alloc] initWithDictionary:dicTemp];
                    [dataSource addObject:tempCustomer];
                }
                //缓存数据
                [[HomeInfoCache sharedInstance] setCustomerInfor:dataSource];
                //从新加载数据
                [self.mainTableView reloadData];
                //无客户提示
                if (dataSource.count  == 0) {
                    [self showPromptCustomer:YES];
                }
                else{
                    [self showPromptCustomer:NO];
                }
            }
            else{
                //返回错误的时候，根据数据源展示是否提示用户添加客户
                if (dataSource == nil || dataSource.count == 0) {
                    [self showPromptCustomer:YES];
                }
                else{
                    [self showPromptCustomer:NO];
                }
            }
            //刷新完成隐藏刷新头部
            [self.mainTableView doneLoadingRefreshData];
        }
            break;
        default:
            break;
    }
}
-(void)httpRequestFailed:(NSNotification *)notification{
    [super httpRequestFailed:notification];
    //返回错误的时候，根据数据源展示是否提示用户添加客户
    if (dataSource == nil || dataSource.count == 0) {
        [self showPromptCustomer:YES];
    }
    else{
        [self showPromptCustomer:NO];
    }
    //刷新完成隐藏刷新头部
    [self.mainTableView doneLoadingRefreshData];
}
@end








