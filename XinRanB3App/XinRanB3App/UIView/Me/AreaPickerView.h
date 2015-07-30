//
//  AreaPickerView.h
//  XinRanApp
//
//  Created by tianbo on 14-12-23.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XRUIView/BaseUIView.h>
#import "Areas.h"

@class AreaPickerView;
@protocol AreaPickerViewDelegate <NSObject>

- (void)pickerViewDidChange:(AreaPickerView *)picker;
- (void)pickerViewCancel;
- (void)pickerViewOK:(Areas*)province city:(Areas*)city district:(Areas*)district;

@end

@interface AreaPickerView : BaseUIView

@property(nonatomic, assign) id delegate;

- (AreaPickerView*)initWithDelegate:(id)delegate areas:(NSArray*)areas;
- (AreaPickerView*)initWithDelegate:(id)delegate arProvince:(NSArray*)arProvince arCity:(NSArray*)arCity arDistrict:(NSArray*)arDistrict;
- (void)showInView:(UIView *)view;
- (void)cancelPicker:(UIView *)view;

-(void)setAreas:(Areas*)province city:(Areas*)city district:(Areas*)district;
@end
