//
//  AddCommonView.m
//  XinRanB3App
//
//  Created by libj on 15/5/28.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "AddCommonView.h"



@implementation AddCommonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithPoint:(CGPoint)point size:(CGSize)size{
    //初始化方式
    self = [[[NSBundle mainBundle] loadNibNamed:@"AddCommonView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //设置布局
        [self setFrame:[[UIApplication sharedApplication] keyWindow].bounds];
        //设置位置
        [self.parentView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(point.x);
            make.top.equalTo(self.top).offset(point.y);
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];
        //初始设置没有显示
        self.isShow = NO;
        //Window容器
        self.containerView = [[UIApplication sharedApplication] keyWindow];
        //添加点击手势
        UITapGestureRecognizer *clickAddCustomer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customerClick:)];
        [self.addCustomerView addGestureRecognizer:clickAddCustomer];
        //添加点击收拾
        UITapGestureRecognizer *clickBugGoods = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsClick:)];
        [self.meBuyGoodsView addGestureRecognizer:clickBugGoods];
        //点击空白处隐藏
        UITapGestureRecognizer *clickSelf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClick:)];
        [self addGestureRecognizer:clickSelf];
    }
    return self;
}

-(void)awakeFromNib{


}

#pragma mark -- 

-(void) customerClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(addCustomerViewClick)]) {
        [self.delegate addCustomerViewClick];
    }
}

-(void) goodsClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(meBuyGoodsViewClick)]) {
        [self.delegate meBuyGoodsViewClick];
    }
}

-(void)selfClick:(id)sender{
    self.isShow = NO;
}

- (void)setIsShow:(BOOL)isShow{
    //设置显示
    _isShow = isShow;
    if(_isShow){
        [self.containerView addSubview:self];
        [self.containerView bringSubviewToFront:self];
    }
    else{
        //移除本视图
        for (UIView *temp in [self.containerView subviews]) {
            if ([temp isKindOfClass:[self class]]) {
                [temp removeFromSuperview];
            }
        }
    }
}



@end















