//
//  MyProcurementBottomTableViewCell.h
//  XinRanB3App
//
//  Created by libj on 15/5/31.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyProcurementBottomTableViewCell;

@protocol MyProcurementBottomTableViewCellDelegate <NSObject>

//右边的按钮点击
- (void) rightButtonClick:(NSInteger)cellIndex myProcurementBottomTableViewCell:(MyProcurementBottomTableViewCell*)cell;
//左边的点击按钮
- (void) leftButtonClick:(NSInteger)cellIndex myProcurementBottomTableViewCell:(MyProcurementBottomTableViewCell*)cell;

@end


@interface MyProcurementBottomTableViewCell : UITableViewCell

@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) id delegate;

//设置包含付款和取消订单信息
-(void) setCanPaymentAndCancelOrder;
//设置包含付款和取消订单信息
-(void) setNoOperation;
//设置包含确认收货
-(void) setCanGetGoods;

@end
