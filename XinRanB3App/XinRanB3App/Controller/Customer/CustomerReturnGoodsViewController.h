//
//  CustomerReturnGoodsViewController.h
//  XinRanB3App
//
//  Created by libj on 15/6/5.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "BaseUIViewController.h"

@interface CustomerReturnGoodsViewController : BaseUIViewController

@property(nonatomic,strong) NSString *goodsId;
@property(nonatomic,strong) NSString *customerId;
@property(nonatomic,strong) NSString *saleorderId;
@property(nonatomic,strong) NSString *saleDetailId;


@property (weak, nonatomic) IBOutlet UITextField *returnCount;
@property (weak, nonatomic) IBOutlet UITextField *returnReason;
@property (weak, nonatomic) IBOutlet UITextView *returnRemark;

@property (weak, nonatomic) IBOutlet UILabel *lblTipRemark;


@end
