//
//  MyProcurementListViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "MyProcurementListViewController.h"
#import "AddCommonView.h"
#import "SegmentedUIView.h"
#import "MyProcurementBottomTableViewCell.h"
#import "HaveBuyGoodsTableViewCell.h"
#import "ProcurementOrderModel.h"
#import "GoodsModel.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>
#import "MyProcurementDetailViewController.h"
#import <XRShareSDK/XDShareManager.h>


@interface MyProcurementListViewController ()<AddCommonViewDelegate,SegmentedUIViewDelegate,UITableViewDelegate,UITableViewDataSource,MyProcurementBottomTableViewCellDelegate,UIAlertViewDelegate,RefreshTableViewDelegate>
{
    AddCommonView *addCommonView;
    SegmentedUIView *segmentedUIView;
    //数据源
    NSMutableArray *dataSource;
    //请求的数据类型
    int requestType;
    //请求的页数
    int requestPage;
    //点击的每一项index
    int clickCellIndex;
    //支付方式
    int payType;
    //刷新方式
    int refreshOrMore;
}

@end

@implementation MyProcurementListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BaseUIViewController* controller = segue.destinationViewController;
    if ([controller isKindOfClass:[MyProcurementDetailViewController class]]) {
        MyProcurementDetailViewController *c = (MyProcurementDetailViewController*)controller;
        c.orderId = (NSString*)sender;
    }
}
//页面将要显示
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //tableview数据展示设置
    [self setupMainTableView];
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
-(void)initInterface{
    //设置下拉刷新头部
    self.mainTableView.refreshDelegate = self;
    [self.mainTableView addHeaderView];
    [self.mainTableView addFootView];
    
    //初始的适合请求全部
    requestType = 0;
    requestPage = 1;
    //添加小图标
    [self setupNavBar];
    //设置分类导航栏目
    [self setupSegmented];
}
//数据展示设置
-(void)setupMainTableView {
    
    //获取数据
    [[NetInterfaceManager sharedInstance] getGoodsOrderList:requestType page:requestPage];
    [self startWait];
    //设置背景颜色
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    if (!dataSource) {
        dataSource = [[NSMutableArray alloc] init];
    }
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
}
-(void)setupSegmented {
    
    if (!segmentedUIView) {
        segmentedUIView = [[SegmentedUIView alloc] init];
    }
    segmentedUIView.delegate = self;
    [self.headerView addSubview:segmentedUIView];
    
    // tell constraints they need updating
    [self.headerView setNeedsUpdateConstraints];
    // update constraints now so we can animate the change
    [self.headerView updateConstraintsIfNeeded];
    [self.headerView layoutIfNeeded];
    //    [self.segmentedUIView  setFrame:self.headView.bounds];
    
    [segmentedUIView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerView);
    }];
    //添加约束
    [segmentedUIView initInterface];
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
//设置无客户提示
-(void)showPromptProcurement:(BOOL)isShow
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
    [tipUIView setUserInteractionEnabled:YES];
    //分类放在顶部
    [self.view bringSubviewToFront:self.headerView];
    
    [tipUIView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    //设置图标
    UIImageView *tipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ocn_noProcurement"]];
    [tipUIView addSubview:tipIcon];
    [tipIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipUIView.centerX);
        make.width.equalTo(76);
        make.height.equalTo(70);
        make.centerY.equalTo(tipUIView.centerY).offset(-70);
    }];
    //中间字设置
    UILabel *tipLbl = [[UILabel alloc] init];
    tipLbl.text = @"你暂时没有订单，赶快去采购吧！";
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
#pragma mark ---SegmentedUIViewDelegate

//展示个数
- (NSInteger) numberOfData{
    return 4;
}
//每个单元的字符串名称
- (NSString *) stringForIndex:(NSInteger) index{
    switch (index) {
        case 0:
            return @"全部";
        case 1:
            return @"待付款";
        case 2:
            return @"待发货";
        case 3:
            return @"待收货";
        default:
            return @"";
    }

}
//是否有排序图标,默认不显示
- (UIImage*)segmentedUIView:(NSInteger) indexPath{
    return [UIImage new];
}
//点击分栏目
- (void)segmentedUIView:(SegmentedUIView *)segmentedUIView didSelectRowAtIndexPath:(NSInteger) indexPath sortType:(SegmentedSortType)sortType{
    //请求信息
    requestType = (int)indexPath;
    requestPage = 1;
    
    [[NetInterfaceManager sharedInstance] getGoodsOrderList:requestType page:requestPage];
    [self startWait];
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

#pragma mark ---MyProcurementBottomTableViewCellDelegate
//右边的按钮点击
- (void) rightButtonClick:(NSInteger)cellIndex myProcurementBottomTableViewCell:(MyProcurementBottomTableViewCell*)cell{
    
    //待付款状态按钮为【付款】
    ProcurementOrderModel *tempModel = dataSource[cellIndex];
    switch (tempModel.orderState) {
        case 10: //未付款
        {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"付款跳转中..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//            clickCellIndex = (int)cellIndex;
//            [alertView setTag:1013];
//            [alertView show];
            
            //计算总价格
            float totalPrice = 0.0f;
            NSMutableArray *tempGoodsInfor = tempModel.ordergoodsModels;
            for (GoodsModel *tempGoodsModel in tempGoodsInfor) {
                totalPrice = totalPrice + [tempGoodsModel.goodsPrice floatValue];
            }
            //计算支付方式
            if ([tempModel.orderPaymentId isEqualToString:@"1"]) {
                payType = PayType_Ali;
            }
            else if([tempModel.orderPaymentId isEqualToString:@"2"]){
                payType = PayType_WeChat;
            }
            //支付接口调用
            if (payType == PayType_Ali) {
                [[NetInterfaceManager sharedInstance] aliPay:@"" price:[[NSString alloc] initWithFormat:@"%.2f",totalPrice] orderId:tempModel.orderId];
                [self startWait];
            }
            else if (payType == PayType_WeChat){
                //支付数据请求
                [[NetInterfaceManager sharedInstance] weixinPay:@"" price:[[NSString alloc] initWithFormat:@"%.2f",totalPrice] orderId:tempModel.orderId];
                [self startWait];
            }
            
            
        }
            break;
        case 20: //已付款未发货
            
            break;
        case 30: //已发货待收货
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确认已收货了？确认后将完成交易" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            clickCellIndex = (int)cellIndex;
            [alertView setTag:1012];
            [alertView show];
        }
            break;
        case 40: //已收货
            
            break;
        case 50: //已提交
            
            break;
        case 60: //已确认
            
            break;
        case 70: //已取消
            
            break;
        case 80: //已过期
            
            break;
        default:
            break;
    }
}
//左边的点击按钮
- (void) leftButtonClick:(NSInteger)cellIndex myProcurementBottomTableViewCell:(MyProcurementBottomTableViewCell*)cell{
    
    ProcurementOrderModel *tempModel = dataSource[cellIndex];
    switch (tempModel.orderState) {
        case 10: //未付款
        {
            //待付款状态按钮为【取消订单】
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确认取消此订单？确认后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            clickCellIndex = (int)cellIndex;
            [alertView setTag:1011];
            [alertView show];
        }
            break;
        case 20: //已付款未发货
            
            break;
        case 30: //已发货待收货
            
            break;
        case 40: //已收货
            
            break;
        case 50: //已提交
            
            break;
        case 60: //已确认
            
            break;
        case 70: //已取消
            
            break;
        case 80: //已过期
            
            break;
        default:
            break;
    }

}

#pragma mark ---UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int goodsCount = 0;
    ProcurementOrderModel *tempProcurementOrderModel = (ProcurementOrderModel *)(dataSource[indexPath.section]);
    goodsCount =  (int)tempProcurementOrderModel.ordergoodsModels.count;
    
    if (indexPath.row == 0) {
        //添加头部
        return 40.f;
    }
//    else if (indexPath.row == goodsCount + 1 ){
    else if (indexPath.row == 1 + 1 ){
        //添加尾部
        switch (tempProcurementOrderModel.orderState) {
            case 10: //未付款
                return 105.f;
            case 20: //已付款未发货
                
                break;
            case 30: //已发货待收货
                return 105.f;
            case 40: //已收货
                
                break;
            case 50: //已提交
                
                break;
            case 60: //已确认
                
                break;
            case 70: //已取消
                
                break;
            case 80: //已过期
                
                break;
            default:
                break;
        }
        return 45.f;
    }
    else {
        //添加中部cell高度
        return 88.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ProcurementOrderModel *tempProcurementOrderModel = (ProcurementOrderModel *)(dataSource[indexPath.section]);
    [self performSegueWithIdentifier:@"toProcurementDetail" sender:tempProcurementOrderModel.orderId];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //用于消去自带的背景色
    UIView *tempView = [[UIView alloc] init];
    [tempView setBackgroundColor:[UIColor clearColor]];
    return tempView;
}

#pragma mark ---UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //一个采购单中的商品数量
    int goodsCount;
    if (section < dataSource.count) {
        ProcurementOrderModel *tempProcurementOrderModel = (ProcurementOrderModel *)(dataSource[section]);
        goodsCount =  (int)tempProcurementOrderModel.ordergoodsModels.count;
    }
    
//    return goodsCount + 2;
    return 1 + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    ProcurementOrderModel *tempProcurementOrderModel = (ProcurementOrderModel *)(dataSource[indexPath.section]);
    int goodsCount = 0;
    
    if (indexPath.section < dataSource.count) {
        goodsCount =  (int)tempProcurementOrderModel.ordergoodsModels.count;
    }
    //添加头部
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyProcurementHeadTableViewCell"];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        //根据数据源设置显示字体
        UILabel *lblOrderAddTime = (UILabel*)[cell viewWithTag:101];
        UILabel *lblOrderState= (UILabel*)[cell viewWithTag:102];
        lblOrderAddTime.text = tempProcurementOrderModel.orderAddTime;
//        state: 10(默认):未付款;20:已付款;30:已发货;40:已收货;50:已提交;60已确认;70取消;80过期
        switch (tempProcurementOrderModel.orderState) {
            case 10: //未付款
                lblOrderState.text = @"待付款";
                break;
            case 20: //已付款未发货
                lblOrderState.text = @"待发货";
                break;
            case 30: //已发货待收货
                lblOrderState.text = @"待收货";
                break;
            case 40: //已收货
                lblOrderState.text = @"已收货";
                break;
            case 50: //已提交
                lblOrderState.text = @"已提交";
                break;
            case 60: //已确认
                lblOrderState.text = @"已确认";
                break;
            case 70: //已取消
                lblOrderState.text = @"已取消";
                break;
            case 80: //已过期
                lblOrderState.text = @"已过期";
                break;
            default:
                break;
        }
        
    }
//    else if(indexPath.row == goodsCount + 1 ){
    else if(indexPath.row == 2 ){
        //添加尾部
        static NSString *buyCellId=@"bottomCellId";
        MyProcurementBottomTableViewCell *buttomCell = [tableView dequeueReusableCellWithIdentifier:buyCellId];
        if (!buttomCell) {
            buttomCell = [[[NSBundle mainBundle] loadNibNamed:@"MyProcurementBottomTableViewCell" owner:self options:0] firstObject];
        }
        UILabel *lblOrderGoodsCount = (UILabel*)[buttomCell viewWithTag:301];
        UILabel *lblOrderAllPrice= (UILabel*)[buttomCell viewWithTag:302];
        //没有商品不用计算
        if (goodsCount == 0) {
            lblOrderGoodsCount.text = [[NSString alloc] initWithFormat:@"共%d件商品",0];
            lblOrderAllPrice.text = [[NSString alloc] initWithFormat:@"实付：￥%.2f",0.00];
        }
        //计算商品价格
        lblOrderGoodsCount.text = [[NSString alloc] initWithFormat:@"共%d件商品",goodsCount];
        GoodsModel *tempGoodsModel = (GoodsModel *)(tempProcurementOrderModel.ordergoodsModels[0]);
        float unitPrice = [tempGoodsModel.goodsPrice floatValue];
        float allPrice = unitPrice * goodsCount;
        lblOrderAllPrice.text = [[NSString alloc] initWithFormat:@"实付：￥%.2f",allPrice];
        
        //设置协议
        buttomCell.delegate = self;
        buttomCell.index = indexPath.section; //点击的数据行数
        switch (tempProcurementOrderModel.orderState) {
            case 10: //未付款
                [buttomCell setCanPaymentAndCancelOrder];
                break;
            case 20: //已付款未发货
                [buttomCell setNoOperation];
                break;
            case 30: //已发货待收货
                [buttomCell setCanGetGoods];
                break;
            case 40: //已收货
                [buttomCell setNoOperation];
                break;
            case 50: //已提交
                [buttomCell setNoOperation];
                break;
            case 60: //已确认
                [buttomCell setNoOperation];
                break;
            case 70: //已取消
                [buttomCell setNoOperation];
                break;
            case 80: //已过期
                [buttomCell setNoOperation];
                break;
            default:
                break;
        }
        
        return buttomCell;
    }
    else {
        //添加中部的商品信息
        static NSString *buyCellId=@"buyGoodCellId";
        HaveBuyGoodsTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:buyCellId];
        if (!goodsCell) {
            goodsCell = [[[NSBundle mainBundle] loadNibNamed:@"HaveBuyGoodsTableViewCell" owner:self options:0] firstObject];
        }
        //获取临时商品信息
        GoodsModel *tempGoodsModel = tempProcurementOrderModel.ordergoodsModels[indexPath.row - 1];
        [goodsCell.goodsImage setImageWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",KImageDonwloadAddr,tempGoodsModel.goodsImage]]];
        goodsCell.goodsDesc.text = tempGoodsModel.goodsName;
        goodsCell.goodsPrice.text = [[NSString alloc] initWithFormat:@"￥%@",tempGoodsModel.goodsPrice];
        goodsCell.selectedCount.text = [[NSString alloc] initWithFormat:@"x%d",goodsCount];
        
        return goodsCell;
    }
    return cell;
}

#pragma mark --  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ProcurementOrderModel *tempModel = dataSource[clickCellIndex];
    
    if (buttonIndex == 1) {
        if (alertView.tag == 1011) {
            //取消订单
            [[NetInterfaceManager sharedInstance] cancelGoodsOrder:tempModel.orderId];
            [self startWait];
        }
        else if(alertView.tag == 1012){
            //确认收货请求
            [[NetInterfaceManager sharedInstance] setGoodsOrderFinish:tempModel.orderId];
            [self startWait];
        }
    }
    
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
    [[NetInterfaceManager sharedInstance] getGoodsOrderList:requestType page:requestPage];
}

-(void) loadMoreData
{
    //加载更多操作
    refreshOrMore = 1;
    //加载更多
    requestPage ++;
    [[NetInterfaceManager sharedInstance] getGoodsOrderList:requestType page:requestPage];
}

#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_GetGoodsOrderList:
            if (result.resultCode == 0) {
                //如果是请求的第一页清空数据
                if (requestPage == 1) {
                    dataSource = nil;
                    dataSource = [[NSMutableArray alloc] init];
                }
                
                for (NSDictionary *tempDic in result.data) {
                    ProcurementOrderModel *tempProcurementOrderModel = [[ProcurementOrderModel alloc] initWithDictionary:tempDic];
                    [dataSource addObject:tempProcurementOrderModel];
                }
                //重新加载
                [self.mainTableView reloadData];
                //是否展示数据
                if (dataSource.count > 0) {
                    [self showPromptProcurement:NO];
                }
                else{
                    [self showPromptProcurement:YES];
                }
            }
            else {
                [self showTipsView:@"数据刷新失败，请重试!"];
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
        case KReqestType_CancelGoodsOrder:
            if (result.resultCode == 0) {
                //订单取消成功再次刷新订单详情
                [[NetInterfaceManager sharedInstance] getGoodsOrderList:requestType page:1];
                [self startWait];
            }
            else{
                [self showTipsView:@"订单取消失败!"];
            }
            break;
        case KReqestType_SetGoodsOrderFinish:
            if (result.resultCode == 0) {
                //订单取消成功再次刷新订单详情
                [[NetInterfaceManager sharedInstance] getGoodsOrderList:requestType page:1];
                [self startWait];
            }
            else{
                [self showTipsView:@"确认收货失败!"];
            }
            break;
        case KReqestType_weixinPay:
            if (result.resultCode == 0) {
                [self payOrder:payType data:result.data];
            }
            else{
                [self showTipsView:@"支付跳转失败!"];
            }
            break;
        case KReqestType_AliPay:
            if (result.resultCode == 0) {
                [self payOrder:payType data:result.data];
            }
            else{
                [self showTipsView:@"支付跳转失败!"];
            }
            break;
        default:
            break;
    }
}
-(void)httpRequestFailed:(NSNotification *)notification{
    [super httpRequestFailed:notification];
}
#pragma mark -- 支付
-(void)payOrder:(int)tempPayType data:(id)dict
{
    if (!dict) {
        return;
    }
    NSString *orderId;
    if (tempPayType == PayType_WeChat) {
        dict = (NSDictionary *)dict;
        if ([dict objectForKey:@"data"]) {
            dict = [dict objectForKey:@"data"];
        }
        if ([dict objectForKey:@"oid"]) {
            orderId = [dict objectForKey:@"oid"];
        }
        
    }
    else if(tempPayType == PayType_Ali){
        dict = (NSString *)dict;
    }
    //支付
    [[XDShareManager instance] payWithType:(int)tempPayType order:^(XDPayOrder *order) {
        if (tempPayType == PayType_WeChat) {
            XDWeChatOrder *or = (XDWeChatOrder*)order;
            or.appid = [dict objectForKey:@"appid"];
            or.noncestr = [dict objectForKey:@"noncestr"];
            or.package = [dict objectForKey:@"package"];
            or.partnerid = [dict objectForKey:@"partnerid"];
            or.prepayid = [dict objectForKey:@"prepayid"];
            or.timestamp = [dict objectForKey:@"timestamp"];
            or.sign = [dict objectForKey:@"sign"];
        }
        else if(tempPayType == PayType_Ali){
            XDAliOrder *or = (XDAliOrder*)order;
            or.aliDescription = dict;
        }
    } result:^(int code) {
        DBG_MSG(@"pay result code=%d", code);
        switch (code) {
            case PaySuccess:
            {
                //                //微信支付需要告诉后台移动端支付完成
                //                if (payType == PayType_WeChat){
                //                    [[NetInterfaceManager sharedInstance] checkWXPay:orderId];
                //                }
                //                //刷新数据
                //                [self getData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
            case ErrCodeCommon:
            {
                [self showTipsView:@"支付接口调用失败，请重试!"];
            }
                break;
            case ErrCodeUserCancel:   //用户取消支付
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
            case WXNotInstalled:
            {
                [self showTipsView:@"您的手机还没有安装微信，请先安装最新版的微信!"];
            }
                break;
            case WXNotSupportApi:
            {
                [self showTipsView:@"您安装的微信版本不支持微信支付，请先更新到最新版本!"];
            }
                break;
            default:
                break;
        }
    }];
    
}

@end







