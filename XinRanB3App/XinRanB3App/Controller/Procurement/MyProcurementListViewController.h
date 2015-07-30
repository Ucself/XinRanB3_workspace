//
//  MyProcurementListViewController.h
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"
#import <XRUIView/RefreshTableView.h>

@interface MyProcurementListViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet RefreshTableView *mainTableView;

@end
