//
//  MyProcurementDetailViewController.h
//  XinRanB3App
//
//  Created by libj on 15/5/31.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface MyProcurementDetailViewController : BaseUIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,strong) NSString *orderId;


@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (weak, nonatomic) IBOutlet UIImageView *topLine;

@end
