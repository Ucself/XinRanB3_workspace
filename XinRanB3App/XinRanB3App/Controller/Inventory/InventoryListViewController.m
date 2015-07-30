//
//  InventoryListViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/2.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "InventoryListViewController.h"
#import "AddCommonView.h"
#import <XRNetInterface/NetInterfaceManager.h>
#import <XRNetInterface/UIImageView+AFNetworking.h>

@interface InventoryListViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshTableViewDelegate>{
    
    NSMutableArray *dataSource;
    AddCommonView *addCommonView;
    //请求的页数
    int requestPage;
    //刷新方式
    int refreshOrMore;
}
@end

@implementation InventoryListViewController

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
    [[NetInterfaceManager sharedInstance] getProductStorage:15 page:requestPage];
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
#pragma mark --
-(void) initInterface{
    //设置下拉刷新头部
    self.mainTableView.refreshDelegate = self;
    [self.mainTableView addHeaderView];
    [self.mainTableView addFootView];
    
    //默认为第一页
    requestPage = 1;
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    
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
-(void)showPromptInventory:(BOOL)isShow
{
    UIView *tipUIView = [self.view viewWithTag:520];
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
    tipUIView.tag = 520;
    [tipUIView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tipUIView];
    [tipUIView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    //设置图标
    UIImageView *tipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iocn_noInventory"]];
    [tipUIView addSubview:tipIcon];
    [tipIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipUIView.centerX);
        make.width.equalTo(76);
        make.height.equalTo(70);
        make.centerY.equalTo(tipUIView.centerY).offset(-70);
    }];
    //中间字设置
    UILabel *tipLbl = [[UILabel alloc] init];
    tipLbl.text = @"你还没有库存，赶快去采购吧！";
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
    [tipBtn setTitle:@"我要买货" forState:UIControlStateNormal];
    [tipBtn setBackgroundImage:[UIImage imageNamed:@"btnbkRed"] forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(meBuyGoodsViewClick) forControlEvents:UIControlEventTouchUpInside];
    [tipUIView addSubview:tipBtn];
    [tipBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipUIView.centerX);
        make.width.equalTo(140);
        make.height.equalTo(40);
        make.centerY.equalTo(tipUIView.centerY).offset(55);
    }];
    
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
#pragma mark --UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}


#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"InventoryListCellIdent"];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    UIImageView *imageHeard = (UIImageView *)[cell viewWithTag:101];
    UITextView *txtName = (UITextView*)[cell viewWithTag:102];
    UILabel *lblCount = (UILabel*)[cell viewWithTag:103];
    UILabel *lblPrice = (UILabel*)[cell viewWithTag:104];
    
    //uiImage添加边框
    imageHeard.layer.borderWidth = 1.f;
    imageHeard.layer.borderColor = [UIColorFromRGB(0XEAEBEC) CGColor];
    
    NSDictionary *tempDic = (NSDictionary *)dataSource[indexPath.row];
    if (tempDic) {
        
        NSLog(@"tempDicimageHeard==%@",[[NSString alloc] initWithFormat:@"%@%@",KImageDonwloadAddr,[tempDic objectForKey:@"images"]]);
        //图片
        if ([tempDic objectForKey:@"images"] && ![[tempDic objectForKey:@"images"] isKindOfClass:[NSNull class]]) {
            [imageHeard setImageWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",KImageDonwloadAddr,[tempDic objectForKey:@"images"]]]];
        }
        //产品名称
        if ([tempDic objectForKey:@"product_name"] && ![[tempDic objectForKey:@"product_name"] isKindOfClass:[NSNull class]]) {
            txtName.text = [tempDic objectForKey:@"product_name"];
        }
        else{
            txtName.text = @"";
        }
        //产品数量
        if ([tempDic objectForKey:@"storage_num"] && ![[tempDic objectForKey:@"storage_num"] isKindOfClass:[NSNull class]]) {
            lblCount.text = [[NSString alloc] initWithFormat:@"%@件",[tempDic objectForKey:@"storage_num"]];
        }
        else{
            lblCount.text = @"";
        }
        //产品价格
        if ([tempDic objectForKey:@"price"] && ![[tempDic objectForKey:@"price"] isKindOfClass:[NSNull class]]) {
            lblPrice.text = [[NSString alloc] initWithFormat:@"￥%@",[tempDic objectForKey:@"price"]];
        }
        else{
            lblPrice.text = @"";
        }
    }
    else{
        txtName.text = @"";
        lblCount.text = @"";
        lblPrice.text = @"";
    }
    
    
    return cell;
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    [self.mainTableView tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
#pragma mark - RefreshTableViewDelegate
-(void) refreshData
{
    //刷新操作
    refreshOrMore = 0;
    //页数
    requestPage = 1;
    //获取数据
    [[NetInterfaceManager sharedInstance] getProductStorage:15 page:requestPage];
    [self startWait];
}

-(void) loadMoreData
{
    //加载更多操作
    refreshOrMore = 1;
    //加载更多
    requestPage ++;
    //获取数据
    [[NetInterfaceManager sharedInstance] getProductStorage:15 page:requestPage];
    [self startWait];
}
#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_ProductStorage:
            if (result.resultCode == 0) {
                if (requestPage == 1) {
                    dataSource = nil;
                    dataSource = [[NSMutableArray alloc] init];
                }
                //添加刷新的数据
                [dataSource addObjectsFromArray:(NSMutableArray*)result.data];
                //从新加载数据
                [self.mainTableView reloadData];
                //提示没货物的情况
                if (dataSource.count == 0) {
                    [self showPromptInventory:YES];
                }
                else{
                    [self showPromptInventory:NO];
                }
            }
            //隐藏刷新或者加载更多标识符
            if (refreshOrMore == 0) {
                //刷新完成隐藏刷新头部
                [self.mainTableView doneLoadingRefreshData];
            }
            else if (refreshOrMore == 1){
                //加载更多
                [self.mainTableView doneLoadingMoreData];
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







