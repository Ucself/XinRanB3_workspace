//
//  CustomerHaveReturnGoodsViewController.h
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface CustomerHaveReturnGoodsViewController : BaseUIViewController


@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


@property(nonatomic,strong) NSString *goodsId;
@property(nonatomic,strong) NSString *customerId;
@property(nonatomic,strong) NSString *saleDetailId;

@end
