//
//  ReturnGoodsPickerView.m
//  XinRanB3App
//
//  Created by libj on 15/6/10.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "ReturnGoodsPickerView.h"

@interface ReturnGoodsPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{

    NSString *selectedName;
}


@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ReturnGoodsPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithName:(NSString*)name{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ReturnGoodsPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }
    //初始化数据字典
    if (!self.dataSource) {
        self.dataSource = [[NSMutableArray alloc] init];
        [self.dataSource addObject:@"家属不支持"];
        [self.dataSource addObject:@"有不良反应"];
        [self.dataSource addObject:@"过敏"];
        [self.dataSource addObject:@"无效果"];
        [self.dataSource addObject:@"质疑产品质量问题"];
        [self.dataSource addObject:@"购买量太多"];
        [self.dataSource addObject:@"经济状况不好"];
        [self.dataSource addObject:@"不想要了"];
        [self.dataSource addObject:@"其他"];
    }
    
    //默认设置选择家属不支持
    selectedName = [name isEqualToString:@""] ? @"家属不支持" : name;
    return self;
}


- (void)showInView:(UIView *)view{
    //正在显示中
    self.isShow = YES;
    
    self.tag = 111;
    if ([view viewWithTag:111]) {
        return;
    }
    
    [view addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.equalTo(view);
        make.top.equalTo(view.bottom);
        make.height.equalTo(@220);
    }];
    [view layoutIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(view);
            make.top.equalTo(view.bottom).offset(-220);
            make.height.equalTo(@220);
        }];
        
        [view layoutIfNeeded];
    }];

}
- (void)cancelPicker:(UIView *)view{
    //未显示中
    self.isShow = NO;
    
    //包含视图再设置取消
    if (![view viewWithTag:111]) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        
        [self remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(view);
            make.top.equalTo(view.bottom);
            make.height.equalTo(@220);
        }];
        
        [view layoutIfNeeded];
    }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
}
- (IBAction)btnOkClick:(id)sender {
    //取消弹出选择器
    
    if ([self.delegate respondsToSelector:@selector(pickerViewOK:)]) {
        [self.delegate pickerViewOK:selectedName];
    }
}

- (IBAction)btnCancelClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(pickerViewCancel)]) {
        [self.delegate pickerViewCancel];
    }
}


#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  self.dataSource.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = view ? (UILabel *) view : [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:17]];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.dataSource[row];
    
    //设置选中的项目
    if ([label.text isEqualToString:selectedName]) {
        [self.pickerView selectRow:row inComponent:component animated:YES];
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedName = self.dataSource[row];
}

@end
