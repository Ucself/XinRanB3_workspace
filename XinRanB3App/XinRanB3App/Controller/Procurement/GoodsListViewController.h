//
//  GoodsListViewController.h
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface GoodsListViewController : BaseUIViewController


@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *lblAllCount;

@property (weak, nonatomic) IBOutlet UILabel *lblAllPrice;

@property (weak, nonatomic) IBOutlet UIButton *btnBuy;


@property (weak, nonatomic) IBOutlet UILabel *allSelectedCount;

@property (weak, nonatomic) IBOutlet UILabel *allPrice;

@end
