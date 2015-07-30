//
//  InventoryListViewController.h
//  XinRanB3App
//
//  Created by libj on 15/6/2.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"
#import <XRUIView/RefreshTableView.h>

@interface InventoryListViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet RefreshTableView *mainTableView;

@end
