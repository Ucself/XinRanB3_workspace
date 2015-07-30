//
//  CustomerPlaceOrderViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerPlaceOrderViewController.h"
#import "GoodsListTableViewCell.h"
#import <XRNetInterface/UIImageView+AFNetworking.h>
#import <XRNetInterface/NetInterfaceManager.h>
#import "GoodsModel.h"

@interface CustomerPlaceOrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataSource;
}
@end

@implementation CustomerPlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInterface];
    // Do any additional setup after loading the view.
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

-(void)initInterface{
    
    dataSource = [[NSMutableArray alloc] init];
    //协议
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    //设置背景色
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    //请求数据
    [[NetInterfaceManager sharedInstance] getCustomerProductList:1 rangNum:20];
    [self startWait];
}

//重新加载界面
-(void)interfaceToReload{
    //重新加载总价格与选中个数
    int allSelectedCount = 0; float allPrice = 0.f;
    //计算
    for (NSDictionary *dicTempOneDataSource in dataSource) {
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
    self.lblGoodsCount.text = [[NSString alloc] initWithFormat:@"共%d件商品，",allSelectedCount];
    self.lblGoodsPrice.text = [[NSString alloc] initWithFormat:@"￥%.2f",allPrice];
    
}

- (IBAction)submitClick:(id)sender {
    //选择的商品信息
    NSMutableArray *tempGoodsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dicTemp in dataSource) {
        //设置商品详情
        GoodsModel *tempGoodsModel = (GoodsModel *)[dicTemp objectForKey:@"goodsModel"];
        //设置购买数量
        NSString *buyCount = [dicTemp objectForKey:@"selectedCount"];
        //未选择该商品
        if ([[dicTemp objectForKey:@"isSelected"] isEqualToString:@"0"]) {
            break;
        }
        //订单请求字典
        NSMutableDictionary *tempGoodsDic = [[NSMutableDictionary alloc] init];
        [tempGoodsDic setObject:tempGoodsModel.goodsId forKey:KJsonElement_GId];
        [tempGoodsDic setObject:buyCount forKey:KJsonElement_Num];
        //添加到数组
        [tempGoodsArray addObject:tempGoodsDic];
    }
    //判断是否选择有商品
    if (tempGoodsArray.count <= 0) {
        [self showTipsView:@"请选择商品后下单!"];
        return;
    }
    //下单
    [[NetInterfaceManager sharedInstance] customerProductBuy:self.customerId goods:tempGoodsArray];
    [self startWait];
}

//设置无库存提示
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
//跳转到添加商品
-(void)meBuyGoodsViewClick{
    //跳转控制器
    //采购管理
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Procurement" bundle:nil];
    UINavigationController *procurementController = [storyboard instantiateViewControllerWithIdentifier:@"procurementGoodsListId"];
    [self.navigationController pushViewController:procurementController animated:YES];
}
#pragma mark -- GoodsListTableViewCellDelegate
//勾选图片点击
- (void) selectedImageClick:(int)cellIndex goodsListTableViewCell:(GoodsListTableViewCell*)cell{
    NSMutableDictionary *dicTempOneDataSource = dataSource[cellIndex];
    //商品信息
    GoodsModel *tempGoodsModel = [dicTempOneDataSource objectForKey:@"goodsModel" ];
    //如果是没有选中变为选中，需要判读库存是否够
    if (!cell.isSelected) {
        //库存没有
        if (tempGoodsModel.storageNum <=0) {
            [self showTipsView:@"库存不足！"];
            return ;
        }
    }
    //库存够了，显示
    cell.isSelected = !cell.isSelected;
    //设置并更改数据源
    if (cell.isSelected) {
        [dicTempOneDataSource setObject:@"1" forKey:@"isSelected"];
        //还原选中数据
        [dicTempOneDataSource setObject:@"1" forKey:@"selectedCount"];
    }
    else{
        [dicTempOneDataSource setObject:@"0" forKey:@"isSelected"];
    }
    //重新加载tableView
    [self.mainTableView reloadData];
    //重新刷新界面
    [self interfaceToReload];
}
//加号点击
- (void) addImageClick:(int)cellIndex goodsListTableViewCell:(GoodsListTableViewCell*)cell{
    //数据源
    NSMutableDictionary *dicTempOneDataSource = dataSource[cellIndex];
    //数据源分解信息
    GoodsModel *tempGoodsModel = [dicTempOneDataSource objectForKey:@"goodsModel" ];
    NSString *isSelectedState = [dicTempOneDataSource objectForKey:@"isSelected"];
    NSString *selectedCountState = [dicTempOneDataSource objectForKey:@"selectedCount"];
    if (!cell.isSelected && !isSelectedState) {
        //没有出现编辑状态直接返回
        return;
    }
    //已经选完
    if (tempGoodsModel.storageNum - [selectedCountState integerValue] <=0) {
        [self showTipsView:@"库存不足！"];
        return ;
    }
    int nowSelectedCount = [selectedCountState integerValue];
    selectedCountState = [NSString stringWithFormat:@"%d",nowSelectedCount + 1];
    [dicTempOneDataSource setObject:selectedCountState forKey:@"selectedCount"];
    //重新加载tableView
    [self.mainTableView reloadData];
    //重新刷新界面
    [self interfaceToReload];
}
//减号点击
- (void) deleteImageClick:(int)cellIndex goodsListTableViewCell:(GoodsListTableViewCell*)cell{
    //数据源
    NSMutableDictionary *dicTempOneDataSource = dataSource[cellIndex];
    //数据源分解信息
    //    GoodsModel *tempGoodsModel = [dicTempOneDataSource objectForKey:@"goodsModel" ];
    NSString *isSelectedState = [dicTempOneDataSource objectForKey:@"isSelected"];
    NSString *selectedCountState = [dicTempOneDataSource objectForKey:@"selectedCount"];
    if (!cell.isSelected && !isSelectedState) {
        //没有出现编辑状态直接返回
        return;
    }
    //剩下最后一个
    if ([selectedCountState integerValue] == 1) {
        //[self showTipsView:@"库存不足！"];
        return ;
    }
    int nowSelectedCount = [selectedCountState integerValue];
    selectedCountState = [NSString stringWithFormat:@"%d",nowSelectedCount - 1];
    [dicTempOneDataSource setObject:selectedCountState forKey:@"selectedCount"];
    //重新加载tableView
    [self.mainTableView reloadData];
    //重新刷新界面
    [self interfaceToReload];
}
#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectedImageClick:indexPath.row goodsListTableViewCell:(GoodsListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]];
}
#pragma mark --- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"goodListCellId";
    GoodsListTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!Cell) {
        Cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsListTableViewCell" owner:self options:0] firstObject];
    }
    //协议
    Cell.delegate = self;
    //从数据源拉去数据
    NSDictionary *cellGoodsDic = (NSDictionary *)[dataSource objectAtIndex:indexPath.row];
    GoodsModel *tempGoods = (GoodsModel *)[cellGoodsDic objectForKey:@"goodsModel"];
    
    //数据加载
    Cell.isSelected = [((NSString*)[cellGoodsDic objectForKey:@"isSelected"]) isEqualToString:@"1"];
    Cell.numView.hidden = [((NSString*)[cellGoodsDic objectForKey:@"isSelected"]) isEqualToString:@"0"];
    Cell.selectedCount.text = (NSString *)[cellGoodsDic objectForKey:@"selectedCount"];
    [Cell.goodsImage setImageWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",KImageDonwloadAddr,tempGoods.goodsImage]]];
    Cell.goodsDesc.text = tempGoods.goodsName;
    Cell.goodsPrice.text = [[NSString alloc] initWithFormat:@"￥%@",tempGoods.goodsPrice];
    
    //设置cell为第几行
    Cell.cellIndex = indexPath.row;
    return Cell;
}
#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_GetCustomerProductList:
            if (result.resultCode == 0) {
                dataSource = nil;
                //刷新的时候清空数据
                dataSource = [[NSMutableArray alloc] init];
                for (NSDictionary *dicTemp in result.data) {
                    //一项数据源字典 数据源包含三段是否选中，数据对象，设置数量
                    NSMutableDictionary *dicOneDataSource = [[NSMutableDictionary alloc] init];
                    
                    //设置商品详情
                    GoodsModel *tempGoodsModel = [[GoodsModel alloc] initWithDictionary:dicTemp];
                    [dicOneDataSource setObject:tempGoodsModel forKey:@"goodsModel"];
                    
                    //设置是否选中
                    [dicOneDataSource setObject:@"0" forKey:@"isSelected"];
                    
                    //设置商品选中数量
                    [dicOneDataSource setObject:@"1" forKey:@"selectedCount"];
                    
                    //字典添加到数据源中
                    [dataSource addObject:dicOneDataSource];
                }
                //从新加载数据
                [self.mainTableView reloadData];
                //重新刷新界面
                [self interfaceToReload];
                
                //如果没有数据展示提示购买商品
                if (dataSource.count > 0) {
                    [self showPromptInventory:NO];
                }
                else{
                    [self showPromptInventory:YES];
                }
            }
            else {
                
                [self showTipsView:@"数据加载失败，请重试！"];
            }
            break;
        case KReqestType_CustomerProductBuy:
            if (result.resultCode == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self showTipsView:@"下单失败！"];
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










