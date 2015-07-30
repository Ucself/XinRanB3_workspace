//
//  NetPrompt.m
//  XinRanApp
//
//  Created by tianbo on 15-3-12.
//  Copyright (c) 2015年 deshan.com. All rights reserved.
//

#import "NetPrompt.h"
#import "UIImage+bundle.h"

#define topViewTag 9991
#define middleViewTag 9992

@interface NetPrompt (){

    UIView *parentUIView;

}

@end

@implementation NetPrompt

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithView:(UIView *)uiView{

    self = [super init];
    if (self) {
        //默认设置都显示
        _isShowTopUIView = YES;
        _isShowMiddleUIView = YES;
        parentUIView = uiView;
        self.top = 64;
        [self initInterface];
    }
    return self;
}
- (instancetype)initWithView:(UIView *)uiView
               showTopUIView:(BOOL)showTopUIView
            showMiddleUIView:(BOOL)showMiddleUIView{
    
    self = [super init];
    if (self) {
        //根据外围数据是否显示
        _isShowTopUIView = showTopUIView;
        _isShowMiddleUIView = showMiddleUIView;
        parentUIView = uiView;
        self.top = 64;
        [self initInterface];
    }
    return self;
}

//添加界面需要的视图
-(void)initInterface{
    //添加视图
//    [parentUIView addSubview:self];
    //设置本视图的布局
//    [self makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(parentUIView);
//    }];
    //添加上部的布局
    [self layoutTopUIView];
    //添加中部视图布局
    [self layoutMiddlUIView];
}
//布局上部提示是否显示
-(void)layoutTopUIView{
    
    if (!_isShowTopUIView) {
        return;
    }
    
    if (!_topUIView) {
        _topUIView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_topUIView setTag:topViewTag];
    }
    //设置不覆盖下层控件交互
    [_topUIView setUserInteractionEnabled:NO];
    //没有，再添加顶部视图
    if (![parentUIView viewWithTag:topViewTag]) {
        [parentUIView addSubview:_topUIView];
        //布局子视图
        [self layoutTopChildUIView];
    };
    [parentUIView bringSubviewToFront:_topUIView];
    

}
//布局顶视图的子视图
-(void)layoutTopChildUIView{
    //布局顶部控件
    [_topUIView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentUIView.top).offset(self.top - 40);
        make.left.equalTo(parentUIView.left);
        make.right.equalTo(parentUIView.right);
        make.height.equalTo(40);
    }];
    //设置背景颜色
    [_topUIView setBackgroundColor:UIColorFromRGB(0xFBE8E8)];
//    [_topUIView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    
    //top无信号提示文字
    UILabel *topText = [[UILabel alloc] init];
    [_topUIView addSubview:topText];
    [topText makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topUIView.centerX).offset(8);
        make.height.equalTo(14);
        make.width.equalTo(260);
        make.centerY.equalTo(_topUIView.centerY);
    }];
    [topText setText:@"网络连接不可用，请检查你的网络设置。"];
    [topText setTextColor:[UIColor darkGrayColor]];
    [topText setFont:[UIFont systemFontOfSize:14]];
    [topText setTextAlignment:NSTextAlignmentCenter];
    //top无网络信号图标
    UIImageView *topSignal = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromBundle:@"netprompt_top_signal"]];
    [_topUIView addSubview:topSignal];
    [topSignal makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topText.left).offset(0);
        make.height.equalTo(16);
        make.width.equalTo(16);
        make.centerY.equalTo(_topUIView.centerY);
    }];
    
}

//布局中部提示是否显示
-(void)layoutMiddlUIView{
    
    if (!_isShowMiddleUIView) {
        return;
    }
    
    if(!_middleUIView){
        _middleUIView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_middleUIView setTag:middleViewTag];
    }
    //设置覆盖下层控件交互
    [_middleUIView setUserInteractionEnabled:YES];
    //没有，再添加顶部视图
    if (![parentUIView viewWithTag:middleViewTag]) {
        [parentUIView addSubview:_middleUIView];
        //布局子视图
        [self layoutMiddleChildUIView];
    };
    //设置头部在顶部
    if ([parentUIView viewWithTag:topViewTag]) {
        [parentUIView bringSubviewToFront:_topUIView];
    };
    
    
}
//布局顶视图的子视图
-(void)layoutMiddleChildUIView{
    [_middleUIView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentUIView.top).offset(self.top);
        make.left.equalTo(parentUIView.left);
        make.right.equalTo(parentUIView.right);
        make.bottom.equalTo(parentUIView.bottom);
    }];
    [_middleUIView setBackgroundColor:[UIColor whiteColor]];
    //middle设置cup
    UIImageView *middleCup = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromBundle:@"netprompt_middle_cup"]];
    [_middleUIView addSubview:middleCup];
    [middleCup makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(90);
        make.width.equalTo(76);
        make.height.equalTo(70);
        make.centerX.equalTo(_middleUIView.centerX);
    }];
    //middle设置第一行字
    UILabel *middleFirstText = [[UILabel alloc] init];
    [_middleUIView addSubview:middleFirstText];
    [middleFirstText makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleCup.bottom);
        make.centerX.equalTo(_middleUIView.centerX);
        make.width.equalTo(_middleUIView.width);
        make.height.equalTo(20);
    }];
    [middleFirstText setTextAlignment:NSTextAlignmentCenter];
    [middleFirstText setText:@""];
    [middleFirstText setFont:[UIFont systemFontOfSize:14]];
    [middleFirstText setTextColor:UIColorFromRGB(0x4F4F4F)];
    //middle设置第二行字
    UILabel *middleSecondText = [[UILabel alloc] init];
    [_middleUIView addSubview:middleSecondText];
    [middleSecondText makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleFirstText.bottom);
        make.centerX.equalTo(_middleUIView.centerX);
        make.width.equalTo(_middleUIView.width);
        make.height.equalTo(30);
    }];
    [middleSecondText setTextAlignment:NSTextAlignmentCenter];
    [middleSecondText setText:@"亲，请检查你的手机是否连网～"];
    [middleSecondText setFont:[UIFont systemFontOfSize:14]];
    [middleSecondText setTextColor:[UIColor lightGrayColor]];
    //重新加载按钮
    UILabel *middleReload = [[UILabel alloc] init];
    [_middleUIView addSubview:middleReload];
    [middleReload makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleSecondText.bottom).offset(15);
        make.centerX.equalTo(_middleUIView.centerX);
        make.width.equalTo(120);
        make.height.equalTo(40);
    }];
    [middleReload setTextAlignment:NSTextAlignmentCenter];
    [middleReload setText:@"重新加载"];
    [middleReload setTextColor:[UIColor lightGrayColor]];
    [middleReload setFont:[UIFont systemFontOfSize:14]];
    
    middleReload.layer.borderWidth = 1;
    middleReload.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    middleReload.layer.cornerRadius = 4;
    [middleReload setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(middleReloadClick:)];
    [middleReload addGestureRecognizer:tapGesture];
}

//点击了重新加载功能
- (void) middleReloadClick:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(requestNetReloadClick)]) {
        [self.delegate requestNetReloadClick];
    }
    
}

#pragma mark ----

-(void)setIsShowTopUIView:(BOOL)isShowTopUIView{
    //设置是否显示顶部视图
    _isShowTopUIView = isShowTopUIView;
    
    if (_isShowTopUIView) {
        [self layoutTopUIView];
    }
    else{
        if ([parentUIView viewWithTag:topViewTag]) {
            [_topUIView removeFromSuperview];
        };
    }
    
}

-(void)setIsShowMiddleUIView:(BOOL)isShowMiddleUIView{
    //设置是否显示中部视图
    _isShowMiddleUIView = isShowMiddleUIView;
    
    if (_isShowMiddleUIView) {
        [self layoutMiddlUIView];
    }
    else{
        if ([parentUIView viewWithTag:middleViewTag]) {
            [_middleUIView removeFromSuperview];
        };
    }
}

@end














