//
//  CustomerOrderListViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerOrderListViewController.h"
#import "CustomerOrderListTableViewCell.h"
#import "CustomerOrderModel.h"
#import "GoodsModel.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>
#import "CustomerReturnGoodsViewController.h"
#import "CustomerHaveReturnGoodsViewController.h"

@interface CustomerOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,CustomerOrderListTableViewCellDelegate>{

    NSMutableArray *dataSource;
}

@end

@implementation CustomerOrderListViewController

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
    if ([controller isKindOfClass:[CustomerReturnGoodsViewController class]]) {
        //退货需要的参数
        NSDictionary *dicTemp = (NSDictionary*)sender;
        CustomerReturnGoodsViewController *tempController = (CustomerReturnGoodsViewController*)controller;
        tempController.goodsId = [dicTemp objectForKey:@"goodsId"];
        tempController.customerId = [dicTemp objectForKey:@"customerId"];
        tempController.saleorderId = [dicTemp objectForKey:@"saleorderId"];
        tempController.saleDetailId = [dicTemp objectForKey:@"saleDetailId"];
    }
    else if ([controller isKindOfClass:[CustomerHaveReturnGoodsViewController class]]){
        //退货列表需要的参数
        NSDictionary *dicTemp = (NSDictionary*)sender;
        CustomerHaveReturnGoodsViewController *tempController = (CustomerHaveReturnGoodsViewController*)controller;
        tempController.goodsId = [dicTemp objectForKey:@"goodsId"];
        tempController.customerId = [dicTemp objectForKey:@"customerId"];
        tempController.saleDetailId = [dicTemp objectForKey:@"saleDetailId"];
    }
}
//重新刷新页面
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求数据
    [[NetInterfaceManager sharedInstance] customerOrderlist:self.customerId];
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
#pragma mark ---

-(void) initInterface{
    dataSource = [[NSMutableArray alloc] init];
    //协议
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    //设置背景色
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
}


#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomerOrderModel *tempCustomerOrder = (CustomerOrderModel*)dataSource[indexPath.section];
    
    if (indexPath.row == 0) {
        return 40.f;
    }
    else if (indexPath.row == tempCustomerOrder.goods.count + 1){
        return 45.f;
    }
    else {
        return 88.f;
    }
    return 90.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
//返回透明视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tempView = [UIView new];
    [tempView setBackgroundColor:[UIColor clearColor]];
    return tempView;
}

#pragma mark --- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //数据类型section
    CustomerOrderModel *tempCustomerOrder = (CustomerOrderModel*)dataSource[section];
    
    return tempCustomerOrder.goods.count + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //数据类型section
    CustomerOrderModel *tempCustomerOrder = (CustomerOrderModel*)dataSource[indexPath.section];
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerOrderHeadIdent"];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        UILabel *lblDate = (UILabel *)[cell viewWithTag:101];
        UILabel *lblName = (UILabel *)[cell viewWithTag:102];
        if (tempCustomerOrder.saleDate && ![tempCustomerOrder.saleDate isKindOfClass:[NSNull class]]) {
            lblDate.text = tempCustomerOrder.saleDate;
        }
        else {
            lblDate.text =@"";
        }
        if (self.customername) {
            lblName.text = self.customername;
        }
        else {
            lblName.text =@"";
        }
    }
    else if (indexPath.row == tempCustomerOrder.goods.count + 1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerOrderBottomIdent"];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        UILabel *lblCount = (UILabel *)[cell viewWithTag:301];
        UILabel *lblTotal = (UILabel *)[cell viewWithTag:302];
        
        lblCount.text = [[NSString alloc] initWithFormat:@"共%lu件商品",(unsigned long)tempCustomerOrder.goods.count];
        lblTotal.text = [[NSString alloc] initWithFormat:@"￥%.2f",tempCustomerOrder.orderTotal];
    }
    else {
        static NSString *goodsCellId = @"";
        CustomerOrderListTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:goodsCellId];
        if (!goodsCell) {
            goodsCell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerOrderListTableViewCell" owner:self options:0] firstObject];
        }
        GoodsModel *tempGoodsModel = (GoodsModel*)(tempCustomerOrder.goods[indexPath.row - 1]);
        [goodsCell.goodsImage setImageWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",KImageDonwloadAddr,tempGoodsModel.goodsImage]]];
        //名称
        if (tempGoodsModel.goodsName && ![tempGoodsModel.goodsName isKindOfClass:[NSNull class]]) {
            goodsCell.goodsName.text = tempGoodsModel.goodsName;
        }
        else{
            goodsCell.goodsName.text = @"";
        }
        //单价
        goodsCell.goodsPrice.text =[[NSString alloc] initWithFormat:@"￥%.2f",tempGoodsModel.total] ;
        //个数
        goodsCell.goodsCount.text =[[NSString alloc] initWithFormat:@"x%d",tempGoodsModel.quantity] ;
        //索引位置
        goodsCell.indexPath = indexPath;
        
        goodsCell.delegate = self;
        //退货按钮显示
        if (tempGoodsModel.back) {
            [goodsCell.rightButton makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(84);
                make.right.equalTo(goodsCell.right).offset(-10);
            }];
        }
        else {
            [goodsCell.rightButton makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(0);
                make.right.equalTo(goodsCell.right).offset(0);
            }];
        }
        //已经退货按钮
        if (tempGoodsModel.returnedBack) {
            goodsCell.leftButton.hidden = NO;
        }
        else {
            goodsCell.leftButton.hidden = YES;
        }
        
        return goodsCell;
    }
    
    return cell;
}

#pragma mark --- CustomerOrderListTableViewCellDelegate
-(void)rightButtonClick:(CustomerOrderListTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    //传入的参数
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    CustomerOrderModel *tempCustomerOrder = (CustomerOrderModel*)dataSource[indexPath.section];
    NSArray *tempGoodsModels = tempCustomerOrder.goods;
    GoodsModel *tempGoodsModel = (GoodsModel *)tempGoodsModels[indexPath.row - 1];
    
    //传入的参数
    NSString *tempGoodsId = tempGoodsModel.productId;
    NSString *tempCustomerId = tempCustomerOrder.customerId;
    NSString *tempSaleorderId = tempCustomerOrder.orderId;
    NSString *tempSaleDetailId = tempGoodsModel.saleDetailId;
    
    [tempDic setObject:tempGoodsId forKey:@"goodsId"];
    [tempDic setObject:tempCustomerId forKey:@"customerId"];
    [tempDic setObject:tempSaleorderId forKey:@"saleorderId"];
    [tempDic setObject:tempSaleDetailId forKey:@"saleDetailId"];
    
    [self performSegueWithIdentifier:@"toCustomerReturnGoods" sender:tempDic];
}
-(void)leftButtonClick:(CustomerOrderListTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    //传入的参数
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    CustomerOrderModel *tempCustomerOrder = (CustomerOrderModel*)dataSource[indexPath.section];
    NSArray *tempGoodsModels = tempCustomerOrder.goods;
    GoodsModel *tempGoodsModel = (GoodsModel *)tempGoodsModels[indexPath.row - 1];
    
    //传入的参数
    NSString *tempGoodsId = tempGoodsModel.productId;
    NSString *tempCustomerId = tempCustomerOrder.customerId;
    NSString *tempSaleDetailId = tempGoodsModel.saleDetailId;
    
    [tempDic setObject:tempGoodsId forKey:@"goodsId"];
    [tempDic setObject:tempCustomerId forKey:@"customerId"];
    [tempDic setObject:tempSaleDetailId forKey:@"saleDetailId"];
    
    [self performSegueWithIdentifier:@"toCustomerHaveReturnGoods" sender:tempDic];
}
#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_CustomerOrderList:
        {
            if (result.resultCode == 0) {
                //释放内存
                dataSource = nil;
                //分配内存空间
                dataSource = [[NSMutableArray alloc] init];
                for (NSDictionary *tempDic in result.data) {
                    CustomerOrderModel *tempCustomerOrder = [[CustomerOrderModel alloc] initWithDictionary:tempDic];
                    [dataSource addObject:tempCustomerOrder];
                }
                //重新加载数据
                [self.mainTableView reloadData];
            }
            else if (result.resultCode == 1){
//                [self showTipsView:result.desc];
                [self showTipsView:@"此用户无订单！"];
            }
            else{
                [self showTipsView:@"数据获取失败！"];
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
