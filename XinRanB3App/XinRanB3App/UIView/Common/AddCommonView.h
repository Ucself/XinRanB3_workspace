//
//  AddCommonView.h
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XRUIView/BaseUIView.h>


@protocol AddCommonViewDelegate <NSObject>

//点击添加客户协议
-(void)addCustomerViewClick;
//点击添加商品协议
-(void)meBuyGoodsViewClick;

@end

@interface AddCommonView : BaseUIView

@property (nonatomic,strong) UIView *containerView;


@property (weak, nonatomic) IBOutlet UIView *parentView;

@property (weak, nonatomic) IBOutlet UIView *addCustomerView;

@property (weak, nonatomic) IBOutlet UIView *meBuyGoodsView;

@property (nonatomic, assign) id delegate;

@property (nonatomic,assign) BOOL isShow;


-(instancetype)initWithPoint:(CGPoint)point size:(CGSize)size;
@end
