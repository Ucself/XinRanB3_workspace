//
//  ReturnGoodsPickerView.h
//  XinRanB3App
//
//  Created by libj on 15/6/10.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <XRUIView/XRUIView.h>

@class ReturnGoodsPickerView;

@protocol ReturnGoodsPickerViewDelegate <NSObject>

- (void)pickerViewCancel;
- (void)pickerViewOK:(NSString *)selectedName;

@end

@interface ReturnGoodsPickerView : BaseUIView

@property(nonatomic,assign) id delegate;
@property(nonatomic,assign) BOOL isShow;

- (void)showInView:(UIView *)view;
- (void)cancelPicker:(UIView *)view;


-(instancetype)initWithName:(NSString*)name;
@end
