//
//  MyProcurementBottomTableViewCell.m
//  XinRanB3App
//
//  Created by libj on 15/5/31.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "MyProcurementBottomTableViewCell.h"

@interface MyProcurementBottomTableViewCell()
//左边按钮
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
//右边按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
//线条
@property (weak, nonatomic) IBOutlet UIImageView *topLine;
//整个视图
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation MyProcurementBottomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark ---

- (IBAction)rightClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(rightButtonClick:myProcurementBottomTableViewCell:)]) {
        [self.delegate rightButtonClick:self.index myProcurementBottomTableViewCell:self];
    }
}

- (IBAction)left:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(leftButtonClick:myProcurementBottomTableViewCell:)]) {
        [self.delegate leftButtonClick:self.index myProcurementBottomTableViewCell:self];
    }
}



//设置包含付款和取消订单信息
-(void) setCanPaymentAndCancelOrder{
    
    //设置为显示
    [self.leftButton setHidden:NO];
    [self.rightButton setHidden:NO];
    [self.topLine setHidden:NO];
    [self.buttonView setHidden:NO];
    
    //设置为灰色
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"icon_btnBkQuXiao"] forState:UIControlStateNormal];
    [self.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"icon_btnBkBuy"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"付款" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

}
//设置包含付款和取消订单信息
-(void) setNoOperation{
    
    //设置为显示
    [self.leftButton setHidden:YES];
    [self.rightButton setHidden:YES];
    [self.topLine setHidden:YES];
    [self.buttonView setHidden:YES];
    
}

//设置包含确认收货
-(void) setCanGetGoods{
    //设置为显示
    [self.leftButton setHidden:YES];
    [self.rightButton setHidden:NO];
    [self.topLine setHidden:NO];
    [self.buttonView setHidden:NO];

    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"icon_btnBkBuy"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

@end





