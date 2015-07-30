//
//  CustomerPlaceOrderViewController.h
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface CustomerPlaceOrderViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *lblGoodsCount;

@property (weak, nonatomic) IBOutlet UILabel *lblGoodsPrice;

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (nonatomic ,strong) NSString *customerId;

@end
