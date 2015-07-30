//
//  MyProcurementDetailViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/31.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "MyProcurementDetailViewController.h"
#import "HaveBuyGoodsTableViewCell.h"
#import <XRNetInterface/NetInterfaceManager.h>
#import "ProcurementOrderDetailModel.h"
#import "GoodsModel.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>
#import "Areas.h"
#import <XRShareSDK/XDShareManager.h>

@interface MyProcurementDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    //数据源
    ProcurementOrderDetailModel *dataSourceProcurementOrderDetailModel;
    //支付类型
    int payType;
    UIButton *btnAliBk;
    UIButton *btnAli;
    UIButton *btnWechatBk;
    UIButton *btnWechat;
}

@end

@implementation MyProcurementDetailViewController

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

#pragma mark --
-(void)initInterface{
    //请求数据
    if (self.orderId) {
        [[NetInterfaceManager sharedInstance] getGoodsOrderDetail:self.orderId];
        [self startWait];
    }
    //tableview数据展示设置
    [self setupMainTableView];
    //设置底部
    [self setupButtomView];
}
//数据展示设置
-(void)setupMainTableView {
    
    dataSourceProcurementOrderDetailModel = [[ProcurementOrderDetailModel alloc] init];
    //设置背景颜色
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    //初始化默认数据
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
}
//设置底部的数据信息
-(void)setupButtomView{
    //        state: 10(默认):未付款;20:已付款;30:已发货;40:已收货;50:已提交;60已确认;70取消;80过期
    switch (dataSourceProcurementOrderDetailModel.detailState) {
        case 10: //未付款
            [self setCanPaymentAndCancelOrder];
            break;
        case 20: //已付款未发货
            [self setNoOperation];
            break;
        case 30: //已发货待收货
            [self setCanGetGoods];
            break;
        case 40: //已收货
            [self setNoOperation];
            break;
        case 50: //已提交
            [self setNoOperation];
            break;
        case 60: //已确认
            [self setNoOperation];
            break;
        case 70: //已取消
            [self setNoOperation];
            break;
        case 80: //已过期
            [self setNoOperation];
            break;
        default:
            break;
    }
}

//设置包含付款和取消订单信息
-(void) setCanPaymentAndCancelOrder{
    
    //设置为显示
    [self.leftButton setHidden:NO];
    [self.rightButton setHidden:NO];
    [self.topLine setHidden:NO];
    [self.buttonView setHidden:NO];
    
    //设置为灰色
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"icon_btnBkQuXiao"] forState:UIControlStateNormal];
    [self.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"icon_btnBkBuy"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"付款" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(45);
    }];
    
}
//设置包含付款和取消订单信息
-(void) setNoOperation{
    
    //设置为显示
    [self.leftButton setHidden:YES];
    [self.rightButton setHidden:YES];
    [self.topLine setHidden:YES];
    [self.buttonView setHidden:YES];
    
    [self.buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0);
    }];
}

//设置包含确认收货
-(void) setCanGetGoods{
    //设置为显示
    [self.leftButton setHidden:YES];
    [self.rightButton setHidden:NO];
    [self.topLine setHidden:NO];
    [self.buttonView setHidden:NO];
    
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"icon_btnBkBuy"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(45);
    }];
}
//根据区域id获取区域字符串
-(NSString*)getAdressByAreaId:(NSString *)areaId  {
    //设置收货人地址绑定
    if (areaId) {
        //数据库取数据
        NSString *stringDistrict=@"";NSString *stringCity=@"";NSString *stringProvince=@"";
        //取县区
        Areas *arDistrict = [Areas getArearWithId:areaId];
        if (arDistrict) {
            //定位使用当前的区域
            stringDistrict = arDistrict.name;
            //取市
            Areas *arCity = [Areas getArearWithId:arDistrict.pId];
            if (arCity) {
                stringCity = arCity.name;
                //取省
                Areas *arProvince = [Areas getArearWithId:arCity.pId];
                if (arProvince) {
                    stringProvince = arProvince.name;
                }
                
            }
        }
        return [[NSString alloc] initWithFormat:@"%@%@%@",stringProvince,stringCity,stringDistrict];
    }
    return @"";
}
-(void)btnWechatBKClick:(id)sender
{
    [btnAli setBackgroundImage:[UIImage imageNamed:@"icon_not_selected"] forState:UIControlStateNormal];
    [btnWechat setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    payType = PayType_WeChat;
    //    payType = 0;
}

-(void)btnAliBKClick:(id)sender
{
    [btnAli setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    [btnWechat setBackgroundImage:[UIImage imageNamed:@"icon_not_selected"] forState:UIControlStateNormal];
    payType = PayType_Ali;
    //    payType = 1;
}
//右边的按钮点击
- (IBAction)rightBtnClick:(id)sender {
    //        state: 10(默认):未付款;20:已付款;30:已发货;40:已收货;50:已提交;60已确认;70取消;80过期
    switch (dataSourceProcurementOrderDetailModel.detailState) {
        case 10: //未付款
        {
            //此按钮为付款按钮
            //计算总价格
            float totalPrice = 0.0f;
            NSMutableArray *tempGoodsInfor = dataSourceProcurementOrderDetailModel.detailGoodsModels;
            for (GoodsModel *tempGoodsModel in tempGoodsInfor) {
                totalPrice = totalPrice + [tempGoodsModel.goodsPrice floatValue];
            }
            //计算支付方式
//            if ([dataSourceProcurementOrderDetailModel.detailPaymentId isEqualToString:@"1"]) {
//                payType = PayType_Ali;
//            }
//            else if([dataSourceProcurementOrderDetailModel.detailPaymentId  isEqualToString:@"2"]){
//                payType = PayType_WeChat;
//            }
            //支付接口调用
            if (payType == PayType_Ali) {
                [[NetInterfaceManager sharedInstance] aliPay:@"" price:[[NSString alloc] initWithFormat:@"%.2f",totalPrice] orderId:dataSourceProcurementOrderDetailModel.detailId];
                [self startWait];
            }
            else if (payType == PayType_WeChat){
                //支付数据请求
                [[NetInterfaceManager sharedInstance] weixinPay:@"" price:[[NSString alloc] initWithFormat:@"%.2f",totalPrice] orderId:dataSourceProcurementOrderDetailModel.detailId];
                [self startWait];
            }
        }
            break;
        case 20: //已付款未发货
            break;
        case 30: //已发货待收货
        {
            //此按钮为确认收货按钮
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确认已收货了？确认后将完成交易" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 1022;
            alertView.delegate = self;
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

- (IBAction)leftBtnClick:(id)sender {
    //        state: 10(默认):未付款;20:已付款;30:已发货;40:已收货;50:已提交;60已确认;70取消;80过期
    switch (dataSourceProcurementOrderDetailModel.detailState) {
        case 10: //未付款
        {
            //此按钮为取消订单按钮
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确认取消此订单？确认后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 1021;
            alertView.delegate = self;
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
#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1021:
        {
            if (buttonIndex == 1) {
                //取消订单
                [[NetInterfaceManager sharedInstance] cancelGoodsOrder:dataSourceProcurementOrderDetailModel.detailId];
                [self startWait];
            }
        }
            break;
        case 1022:
        {
            if (buttonIndex == 1) {
                //确认收货请求
                [[NetInterfaceManager sharedInstance] setGoodsOrderFinish:dataSourceProcurementOrderDetailModel.detailId];
                [self startWait];
            }
        }
        default:
            break;
    }
}

#pragma mark ---UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //        state: 10(默认):未付款;20:已付款;30:已发货;40:已收货;50:已提交;60已确认;70取消;80过期
    
    switch (indexPath.section) {
        case 0:
            return 85.f;
        case 1:
            return 80.f;
        case 2:
        {
            //物流信息
            switch (dataSourceProcurementOrderDetailModel.detailState) {
                case 30:
                    return 115.f; //待收货
                case 40:
                    return 115.f; //已完成
            }
            return 0.f;
        }
            
        case 3:
            return 90.f;
        case 4:
            return 43.f;
        case 6:
        {
            //待收货的时候自动收货时间减少
            if (dataSourceProcurementOrderDetailModel.detailState == 30) {
                return 88.f;
            }
            return 60.f;
        }
        case 5:
        {
            //未支付的时候
            if (dataSourceProcurementOrderDetailModel.detailState != 10) {
                return 0.f;
            }
            return 100.f;
        }
            
        default:
            break;
    }
    
    return 100.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            break;
        case 1:
            break;
        case 2:
        {
            //物流信息
            switch (dataSourceProcurementOrderDetailModel.detailState) {
                case 30:
                    return 10.f; //待收货
                case 40:
                    return 10.f; //已完成
                default:
                    return 0.f;
            }
        }
            
        case 3:
            break;
        case 4:
            return 0.f;
        case 6:
            break;
        case 5:
        {
            //未支付的时候
            if (dataSourceProcurementOrderDetailModel.detailState != 10) {
                return 0.f;
            }
        }
        default:
            break;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    //去掉头部背景色
    UIView *tempView = [UIView new];
    
    [tempView setBackgroundColor:[UIColor clearColor]];
    
    return tempView;
}

#pragma mark ---UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3 && dataSourceProcurementOrderDetailModel) {
        if (dataSourceProcurementOrderDetailModel.detailGoodsModels) {
            return  dataSourceProcurementOrderDetailModel.detailGoodsModels.count;
        }
        
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsStateCellIdent"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            
            UILabel *lblState = (UILabel*)[cell viewWithTag:101];
            UILabel *lblPayment = (UILabel*)[cell viewWithTag:102];
            UILabel *lblPayPrice = (UILabel*)[cell viewWithTag:103];
            //        state: 10(默认):未付款;20:已付款;30:已发货;40:已收货;50:已提交;60已确认;70取消;80过期
            switch (dataSourceProcurementOrderDetailModel.detailState) {
                case 10: //未付款
                    lblState.text = @"待付款";
                    break;
                case 20: //已付款未发货
                    lblState.text = @"待发货";
                    break;
                case 30: //已发货待收货
                    lblState.text = @"待收货";
                    break;
                case 40: //已收货
                    lblState.text = @"已完成";
                    break;
                case 50: //已提交
                    lblState.text = @"已提交";
                    break;
                case 60: //已确认
                    lblState.text = @"已确认";
                    break;
                case 70: //已取消
                    lblState.text = @"已取消";
                    break;
                case 80: //已过期
                    lblState.text = @"已过期";
                    break;
                default:
                    break;
            }
            //支付方式
            if (!dataSourceProcurementOrderDetailModel.detailPaymentId || [dataSourceProcurementOrderDetailModel.detailPaymentId isKindOfClass:[NSNull class]]) {
                lblPayment.text = @"";
            }
            else {
                if ([dataSourceProcurementOrderDetailModel.detailPaymentId isEqualToString:@"1"]) {
                    lblPayment.text = @"支付宝";
                    payType = PayType_Ali;
                }
                else if ([dataSourceProcurementOrderDetailModel.detailPaymentId isEqualToString:@"2"]){
                    lblPayment.text = @"微信";
                    payType = PayType_WeChat;
                }
                else{
                    lblPayment.text = @"";
                }
            }
            
            if (!dataSourceProcurementOrderDetailModel.detailPrice || [dataSourceProcurementOrderDetailModel.detailPrice isKindOfClass:[NSNull class]]) {
                //支付价格
                lblPayPrice.text = @"";
            }
            else{
                //支付价格
                lblPayPrice.text = [[NSString alloc] initWithFormat:@"￥%@",dataSourceProcurementOrderDetailModel.detailPrice];
            }
            
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCellIdent"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            UILabel *lblName = (UILabel*)[cell viewWithTag:201];
            UILabel *lblPhone = (UILabel*)[cell viewWithTag:202];
            UILabel *lblAddress = (UILabel*)[cell viewWithTag:203];
            //支付价格
            if (!dataSourceProcurementOrderDetailModel.detailConsignee || [dataSourceProcurementOrderDetailModel.detailConsignee isKindOfClass:[NSNull class]]) {
                lblName.text = @"";
            }
            else{
                lblName.text = dataSourceProcurementOrderDetailModel.detailConsignee;
            }
            //电话号码
            if (!dataSourceProcurementOrderDetailModel.detailPhone || [dataSourceProcurementOrderDetailModel.detailPhone isKindOfClass:[NSNull class]]) {
                lblPhone.text = @"";
            }
            else{
                lblPhone.text = dataSourceProcurementOrderDetailModel.detailPhone;
            }
            //详细地址
            if (!dataSourceProcurementOrderDetailModel.detailAddress || [dataSourceProcurementOrderDetailModel.detailAddress isKindOfClass:[NSNull class]] || !dataSourceProcurementOrderDetailModel.detailAreaId ||[dataSourceProcurementOrderDetailModel.detailAreaId isKindOfClass:[NSNull class]]) {
                lblAddress.text = @"收货地址：";
            }
            else{
                lblAddress.text = [[NSString alloc]initWithFormat:@"收货地址：%@%@",[self getAdressByAreaId:dataSourceProcurementOrderDetailModel.detailAreaId],dataSourceProcurementOrderDetailModel.detailAddress];
            }
            
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsWuLiuIndent"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            UILabel *lblCourierName = (UILabel*)[cell viewWithTag:301];
            UILabel *lblCourierNum = (UILabel*)[cell viewWithTag:302];
            UILabel *lblCourierTime = (UILabel*)[cell viewWithTag:303];
            
            if (!dataSourceProcurementOrderDetailModel.detailShippingCompany || [dataSourceProcurementOrderDetailModel.detailShippingCompany isKindOfClass:[NSNull class]]) {
                lblCourierName.text = @"";
            }
            else{
                lblCourierName.text = dataSourceProcurementOrderDetailModel.detailShippingCompany;
            }
            
            if (!dataSourceProcurementOrderDetailModel.detailShippingCode || [dataSourceProcurementOrderDetailModel.detailShippingCode isKindOfClass:[NSNull class]]) {
                lblCourierNum.text = @"";
            }
            else{
                lblCourierNum.text = dataSourceProcurementOrderDetailModel.detailShippingCode;
            }
            
            if (!dataSourceProcurementOrderDetailModel.detailShippingTime || [dataSourceProcurementOrderDetailModel.detailShippingTime isKindOfClass:[NSNull class]]) {
                lblCourierTime.text = @"";
            }
            else{
                lblCourierTime.text = dataSourceProcurementOrderDetailModel.detailShippingTime;
            }
            
        }
            break;
        case 3:
        {
            //添加中部的商品信息
            static NSString *buyCellId=@"buyGoodCellId";
            HaveBuyGoodsTableViewCell *headCell = [tableView dequeueReusableCellWithIdentifier:buyCellId];
            if (!headCell) {
                headCell = [[[NSBundle mainBundle] loadNibNamed:@"HaveBuyGoodsTableViewCell" owner:self options:0] firstObject];
            }
            NSMutableArray *tempGoodsDetail = dataSourceProcurementOrderDetailModel.detailGoodsModels;
            //没有商品数据
            if (!tempGoodsDetail) {
                headCell.selectedCount.text = @"";
                headCell.goodsDesc.text = @"";
                headCell.goodsPrice.text = @"";
                return headCell;
            }
            GoodsModel *tempGoodsModel = tempGoodsDetail[indexPath.row];
            //数量
            headCell.selectedCount.text = [[NSString alloc] initWithFormat:@"x%d",tempGoodsModel.goodsNum];
            //图片
            if (!tempGoodsModel.goodsImage || [tempGoodsModel.goodsImage isKindOfClass:[NSNull class]]) {
            }
            else{
                [headCell.goodsImage setImageWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",KImageDonwloadAddr,tempGoodsModel.goodsImage]]];
            }
            //名称
            if (!tempGoodsModel.goodsName || [tempGoodsModel.goodsName isKindOfClass:[NSNull class]]) {
                headCell.goodsDesc.text = @"";
            }
            else{
                headCell.goodsDesc.text = tempGoodsModel.goodsName;
            }
            //价格
            if (!tempGoodsModel.goodsPrice || [tempGoodsModel.goodsPrice isKindOfClass:[NSNull class]]) {
                headCell.goodsPrice.text = @"";
            }
            else{
                headCell.goodsPrice.text = [[NSString alloc] initWithFormat:@"￥%@",tempGoodsModel.goodsPrice];
            }
            
            return headCell;
        }
            break;
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CalculateCellIdent"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            UILabel *lblGoodsCount = (UILabel*)[cell viewWithTag:401];
            UILabel *lblGoodsAllPrice = (UILabel*)[cell viewWithTag:402];
            
            lblGoodsCount.text = [[NSString alloc] initWithFormat:@"共%lu件商品",(unsigned long)dataSourceProcurementOrderDetailModel.detailGoodsModels.count];
            //价格
            if (!dataSourceProcurementOrderDetailModel.detailPrice || [dataSourceProcurementOrderDetailModel.detailPrice isKindOfClass:[NSNull class]]) {
                lblGoodsAllPrice.text = @"";
            }
            else{
                lblGoodsAllPrice.text = [[NSString alloc] initWithFormat:@"实付：￥%@",dataSourceProcurementOrderDetailModel.detailPrice];
            }
            
        }
            break;
        case 6:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"OrderInforIdent"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            UILabel *lblOrderNum = (UILabel*)[cell viewWithTag:501];
            UILabel *lblOrderTime = (UILabel*)[cell viewWithTag:502];
            UILabel *lblOrderEndTime = (UILabel*)[cell viewWithTag:503];
            
            if (!dataSourceProcurementOrderDetailModel.detailId || [dataSourceProcurementOrderDetailModel.detailId isKindOfClass:[NSNull class]]) {
                lblOrderNum.text = @"";
            }
            else{
                lblOrderNum.text = dataSourceProcurementOrderDetailModel.detailId;
            }
            
            if (!dataSourceProcurementOrderDetailModel.detailAddTime || [dataSourceProcurementOrderDetailModel.detailAddTime isKindOfClass:[NSNull class]]) {
                lblOrderTime.text = @"";
            }
            else{
                lblOrderTime.text = dataSourceProcurementOrderDetailModel.detailAddTime;
            }
            
            if (!dataSourceProcurementOrderDetailModel.detailAddTime || [dataSourceProcurementOrderDetailModel.detailAddTime isKindOfClass:[NSNull class]]) {
                lblOrderEndTime.text = @"";
            }
            else{
                lblOrderEndTime.text = dataSourceProcurementOrderDetailModel.detailAddTime;
            }
        }
            break;
        case 5:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PayCellIdent"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            //根据数据设置选中项
            if (payType == PayType_Ali) {
                [self btnAliBKClick:nil];
            }
            else if(payType == PayType_WeChat){
                [self btnWechatBKClick:nil];
            }
            
            btnAliBk = (UIButton*)[cell viewWithTag:601];
            btnAli = (UIButton*)[cell viewWithTag:602];
            btnWechatBk = (UIButton*)[cell viewWithTag:603];
            btnWechat = (UIButton*)[cell viewWithTag:604];
            
            [btnAliBk addTarget:self action:@selector(btnAliBKClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnWechatBk addTarget:self action:@selector(btnWechatBKClick:) forControlEvents:UIControlEventTouchUpInside];
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
        case KReqestType_GetGoodsOrderDetail:
            if (result.resultCode == 0) {
                dataSourceProcurementOrderDetailModel = [[ProcurementOrderDetailModel alloc] initWithDictionary:result.data];
                //重新加载
                [self.mainTableView reloadData];
                //设置底部
                [self setupButtomView];
            }
            break;
        case KReqestType_CancelGoodsOrder:
            if (result.resultCode == 0) {
                //订单取消成功再次刷新订单详情
                [[NetInterfaceManager sharedInstance] getGoodsOrderDetail:self.orderId];
                [self startWait];
            }
            else{
                [self showTipsView:@"订单取消失败"];
            }
            break;
        case KReqestType_SetGoodsOrderFinish:
            if (result.resultCode == 0) {
                //订单取消成功再次刷新订单详情
                [[NetInterfaceManager sharedInstance] getGoodsOrderDetail:self.orderId];
                [self startWait];
            }
            else{
                [self showTipsView:@"确认收货失败"];
            }
            break;
        case KReqestType_weixinPay:
            if (result.resultCode == 0) {
                [self payOrder:payType data:result.data];
            }
            else{
                [self showTipsView:@"支付跳转失败"];
            }
            break;
        case KReqestType_AliPay:
            if (result.resultCode == 0) {
                [self payOrder:payType data:result.data];
            }
            else{
                [self showTipsView:@"支付跳转失败"];
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
                //返回采购单详情
                [self.navigationController popToRootViewControllerAnimated:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GotoProcurementListControl object:nil];
                });
            }
                break;
            case ErrCodeCommon:
            {
                [self showTipsView:@"支付接口调用失败，请重试!"];
            }
                break;
            case ErrCodeUserCancel:   //用户取消支付
            {
                //返回采购单详情
                [self.navigationController popToRootViewControllerAnimated:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_GotoProcurementListControl object:nil];
                });
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
