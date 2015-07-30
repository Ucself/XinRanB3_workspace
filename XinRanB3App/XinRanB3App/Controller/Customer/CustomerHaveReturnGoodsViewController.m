//
//  CustomerHaveReturnGoodsViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerHaveReturnGoodsViewController.h"
#import "HaveReturnGoodsModel.h"

@interface CustomerHaveReturnGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSMutableArray *dataSource;

}

@end

@implementation CustomerHaveReturnGoodsViewController

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

-(void) initInterface {
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    //设置背景色
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    //获取数据类型
    [[NetInterfaceManager sharedInstance] getCustomerBackorderlist:self.goodsId saleDetailId:self.saleDetailId customerId:self.customerId];
    [self startWait];
}

#pragma mark --- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"haveReturnGoodsCellIdent"];
        HaveReturnGoodsModel *tempHaveReturnGoodsModel = (HaveReturnGoodsModel*)dataSource[indexPath.row];
        
        UILabel *lblTime = (UILabel *)[cell viewWithTag:101];
        UILabel *lblCount = (UILabel *)[cell viewWithTag:102];
        UILabel *lblReason = (UILabel *)[cell viewWithTag:103];
        UILabel *lblNote = (UILabel *)[cell viewWithTag:104];
        
        if (tempHaveReturnGoodsModel.backSaleDate && ![tempHaveReturnGoodsModel.backSaleDate isKindOfClass:[NSNull class]]) {
            lblTime.text = tempHaveReturnGoodsModel.backSaleDate;
        }
        else{
            lblTime.text = @"";
        }
        if (tempHaveReturnGoodsModel.quantity) {
            lblCount.text = [[NSString alloc] initWithFormat:@"%d",tempHaveReturnGoodsModel.quantity];
        }
        else{
            lblCount.text = @"";
        }
        if (tempHaveReturnGoodsModel.reason && ![tempHaveReturnGoodsModel.reason isKindOfClass:[NSNull class]]) {
            lblReason.text = tempHaveReturnGoodsModel.reason;
        }
        else{
            lblReason.text = @"";
        }
        if (tempHaveReturnGoodsModel.remark && ![tempHaveReturnGoodsModel.remark isKindOfClass:[NSNull class]]) {
            lblNote.text = tempHaveReturnGoodsModel.remark;
        }
        else{
            lblNote.text = @"";
        }
            
        
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}
#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_CustomerBackorderlist:
        {
            if (result.resultCode == 0) {
                dataSource = nil;
                dataSource = [[NSMutableArray alloc] init];
                for (NSDictionary *tempDic in result.data) {
                    HaveReturnGoodsModel *tempHaveReturnGoodsModel = [[HaveReturnGoodsModel alloc] initWithDictionary:tempDic];
                    [dataSource addObject:tempHaveReturnGoodsModel];
                }
                
                [self.mainTableView reloadData];
            }
            else{
                [self showTipsView:@"退货失败！"];
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















