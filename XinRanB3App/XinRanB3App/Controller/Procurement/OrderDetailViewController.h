//
//  OrderDetailViewController.h
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface OrderDetailViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

//传入的数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

//合计
@property (weak, nonatomic) IBOutlet UILabel *allPrice;


@end
