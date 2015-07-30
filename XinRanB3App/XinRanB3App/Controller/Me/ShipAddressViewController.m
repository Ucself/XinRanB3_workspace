//
//  ShipAddressViewController.m
//  XinRanB3App
//
//  Created by libj on 15/5/20.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "ShipAddressViewController.h"
#import "AddressTableViewCell.h"
#import "UserAddressModel.h"
#import "EditorAddressViewController.h"
#import "Areas.h"
#import <XRNetInterface/EnvPreferences.h>

@interface ShipAddressViewController () <UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *dataSource;
    
}

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;

@property (weak, nonatomic) IBOutlet UIButton *btnAddAddress;


@end

@implementation ShipAddressViewController

- (void)viewDidLoad {
    isShowRequestPrompt = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求数据
    [[NetInterfaceManager sharedInstance] getConfignees];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BaseUIViewController* controller = segue.destinationViewController;
    if ([controller isKindOfClass:[EditorAddressViewController class]]) {
        //传递id和did到详情页
        UserAddressModel *uam = (UserAddressModel*)sender;
        EditorAddressViewController *c = (EditorAddressViewController*)controller;
        c.userAddressModel = uam;
        c.controlType = 1;
    }
}
#pragma mark--

-(void) initInterface{
    if (!dataSource) {
        dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    //数据源协议
    self.addressTableView.dataSource = self;
    //操作协议
    self.addressTableView.delegate = self;
    //根据传入的类型进行设置显示
    if (self.controlType == 1) {
        //以管理收货地址方式进入
        self.navigationItem.title = @"管理收货地址";
        [self.btnAddAddress setTitle:@"新增收货地址" forState:UIControlStateNormal];
    }
    else if (self.controlType == 2){
        //以选择收货地址进入
        self.navigationItem.title = @"选择订单地址";
        [self.btnAddAddress setTitle:@"管理收货地址" forState:UIControlStateNormal];
    }
}

- (IBAction)addNewAdressClick:(id)sender {
    //选择订单地址过来
    if (self.controlType == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        ShipAddressViewController *c = [storyboard instantiateViewControllerWithIdentifier:@"ShipAddressViewControllerIdent"];
        c.controlType = 1;
        [self.navigationController pushViewController:c animated:YES];
        return;
    }
    
    [self performSegueWithIdentifier:@"ToEditorAddress" sender:nil];
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 80.f;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.controlType == 2) {
        //设置选中的缓存
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        [tempDic setValue:[dataSource objectAtIndex:indexPath.row] forKey:@"selectedShipAddress"];
        [[EnvPreferences sharedInstance] setSelectedShipAddress:tempDic];
        //重新刷一下数据
        [self.addressTableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self performSegueWithIdentifier:@"ToEditorAddress" sender:[dataSource objectAtIndex:indexPath.row]];
    }
    
    

}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId=@"addressCellId";
    AddressTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!Cell) {
        Cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:0] firstObject];
    }
    UserAddressModel *tempUserAddressModel = (UserAddressModel *)[dataSource objectAtIndex:indexPath.row];
    Cell.lblConsignee.text = tempUserAddressModel.name;
    Cell.lblPhoneNumber.text = tempUserAddressModel.phone;
    //是否为默认地址显示字体
    if (tempUserAddressModel.isDefault) {
        Cell.lblDefaultMark.text = @"【默认地址】";
    }
    else {
        Cell.lblDefaultMark.text = @"";
    }
    
    //根据ID写入地址
    if (tempUserAddressModel.area_id) {
        //数据库取数据
        NSString *stringDistrict=@"";NSString *stringCity=@"";NSString *stringProvince=@"";
        //取县区
        Areas *arDistrict = [Areas getArearWithId:tempUserAddressModel.area_id];
        if (arDistrict) {
            //定位使用当前的区域
            stringDistrict = arDistrict.name;
            //取市
            Areas *arCity = [Areas getArearWithId:arDistrict.pId];
            if (arCity) {
                stringCity = arCity.name;
                //取省
                Areas *arProvince = [Areas getArearWithId:arCity.pId];
                if (arProvince) {
                    stringProvince = arProvince.name;
                }
                
            }
        }
        if (tempUserAddressModel.isDefault) {
            Cell.txtAddress.text = [[NSString alloc] initWithFormat:@"                  %@%@%@%@",stringProvince,stringCity,stringDistrict,tempUserAddressModel.address];
        }
        else {
            Cell.txtAddress.text = [[NSString alloc] initWithFormat:@"%@%@%@%@",stringProvince,stringCity,stringDistrict,tempUserAddressModel.address];
        }
        
    }
    //设置图标
    if (self.controlType == 2) {
        //根据缓存地址过来
        NSDictionary *tempDic = [[EnvPreferences sharedInstance] getSelectedShipAddress];
        UserAddressModel *cacheUserAddressModel = (UserAddressModel*)[tempDic objectForKey:@"selectedShipAddress"];
        if (cacheUserAddressModel && [cacheUserAddressModel.addId isEqualToString:tempUserAddressModel.addId]) {
            [Cell.rightImage setImage:[UIImage imageNamed:@"icon_selected"]];
        }
        else{
            [Cell.rightImage setImage:[UIImage imageNamed:@"icon_not_selected"]];
        }
        
    }
    else {
        //普通编辑
        [Cell.rightImage setImage:[UIImage imageNamed:@"icon_rightArrow"]];
    }
    return Cell;
}

#pragma mark -- http request handler
-(void)httpRequestFinished:(NSNotification *)notification{
    [super httpRequestFinished:notification];
    //返回的数据
    ResultDataModel *result = notification.object;
    switch (result.requestType) {
        case KReqestType_Getconfignees:
            if (result.resultCode == 0) {
                //刷新的时候清空数据
                dataSource = [[NSMutableArray alloc] init];
                for (NSDictionary *dicTemp in result.data) {
                    [dataSource addObject:[[UserAddressModel alloc] initWithDictionary:dicTemp]];
                }
                //从新加载数据
                [self.addressTableView reloadData];
            }
            break;
        default:
            break;
    }
}
-(void)httpRequestFailed:(NSNotification *)notification{
    [super httpRequestFailed:notification];
}

@end




















