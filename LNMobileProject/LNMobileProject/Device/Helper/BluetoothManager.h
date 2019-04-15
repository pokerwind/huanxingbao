//
//  BluetoothManager.h
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/11.
//  Copyright © 2019 rx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyBlueToothManager.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^deviceArrayCallback)(NSArray<EasyPeripheral *> *deviceArray);
@interface BluetoothManager : NSObject

+ (instancetype)shareBluetoothManager;
@property (nonatomic,strong)EasyBlueToothManager *bleManager;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) EasyPeripheral *peripheral;
@property (nonatomic,strong)NSMutableArray<EasyPeripheral *> *peripheralArray;
-(void)startScanDeviceWithBlock:(deviceArrayCallback)complete;
- (void)sendOrderWithOrder:(Byte)orderStr WithDataStr:(NSString*)dataStr;
- (void)sendTimeOrderWithOrder:(Byte)orderStr WithInt:(int)second;
- (void)sendOrderWithDataStr:(Byte)data;


@property (nonatomic,assign)__block int timeout;
@property (nonatomic,retain) NSMutableArray *modeAry;
- (void)countDown;
@end

NS_ASSUME_NONNULL_END
