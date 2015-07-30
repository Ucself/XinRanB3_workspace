//
//  CustomerListViewController.m
//  XinRanB3App
//
//  Created by libj on 15/6/1.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "CustomerListViewController.h"
#import "CustomerListTableViewCell.h"
#import "AddCommonView.h"

@interface CustomerListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    AddCommonView *addCommonView;
    NSMutableArray *dataSource;

}

@end

@implementation CustomerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    if (touch.tapCount >=1) {
        if (addCommonView) {
            addCommonView.isShow = NO;
        }
    }
}
#pragma mark ---

-(void) initInterface{
    
    dataSource = [[NSMutableArray alloc] init];
    
    [dataSource addObject:@""];
    [dataSource addObject:@""];
    [dataSource addObject:@""];
    [dataSource addObject:@""];
    [dataSource addObject:@""];
    
    //设置协议
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setBackgroundColor:UIColorFromRGB(0xF5F5F5)];
    //添加小图标
    [self setupNavBar];
}
-(void)setupNavBar
{
    //右边的btn
    UIButton *btnR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnR setFrame:CGRectMake(0, 0, 40, 40)];
    [btnR setImage:[UIImage imageNamed:@"icon_itemBarAdd"] forState:UIControlStateNormal];
    [btnR addTarget:self action:@selector(btnRClick) forControlEvents:UIControlEventTouchUpInside];
    [btnR setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barRItem = [[UIBarButtonItem alloc]initWithCustomView:btnR];
    self.navigationItem.rightBarButtonItem = barRItem;
    //左边的btn
    UIButton *btnL = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnL setFrame:CGRectMake(0, 0, 40, 40)];
    [btnL setImage:[UIImage imageNamed:@"icon_itemBarSeach"] forState:UIControlStateNormal];
    [btnL addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [btnL setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *barLItem = [[UIBarButtonItem alloc]initWithCustomView:btnL];
    self.navigationItem.leftBarButtonItem = barLItem;
}
-(void)btnRClick {
    if (!addCommonView) {
        addCommonView = [[AddCommonView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 85,64, 80, 70)];
        //添加弹出视图
        [self.view addSubview:addCommonView];
        //设置协议
        addCommonView.delegate = self;
    }
    addCommonView.isShow = !addCommonView.isShow;
}

#pragma mark ---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    CustomerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerListTableViewCell" owner:self options:0] firstObject];
    }
    
    
    return cell;
}
#pragma mark ---UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

#pragma mark --- AddCommonViewDelegate
//点击添加客户协议
-(void)addCustomerViewClick{
    
}
//点击添加商品协议
-(void)meBuyGoodsViewClick{

}
@end








