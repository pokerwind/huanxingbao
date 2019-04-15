//
//  DeviceListViewController.m  com.muyingshangcheng
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/11.
//  Copyright © 2019 rx. All rights reserved.
//

#import "DeviceListViewController.h"
#import "ModelTableViewCell.h"
#import "CustomRadarAnimationView.h"
#import "ToolCell.h"
#import "HomeViewController.h"

@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate>
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray<EasyPeripheral *> *deviceList;
@property (nonatomic,retain) CustomRadarAnimationView *radarView;
@property (nonatomic,retain) UILabel *tips;
@property (nonatomic,retain) CBCentralManager *manager;
@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
    
    self.title = @"蓝牙搜索";
    
    
    [self.view addSubview:self.tips];
    [self.tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(100);
        make.height.mas_equalTo(21);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
        
//        make.top.equalTo(self.view).with.offset(IsiPhoneX?88:64);
    }];
    
    
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ToolCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ToolCell class])];
    
    self.navigationItem.leftBarButtonItem=[CustomNaviViewController customButtonWithTitle:@"搜索" withImage:nil withBlock:^(UIButton *btn) {
        [btn addTarget:self action:@selector(scanDevice) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    
    self.navigationItem.rightBarButtonItem=[CustomNaviViewController customButtonWithTitle:@"开始" withImage:nil withBlock:^(UIButton *btn) {
        [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    // Do any additional setup after loading the view.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *strMessage = @"";
    NSString *buttonTitle = nil;
    switch (central.state) {
        case CBManagerStatePoweredOn: {
            NSLog(@"蓝牙开启且可用");
            return;
        }
            break;
        case CBManagerStateUnknown: {
            strMessage = @"手机没有识别到蓝牙，请检查手机。";
            buttonTitle = @"前往设置";
        }
            break;
        case CBManagerStateResetting: {
            strMessage = @"手机蓝牙已断开连接，重置中...";
            buttonTitle = @"前往设置";
        }
            break;
        case CBManagerStateUnsupported: {
            strMessage = @"手机不支持蓝牙功能，请更换手机。";
        }
            break;
        case CBManagerStatePoweredOff: {
            strMessage = @"手机蓝牙功能关闭，请前往设置打开蓝牙及控制中心打开蓝牙。";
            buttonTitle = @"前往设置";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:buttonTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //将字符串转换为16进制
                NSData *encryptString = [[NSData alloc] initWithBytes:(unsigned char []){0x41, 0x70, 0x70, 0x2d, 0x50, 0x72, 0x65, 0x66, 0x73, 0x3a, 0x72, 0x6f, 0x6f, 0x74, 0x3d, 0x42, 0x6c, 0x75, 0x65, 0x74, 0x6f, 0x6f, 0x74, 0x68} length:24];
                NSString *string = [[NSString alloc] initWithData:encryptString encoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:string];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case CBManagerStateUnauthorized: {
            strMessage = @"手机蓝牙功能没有权限，请前往设置。";
            buttonTitle = @"前往设置";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:buttonTitle message:strMessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //将字符串转换为16进制
                NSData *encryptString = [[NSData alloc] initWithBytes:(unsigned char []){0x41, 0x70, 0x70, 0x2d, 0x50, 0x72, 0x65, 0x66, 0x73, 0x3a, 0x72, 0x6f, 0x6f, 0x74, 0x3d, 0x42, 0x6c, 0x75, 0x65, 0x74, 0x6f, 0x6f, 0x74, 0x68} length:24];
                NSString *string = [[NSString alloc] initWithData:encryptString encoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:string];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
        default: { }
            break;
    }
    //通知没有打开蓝牙的自定义提示弹窗（弹窗代码自行实现）
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initRadarView];
    [self connectDevice];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.radarView removeFromSuperview];
    self.manager.delegate = nil;
    self.manager = nil;
}

-(void)initRadarView
{
    self.radarView = [[CustomRadarAnimationView alloc]initWithFrame:CGRectMake(50, 50, 200, 200) andThumbnail:@"ic_user"];//必须使用这个函数初始化
    self.radarView.circleColor=[UIColor colorWithHexString:@"#008B56"];//圈圈背景色
    self.radarView.borderColor=[UIColor colorWithHexString:@"#008B56"];//圈圈边界颜色
    self.radarView.pulsingCount=3;//圈圈个数
    self.radarView.animationDuration=2;//
    [self.radarView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.radarView];
    [self.radarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-100);
        make.height.width.mas_equalTo(200);
    }];
}

-(void)connectDevice
{
    [self.radarView setHidden:NO];
//    [[BluetoothManager shareBluetoothManager].bleManager disconnectAllPeripheral];
    [self.tableView setHidden:YES];
    self.deviceList = [NSMutableArray new];
    NSMutableArray *uuids = [[DataManager shareDataManager] getConnectedDeviceUUIDs];
    int __block counts = 0;
    if (uuids.count>0) {
        
        for (NSString *uuid in uuids) {
            [[BluetoothManager shareBluetoothManager].bleManager connectDeviceWithIdentifier:uuid callback:^(EasyPeripheral *peripheral, NSError *error) {
                if (!error) {
                    if (![[BluetoothManager shareBluetoothManager].peripheralArray containsObject:peripheral]) {
                        [[BluetoothManager shareBluetoothManager].peripheralArray addObject:peripheral];
                    }
                    
                }
                else
                {
                    [[DataManager shareDataManager] deleteConnectedDeviceUUID:uuid];
                }
                counts+=1;
                if (counts==uuids.count) {
//                    if ([BluetoothManager shareBluetoothManager].peripheralArray.count>0) {
//                        [self scanDevice];
//                    }
//                    else
//                    {
                        [self scanDevice];
//                    }
                }
            }];
            sleep(3);
        }
        
    }
    else
    {
        [self scanDevice];
    }
    
}

-(void)scanDevice
{
    self.deviceList = [NSMutableArray new];
    [self.tableView reloadData];
    kWeakSelf(self);
    [[BluetoothManager shareBluetoothManager] startScanDeviceWithBlock:^(NSArray<EasyPeripheral *> * _Nonnull deviceArray) {
        if (deviceArray.count>0) {
            [self.tableView setHidden:NO];
            for (EasyPeripheral *peripheral in deviceArray) {
                [self.deviceList addObject:peripheral];
            }
            [self.radarView setHidden:YES];
                        queueMainStart
            [weakself.tableView reloadData];
                        queueEnd
        }
        else
        {
            if ([BluetoothManager shareBluetoothManager].peripheralArray.count>0) {
                [self start];
            }
            else
            {
                [self.radarView setHidden:NO];
                [SVProgressHUD showInfoWithStatus:@"没有搜索到设备，请确保设备和手机蓝牙已经打开,并点击搜索"];
            }
        }
    }];
}

-(void)start
{
    if ([BluetoothManager shareBluetoothManager].peripheralArray.count==0) {
        [SVProgressHUD showInfoWithStatus:@"请先连接设备"];
        return;
    }
    [[BluetoothManager shareBluetoothManager].bleManager stopScanDevice];
    HomeViewController *homeVc = [HomeViewController new];
//    CustomNaviViewController *homeNavi = [[CustomNaviViewController alloc]initWithRootViewController:homeVc];
//    [self presentViewController:homeNavi animated:YES completion:^{
//
//    }];
    [self.navigationController pushViewController:homeVc animated:YES];
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
    [[BluetoothManager shareBluetoothManager].bleManager stopScanDevice];
    
//    kWeakSelf(self)
    EasyPeripheral *peripherals = self.deviceList[indexPath.row];
    if (peripherals.state==CBPeripheralStateConnected) {
        [[DataManager shareDataManager] deleteConnectedDeviceUUID:peripherals.identifierString];
        [peripherals disconnectDevice];
        [self.deviceList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
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
                queueMainStart
                [self.tableView reloadData];
                queueEnd
            }
        }];
    }
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

-(UILabel*)tips
{
    if (!_tips) {
        _tips = [UILabel new];
        [_tips setFont:[UIFont systemFontOfSize:15]];
        [_tips setText:@"请保持设备和手机蓝牙打开"];
        [_tips setTextColor:[UIColor blackColor]];
        
    }
    return _tips;
}

@end
