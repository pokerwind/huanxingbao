//
//  MemoryListViewController.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/13.
//  Copyright © 2019 rx. All rights reserved.
//

#import "MemoryListViewController.h"
#import "ToolCell.h"
#import "DeviceListViewController.h"

@interface MemoryListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray<EasyPeripheral *> *deviceList;

@end

@implementation MemoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"已连接的设备";
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem=[CustomNaviViewController customButtonWithTitle:@"重新搜索" withImage:nil withBlock:^(UIButton *btn) {
        [btn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
        
        //        make.top.equalTo(self.view).with.offset(IsiPhoneX?88:64);
    }];
    self.deviceList = [BluetoothManager shareBluetoothManager].peripheralArray;
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

-(void)search
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DeviceListViewController class]]) {
            DeviceListViewController *A =(DeviceListViewController *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToolCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ToolCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.peripheral = self.deviceList[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[BluetoothManager shareBluetoothManager].bleManager stopScanDevice];
    
    //    kWeakSelf(self)
    EasyPeripheral *peripherals = self.deviceList[indexPath.row];
    if (peripherals.state==CBPeripheralStateConnected) {
        [SVProgressHUD showInfoWithStatus:@"断开连接中....."];
        [BluetoothManager shareBluetoothManager].timeout = 0;
        [[BluetoothManager shareBluetoothManager].modeAry removeAllObjects];
        [[BluetoothManager shareBluetoothManager] sendOrderWithOrder:0xA1 WithDataStr:@"00"];
        [[DataManager shareDataManager] deleteConnectedDeviceUUID:peripherals.identifierString];
        [self.deviceList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [self performSelector:@selector(disconnectDevicesWithPeriph:) withObject:peripherals afterDelay:3.0];
        
        
    }
    else{
        [SVProgressHUD showWithStatus:@"正在连接设备..."];
        [peripherals connectDeviceWithCallback:^(EasyPeripheral *perpheral, NSError *error, deviceConnectType deviceConnectType) {
            if (deviceConnectType == deviceConnectTypeDisConnect) {
                [SVProgressHUD showInfoWithStatus:@"设备断开连接"];
            }
            else if (deviceConnectType == deviceConnectTypeFaild)
            {
                [SVProgressHUD showInfoWithStatus:@"设备连接失败"];
            }
            else if (deviceConnectType == deviceConnectTypeFaildTimeout)
            {
                [SVProgressHUD showInfoWithStatus:@"设备连接超时"];
            }
            else{
                [SVProgressHUD showInfoWithStatus:@"设备连接成功"];
                if (![[BluetoothManager shareBluetoothManager].peripheralArray containsObject:perpheral]) {
                    [[BluetoothManager shareBluetoothManager].peripheralArray addObject:perpheral];
                }
                [[DataManager shareDataManager] saveConnectedDeviceUUID:perpheral.identifierString];
                [self.tableView reloadData];
            }
        }];
    }
}

-(void)disconnectDevicesWithPeriph:(EasyPeripheral *)peripherals{
    [SVProgressHUD dismiss];
    [peripherals disconnectDevice];
}

-(UITableView*)tableView
{
    if (!_tableView) {
        //布局
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ToolCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ToolCell class])];
        //        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
        //        [view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btn setBackgroundColor:[UIColor greenColor]];
        //        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [btn setFrame:CGRectMake(0, 0, 80, 30)];
        //        [self.view addSubview:btn];
    }
    return _tableView;
}



@end
