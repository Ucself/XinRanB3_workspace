//
//  GuideViewController.m
//  XinRanApp
//
//  Created by tianbo on 14-12-4.
//  Copyright (c) 2014年 deshan.com All rights reserved.
//

#import "GuideViewController.h"


@interface GuideViewController ()<UITableViewDelegate>{
    //guide1
    UIImageView *guide1Image;
    UIImageView *guide1Text;
    //guide2
    UIImageView *guide2Image;
    UIImageView *guide2Text;
    //guide3
    UIImageView *guide3Image;
    UIImageView *guide3Text;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView1;
@property (weak, nonatomic) IBOutlet UIView *uiView11;
@property (weak, nonatomic) IBOutlet UIView *uiView21;
@property (weak, nonatomic) IBOutlet UIView *uiView31;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl1;

@end

@implementation GuideViewController


- (void)awakeFromNib{
    
    //初始化界面
}

- (void)viewDidLoad {
    //不显示网络提示
    isShowNetPrompt = NO;
    [super viewDidLoad];
    //滚动试图协议
    self.mainScrollView1.delegate = self;
    // Do any additional setup after loading the view.
    [self initInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark --

//初始化界面
-(void) initInterface{
    //宽度
    float tempWidth = deviceWidth-50.f;
    //宽度
    float tempTextWidth = deviceWidth - 100.f;
    //顶部距离
    float topDistance = 50.f;
    //底部距离
    float bottomDistance = -90.f;
    //设置背景色
    [self.uiView11 setBackgroundColor:UIColorFromRGB(0x68d8b0)];
    [self.uiView21 setBackgroundColor:UIColorFromRGB(0xff5b57)];
    [self.uiView31 setBackgroundColor:UIColorFromRGB(0x668ee3)];
    //设置第一页图片信息
    if (!guide1Image) {
        guide1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide-1"]];
        [self.uiView11 addSubview:guide1Image];
        //设置布局
        [guide1Image makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempWidth);
            make.height.equalTo(tempWidth);
            make.centerX.equalTo(self.uiView11.centerX);
            make.top.equalTo(self.uiView11.top).offset(topDistance);
        }];
//        [guide1Image makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.uiView11);
//            make.left.equalTo(self.uiView11);
//            make.bottom.equalTo(self.uiView11);
//            make.right.equalTo(self.uiView11);
//        }];
    }
    if (!guide1Text) {
        guide1Text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1Text"]];
        [self.uiView11 addSubview:guide1Text];
        //设置布局
        [guide1Text makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempTextWidth);
            make.height.equalTo(tempTextWidth*(99.f/342.f));
            make.centerX.equalTo(self.uiView11.centerX);
            make.bottom.equalTo(bottomDistance);
        }];
    }
    //设置第二页图片信息
    if (!guide2Image) {
        guide2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide-2"]];
        [self.uiView21 addSubview:guide2Image];
        //设置布局
        [guide2Image makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempWidth);
            make.height.equalTo(tempWidth);
            make.centerX.equalTo(self.uiView21.centerX);
            make.top.equalTo(self.uiView21.top).offset(topDistance);
        }];
//        [guide2Image makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.uiView21);
//            make.left.equalTo(self.uiView21);
//            make.bottom.equalTo(self.uiView21);
//            make.right.equalTo(self.uiView21);
//        }];
    }
    if (!guide2Text) {
        guide2Text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide2Text"]];
        [self.uiView21 addSubview:guide2Text];
        //设置布局
        [guide2Text makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempTextWidth);
            make.height.equalTo(tempTextWidth*(99.f/342.f));
            make.centerX.equalTo(self.uiView21.centerX);
            make.bottom.equalTo(bottomDistance);
        }];
    }
    //设置第三页图片信息
    if (!guide3Image) {
        guide3Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide-3"]];
        [self.uiView31 addSubview:guide3Image];
        //设置布局
        [guide3Image makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempWidth);
            make.height.equalTo(tempWidth);
            make.centerX.equalTo(self.uiView31.centerX);
            make.top.equalTo(self.uiView31.top).offset(topDistance);
        }];
//        [guide3Image makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.uiView31);
//            make.left.equalTo(self.uiView31);
//            make.bottom.equalTo(self.uiView31);
//            make.right.equalTo(self.uiView31);
//        }];
        
    }
    if (!guide3Text) {
        guide3Text = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide3Text"]];
        [self.uiView31 addSubview:guide3Text];
//        [guide3Text setHidden:YES];
        //设置布局
        [guide3Text makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(tempTextWidth);
            make.height.equalTo(tempTextWidth*(99.f/342.f));
            make.centerX.equalTo(self.uiView31.centerX);
            make.bottom.equalTo(bottomDistance);
        }];
    }
    
    //将按钮值上
    [self.uiView31 bringSubviewToFront:self.btnExperience];
}

- (IBAction)btnToLoginClick:(id)sender {
    self.uiView11 = nil;
    self.uiView21 = nil;
    self.uiView31 = nil;
    [self performSegueWithIdentifier:@"ToLogin" sender:self];
}


#pragma mark --- UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((self.mainScrollView1.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl1.currentPage=page;
    
}

#pragma mark- http request handler
-(void)httpRequestFinished:(NSNotification *)notification
{
    DBG_MSG(@"enter");
}

-(void)httpRequestFailed:(NSNotification *)notification
{
    //return [super httpRequestFailed:notification];
}
@end
