//
//  BluetoothManager.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/11.
//  Copyright © 2019 rx. All rights reserved.
//

#import "BluetoothManager.h"

@implementation BluetoothManager
static BluetoothManager *shareBluetoothManager = nil;

+ (instancetype)shareBluetoothManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareBluetoothManager = [[self alloc] init];
        shareBluetoothManager.modeAry = [NSMutableArray new];
        shareBluetoothManager.timeout = 300;
        shareBluetoothManager.peripheralArray = [NSMutableArray new];
        shareBluetoothManager.bleManager.bluetoothStateChanged = ^(EasyPeripheral *peripheral, bluetoothState state) {
            queueMainStart
            switch (state) {
                case bluetoothStateSystemReadly:
                    //                    [SVProgressHUD showInfoWithStatus:@"蓝牙已准备就绪..."];
                    break;
                case bluetoothStateDeviceFounded:
                    [SVProgressHUD showInfoWithStatus:@"已发现设备"];
                    break ;
                case bluetoothStateDeviceConnected:
                    [SVProgressHUD showInfoWithStatus:@"设备连成功"];
                default:
                    break;
            }
            queueEnd
        };
        
    });
    return shareBluetoothManager;
}

-(void)startScanDeviceWithBlock:(deviceArrayCallback)complete
{
    //    WeakSelf(self);
    //    [self.bleManager scanAllDeviceWithRule:^BOOL(EasyPeripheral *peripheral) {
    //        return [peripheral.name isEqualToString:@"BRA-C"];
    //    } callback:^(NSArray<EasyPeripheral *> *deviceArray, NSError *error) {
    //        complete(deviceArray);
    //    }];
    [self.bleManager scanAllDeviceWithName:@"BRA-C" callback:^(NSArray<EasyPeripheral *> *deviceArray, NSError *error) {
        complete(deviceArray);
    }];
    
    
    //    [self.bleManager scanDeviceWithName:@"BRA-C" callback:^(EasyPeripheral *peripheral, NSError *error) {
    //        if (peripheral) {
    //            if (searchType&searchFlagTypeChanged) {
    //                NSInteger perpheralIndex = [weakself.dataArray indexOfObject:peripheral];
    //                [weakself.dataArray replaceObjectAtIndex:perpheralIndex withObject:peripheral];
    //            }
    //            else if(searchType&searchFlagTypeAdded){
    //                [weakself.dataArray addObject:peripheral];
    //            }
    //            else if (searchType&searchFlagTypeDisconnect || searchType&searchFlagTypeDelete){
    //                [weakself.dataArray removeObject:peripheral];
    //            }
    //            queueMainStart
    //            [weakself.tableView reloadData];
    //            queueEnd
    //        }
    //    }];
}

- (void)sendOrderWithOrder:(Byte)orderStr WithDataStr:(NSString*)dataStr
{
    //    Byte *orderByte = (Byte *)[[self hexStringToData:orderStr] bytes];
//    [[DataManager shareDataManager] stopPlaying];
    Byte *dataByte = (Byte *)[[self hexStringToData:dataStr] bytes];
    for (EasyPeripheral *peripheral in self.peripheralArray) {
        Byte bytes[6]= {0x66,0xbb,0x01,0x02,orderStr,*dataByte};
        NSData *D = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        NSMutableData *date = [NSMutableData dataWithData:D];
        [date appendData:[self encrypt:D]];
        
//        QueueStartAfterTime(0.5)
        [self.bleManager writeDataWithPeripheral:peripheral serviceUUID:@"0xAE00" writeUUID:@"0xAE01" data:date callback:nil];
//        queueEnd
    }
    
}

- (void)sendTimeOrderWithOrder:(Byte)orderStr WithInt:(int)second
{
    Byte byte[4] = {};
    byte[0] = (Byte) ((second>>24) & 0xFF);
    byte[1] = (Byte) ((second>>16) & 0xFF);
    byte[2] = (Byte) ((second>>8) & 0xFF);
    byte[3] = (Byte) (second & 0xFF);
    
    //    Byte *orderByte = (Byte *)[[self hexStringToData:orderStr] bytes];
//    [[DataManager shareDataManager] stopPlaying];
    for (EasyPeripheral *peripheral in self.peripheralArray) {
        Byte bytes[7]= {0x66,0xbb,0x01,0x03,orderStr,byte[2],byte[3]};
        NSData *D = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        NSMutableData *date = [NSMutableData dataWithData:D];
        [date appendData:[self encrypt:D]];
        
//        QueueStartAfterTime(0.5)
        [self.bleManager writeDataWithPeripheral:peripheral serviceUUID:@"0xAE00" writeUUID:@"0xAE01" data:date callback:nil];
//        queueEnd
    }
    
}

- (void)sendOrderWithDataStr:(Byte)data
{
    for (EasyPeripheral *peripheral in self.peripheralArray) {
        Byte bytes[6]= {0x66,0xbb,0x01,0x02,0xA6,data};
        NSData *D = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        NSMutableData *date = [NSMutableData dataWithData:D];
        [date appendData:[self encrypt:D]];
        QueueStartAfterTime(0.5)
        [self.bleManager writeDataWithPeripheral:peripheral serviceUUID:@"0xAE00" writeUUID:@"0xAE01" data:date callback:nil];
        
        queueEnd
    }
    
}

-(NSData *)hexStringToData:(NSString *)hexString{
    const char *chars = [hexString UTF8String];
    int i = 0;
    int len = (int)hexString.length;
    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i<len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

#pragma mark - bluetooth callback

-(void)deleteBluetoothManager
{
    [self.bleManager disconnectAllPeripheral];
}


- (NSData *)encrypt:(NSData *)data {
    Byte *sourceDataPoint = (Byte *)[data bytes];  //取需要加密的数据的Byte数组
    Byte result = 0x00;
    //    char *dataP = (char *)[data bytes];
    for (int i = 0; i < data.length; i++) {
        result ^= sourceDataPoint[i];
    }
    Byte byte[1] = {result};
    NSData *sumData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    return sumData;
}

- (EasyBlueToothManager *)bleManager
{
    if (nil == _bleManager) {
        _bleManager = [EasyBlueToothManager shareInstance];
        
        dispatch_queue_t queue = dispatch_queue_create("com.ss.testhl", 0);
        NSDictionary *managerDict = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
        NSDictionary *scanDict = @{CBCentralManagerScanOptionAllowDuplicatesKey: @YES };
        NSDictionary *connectDict = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
        
        EasyManagerOptions *options = [[EasyManagerOptions alloc]initWithManagerQueue:queue managerDictionary:managerDict scanOptions:scanDict scanServiceArray:nil connectOptions:connectDict];
        options.scanTimeOut = 8 ;
        options.connectTimeOut = 10 ;
        options.autoConnectAfterDisconnect = YES ;
        
        [EasyBlueToothManager shareInstance].managerOptions = options ;
        
    }
    
    return _bleManager ;
}

//- (void)setTimeout:(int)timeout
//{
//    if (timeout == 0) {
//        [self sendOrderWithOrder:0xA1 WithDataStr:@"00"];
//
//        self.modeAry = [NSMutableArray new];
//    }
//    _timeout = timeout;
//}


- (void)countDown {
    
    if (self.modeAry.count<=0) {
        [[DataManager shareDataManager] deleteCurrentMode:@""];
        return;
    }
    [[DataManager shareDataManager] stopPlaying];
    //    kWeakSelf(self);
    if (_timeout >0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0);
        //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(self->_timeout<=0){
                //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                if (self.modeAry.count>0) {
                    [self.modeAry removeObjectAtIndex:0];
                }
                
                self->_timeout = 300;
                [self countDown];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                if(self.modeAry.count==0){
                    self->_timeout=0;
                    return ;
                }
                if (self->_timeout == 300) {
                    NSString*str = [self.modeAry objectAtIndex:0];
                    NSArray *arr = [str componentsSeparatedByString:@"-"];
                    if ([arr[0]isEqualToString:@"A1"]) {
                        [self sendOrderWithOrder:0xA1 WithDataStr:arr[1]];
                    }
                    else if([arr[0]isEqualToString:@"A2"])
                    {
                        [self sendOrderWithOrder:0xA2 WithDataStr:arr[1]];
                    }
                    else
                    {
                        [self sendOrderWithOrder:0xA5 WithDataStr:arr[1]];
                    }
                    
                }
                self->_timeout--;
                
            }
            
        });
        dispatch_resume(_timer);
    }
}

@end
