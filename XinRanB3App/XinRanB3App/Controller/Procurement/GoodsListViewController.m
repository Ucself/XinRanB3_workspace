//
//  GoodsListViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsListTableViewCell.h"
#import <XRNetInterface/NetInterfaceManager.h>
#import <XRNetInterface/UIImageView+AFNetworking.h>
#import "GoodsModel.h"
#import "OrderDetailViewController.h"

@interface GoodsListViewController ()<UITableViewDelegate,UITableViewDataSource,GoodsListTableViewCellDelegate>{
    //数据源
    NSMutableArray *dataSource;
}

@end

@implementation GoodsListViewController

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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BaseUIViewController* controller = segue.destinationViewController;
    if ([controller isKindOfClass:[OrderDetailViewController class]]) {
        //传递id和did到详情页
        NSMutableArray *tempDataSource = (NSMutableArray*)sender;
        OrderDetailViewController *c = (OrderDetailViewController*)controller;
        c.dataSource = tempDataSource;
    }
}
#pragma mark ---

-(void) initInterface{
    //初始化变了对象
    dataSource = [[NSMutableArray alloc] init];
    
    //设置背景颜色
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    //请求服务器数据 获取商品列表
    [[NetInterfaceManager sharedInstance] getGoodslist];
    
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
    self.allSelectedCount.text = [[NSString alloc] initWithFormat:@"共%d件商品，",allSelectedCount];
    self.allPrice.text = [[NSString alloc] initWithFormat:@"￥%.2f",allPrice];
    
}

- (IBAction)generateOrderClick:(id)sender {
    
    NSMutableArray *buyDataSource = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicTempOneDataSource in dataSource) {
        GoodsModel *tempGoodsModel = [dicTempOneDataSource objectForKey:@"goodsModel" ];
        NSString *isSelectedState = [dicTempOneDataSource objectForKey:@"isSelected"];
        NSString *selectedCountState = [dicTempOneDataSource objectForKey:@"selectedCount"];
        //如果是选中的
        if ([isSelectedState isEqualToString:@"1"]) {
            NSMutableDictionary *dicOneDataSource = [[NSMutableDictionary alloc] init];
            //设置商品详情
            [dicOneDataSource setObject:tempGoodsModel forKey:@"goodsModel"];
            //设置是否选中
            [dicOneDataSource setObject:isSelectedState forKey:@"isSelected"];
            //设置商品选中数量
            [dicOneDataSource setObject:selectedCountState forKey:@"selectedCount"];
            //添加到传输的数据源上
            [buyDataSource addObject:dicOneDataSource];
        }
    }
    //未选择购买商品
    if (buyDataSource.count <= 0) {
        [self showTipsView:@"未选择商品！"];
        return;
    }
    
    [self performSegueWithIdentifier:@"ToOrder" sender:buyDataSource];
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
        if (tempGoodsModel.goodsRemaind <=0) {
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
    if (tempGoodsModel.goodsRemaind - [selectedCountState integerValue] <=0) {
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

    return 88.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //执行
    [self selectedImageClick:indexPath.row goodsListTableViewCell:(GoodsListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark -- UITableViewDataSource

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
    //uiImage添加边框
    Cell.goodsImage.layer.borderWidth = 1.f;
    Cell.goodsImage.layer.borderColor = [UIColorFromRGB(0XEAEBEC) CGColor];
    
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
        case KReqestType_GetGoodsList:
            if (result.resultCode == 0) {
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













