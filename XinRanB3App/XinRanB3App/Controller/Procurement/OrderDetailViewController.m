//
//  OrderDetailViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "HaveBuyGoodsTableViewCell.h"
#import "GoodsModel.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>
#import <XRNetInterface/EnvPreferences.h>
#import "UserAddressModel.h"
#import "EditorAddressViewController.h"
#import <XRShareSDK/XDShareManager.h>
#import "Areas.h"
#import "ShipAddressViewController.h"


@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UIButton *btnAliBk;
    UIButton *btnAli;
    UIButton *btnWechatBk;
    UIButton *btnWechat;
    int payType;
}

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //重新加载数据
    [self.mainTableView reloadData];
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
    //启动的时候设置选择地址为空
    [[EnvPreferences sharedInstance] setSelectedShipAddress:nil];
    
    //默认设置阿狸支付
    payType = PayType_Ali;
    
    //设置背景颜色
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    //设置协议
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    //如果没有数据初始化对象
    if (!self.dataSource) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    //请求服务器获取默认收货地址
    [[NetInterfaceManager sharedInstance] getDefaultConfignees];
    [self startWait];
    
}
//添加提示没有提示界面
-(UIView*)addrTipsView
{
    UIView *view = [UIView new];
    view.tag = 1110;
    [view setBackgroundColor:[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.6]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([[UIApplication sharedApplication] keyWindow]);
    }];
    
    UIImageView *ivBK = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gotoEditeLogo"]];
    [view addSubview:ivBK];
    [ivBK makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(view);
        make.centerX.equalTo(view);
        make.top.equalTo(140);
        make.width.equalTo(50);
        make.height.equalTo(66);
    }];
    
    UILabel *label1 = [UILabel new];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont boldSystemFontOfSize:15];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"你还没有收货地址，请去编辑";
    [view addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(ivBK.bottom).offset(25);
        make.height.equalTo(20);
    }];
    
//    UILabel *label2 = [UILabel new];
//    label2.textColor = [UIColor whiteColor];
//    label2.font = [UIFont boldSystemFontOfSize:17];
//    label2.textAlignment = NSTextAlignmentCenter;
//    label2.text = @"请先编辑您的收货地址!";
//    [view addSubview:label2];
//    [label2 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view);
//        make.right.equalTo(view);
//        make.top.equalTo(label1.bottom).offset(5);
//        make.height.equalTo(25);
//    }];
    
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.backgroundColor = [UIColor clearColor];
    [btnEdit setTitle:@"" forState:UIControlStateNormal];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"btn_editaddr"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(btnEditAddrClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnEdit];
    [btnEdit makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(label1.bottom).offset(30);
        make.height.equalTo(33);
        make.width.equalTo(84);
    }];
    
//    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnClose.backgroundColor = [UIColor clearColor];
//    [btnClose setTitle:@"" forState:UIControlStateNormal];
//    [btnClose setBackgroundImage:[UIImage imageNamed:@"btn_editclose"] forState:UIControlStateNormal];
//    [btnClose addTarget:self action:@selector(btnEditCloseClick:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btnClose];
//    [btnClose makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view).offset(10);
//        make.right.equalTo(view).offset(-5);
//        make.height.equalTo(37);
//        make.width.equalTo(37);
//    }];
    
    return view;
}
-(void)btnEditAddrClick:(id)sender
{
    UIView *view = [[[UIApplication sharedApplication] keyWindow] viewWithTag:1110];
    if (view) {
        [view removeFromSuperview];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    EditorAddressViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"EditorAddressViewControllerIdent"];
    //设置为选择跳入的新增
    c.controlType = 2;
    [self.navigationController pushViewController:c animated:YES];
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

- (IBAction)submitOrder:(id)sender {
    //点击提交如果没有默认地址，显示提示
    
    if(![[EnvPreferences sharedInstance] getSelectedShipAddress]){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//        EditorAddressViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"ShipAddressViewController"];
//        [self.navigationController pushViewController:c animated:YES];
        [self addrTipsView];
    }
    //用户地址信息
    NSDictionary *tempDic = [[EnvPreferences sharedInstance] getSelectedShipAddress];
    UserAddressModel *tempUserAddressModel = (UserAddressModel*)[tempDic objectForKey:@"selectedShipAddress"];
    //选择的商品信息
    NSMutableArray *tempGoodsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dicTemp in self.dataSource) {
        //设置商品详情
        GoodsModel *tempGoodsModel = (GoodsModel *)[dicTemp objectForKey:@"goodsModel"];
        //设置购买数量
        NSString *buyCount = [dicTemp objectForKey:@"selectedCount"];
        //订单请求字典
        NSMutableDictionary *tempGoodsDic = [[NSMutableDictionary alloc] init];
        [tempGoodsDic setObject:tempGoodsModel.goodsId forKey:KJsonElement_GId];
        [tempGoodsDic setObject:buyCount forKey:KJsonElement_Num];
        
        //添加到数组
        [tempGoodsArray addObject:tempGoodsDic];
    }
    //可提交订单
    [[NetInterfaceManager sharedInstance] buyGoodsOrder:@"" consignee_id:tempUserAddressModel.addId pay_type:payType goods:tempGoodsArray];
    [self startWait];
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

#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 85.f;
            break;
        case 1:
            return 95.f;
            break;
        case 2:
            return 40.f;
            break;
        case 3:
            return 100.f;
            break;
        default:
            break;
    }
    
    return 100.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        return 0.f;
    }
    //之间的间隔
    return 10.f;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *tempView = [UIView new];
    [tempView setBackgroundColor:[UIColor clearColor]];
    return tempView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //点击地址栏目的时候跳转编辑还是添加选择地址
    if (indexPath.section == 0) {
        NSDictionary *tempDefaultAddress = [[EnvPreferences sharedInstance] getSelectedShipAddress];
        if (!tempDefaultAddress) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            EditorAddressViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"EditorAddressViewControllerIdent"];
            //设置为选择跳入的新增
            c.controlType = 2;
            [self.navigationController pushViewController:c animated:YES];
        }
        else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            ShipAddressViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"ShipAddressViewControllerIdent"];
            c.controlType = 2;
            [self.navigationController pushViewController:c animated:YES];
        }
    }

}
#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return self.dataSource.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCellIdent"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            UILabel *lblName = (UILabel*)[cell viewWithTag:103];
            UILabel *lblPhone= (UILabel*)[cell viewWithTag:104];
            UILabel *lblAddress= (UILabel*)[cell viewWithTag:105];
            NSDictionary *tempDic = [[EnvPreferences sharedInstance] getSelectedShipAddress];
            //有地址设置
            if (tempDic) {
                UserAddressModel *userAddressModel = [tempDic objectForKey:@"selectedShipAddress"];
                //收货人姓名
                if (!userAddressModel.name || [userAddressModel.name isKindOfClass:[NSNull class]]) {
                    lblName.text = @"";
                }
                else{
                    lblName.text = userAddressModel.name;
                }
                //收货人电话号码
                if (!userAddressModel.phone || [userAddressModel.phone isKindOfClass:[NSNull class]]) {
                    lblPhone.text = @"";
                }
                else{
                    lblPhone.text = userAddressModel.phone;
                }
                //收货人详细地址
                if (!userAddressModel.address || [userAddressModel.address isKindOfClass:[NSNull class]] || !userAddressModel.area_id || [userAddressModel.area_id isKindOfClass:[NSNull class]] ) {
                    lblAddress.text = @"收货地址：";
                }
                else{
                    lblAddress.text = [[NSString alloc] initWithFormat:@"收货地址：%@%@",[self getAdressByAreaId:userAddressModel.area_id],userAddressModel.address];
                }
                
                
            }
            else {
                lblName.text = @"";
                lblPhone.text = @"";
                lblAddress.text = @"收货地址：";
            }
        }
            break;
        case 1:
        {
            static NSString *buyCellId=@"buyGoodCellId";
            HaveBuyGoodsTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:buyCellId];
            if (!goodsCell) {
                goodsCell = [[[NSBundle mainBundle] loadNibNamed:@"HaveBuyGoodsTableViewCell" owner:self options:0] firstObject];
            }
            //从数据源拉去数据
            NSDictionary *cellGoodsDic = (NSDictionary *)[self.dataSource objectAtIndex:indexPath.row];
            GoodsModel *tempGoods = (GoodsModel *)[cellGoodsDic objectForKey:@"goodsModel"];
            
            //数据加载
            goodsCell.selectedCount.text = [[NSString alloc] initWithFormat:@"x%@",(NSString *)[cellGoodsDic objectForKey:@"selectedCount"]];
            [goodsCell.goodsImage setImageWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",KImageDonwloadAddr,tempGoods.goodsImage]]];
            goodsCell.goodsDesc.text = tempGoods.goodsName;
            goodsCell.goodsPrice.text = [[NSString alloc] initWithFormat:@"￥%@",tempGoods.goodsPrice];
            return goodsCell;
            
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CumulativeCellIdent"];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            //这个是现实数据
            //重新加载总价格与选中个数
            int allSelectedCount = 0; float allPrice = 0.f;
            //计算
            for (NSDictionary *dicTempOneDataSource in self.dataSource) {
                GoodsModel *tempGoodsModel = [dicTempOneDataSource objectForKey:@"goodsModel" ];
                NSString *isSelectedState = [dicTempOneDataSource objectForKey:@"isSelected"];
                NSString *selectedCountState = [dicTempOneDataSource objectForKey:@"selectedCount"];
                //如果是选中的
                if ([isSelectedState isEqualToString:@"1"]) {
                    allSelectedCount ++;
                    allPrice += [selectedCountState integerValue] * [tempGoodsModel.goodsPrice floatValue];
                }
            }
            //设置显示
            UILabel *lblSelectedCount = (UILabel*)[cell viewWithTag:301];
            lblSelectedCount.text = [[NSString alloc] initWithFormat:@"共%d件商品",allSelectedCount];
            UILabel *lblAllPrice = (UILabel*)[cell viewWithTag:302];
            lblAllPrice.text = [[NSString alloc] initWithFormat:@"实付：￥%.2f",allPrice];
            self.allPrice.text = [[NSString alloc] initWithFormat:@"￥%.2f",allPrice];
        }
            break;
        case 3:
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
            
            btnAliBk = (UIButton*)[cell viewWithTag:401];
            btnAli = (UIButton*)[cell viewWithTag:402];
            btnWechatBk = (UIButton*)[cell viewWithTag:403];
            btnWechat = (UIButton*)[cell viewWithTag:404];
            
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
        case KReqestType_GetDefaultConfignees:
        {
            if (result.resultCode == 0) {
                UserAddressModel *userAddressModel = [[UserAddressModel alloc] initWithDictionary:result.data];
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
                [tempDic setValue:userAddressModel forKey:@"selectedShipAddress"];
                [[EnvPreferences sharedInstance] setSelectedShipAddress:tempDic];
                //重新加载一次
                [self.mainTableView reloadData];
            }
//            else if (result.resultCode == 1){
            else{
                [[EnvPreferences sharedInstance] setSelectedShipAddress:nil];
                [self addrTipsView];
            }
            
        }
            break;
        case KReqestType_BuyGoodsOrder:
        {
            //生成订单
            if (result.resultCode == 0) {
                //生成成功，再支付
//                [self payOrder:result.data];
                [self payOrder:payType data:result.data];
            }
            else if  (result.resultCode == 1)  {
                [self showTipsView:@"库存不足！"];
            }
            else if  (result.resultCode == 4)  {
                [self showTipsView:@"订单金额超限！"];
            }
            else if  (result.resultCode == 5)  {
                [self showTipsView:@"购买数量超限！"];
            }
            else if  (result.resultCode == 6)  {
                [self showTipsView:@"同一商品未付款！"];
            }
            else if  (result.resultCode == 7)  {
                [self showTipsView:@"存在30分钟内三个以上未付款订单！"];
            }
            else {
                [self showTipsView:@"订单生成失败！"];
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
        dict = (NSDictionary *)dict;
        orderId  = [dict objectForKey:KJsonElement_OrderId];
    }
    //支付
    [[XDShareManager instance] payWithType:(int)payType order:^(XDPayOrder *order) {
        if (payType == PayType_WeChat) {
            XDWeChatOrder *or = (XDWeChatOrder*)order;
            or.appid = [dict objectForKey:@"appid"];
            or.noncestr = [dict objectForKey:@"noncestr"];
            or.package = [dict objectForKey:@"package"];
            or.partnerid = [dict objectForKey:@"partnerid"];
            or.prepayid = [dict objectForKey:@"prepayid"];
            or.timestamp = [dict objectForKey:@"timestamp"];
            or.sign = [dict objectForKey:@"sign"];
        }
        else if(payType == PayType_Ali){
            XDAliOrder *or = (XDAliOrder*)order;
            or.aliDescription = [dict objectForKey:KJsonElement_Data];
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
                //返回采购单列表
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
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
                //返回采购单列表
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
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













