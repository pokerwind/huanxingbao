//
//  DataManager.m
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/11.
//  Copyright © 2019 rx. All rights reserved.
//

#import "DataManager.h"
#import "GetAudioFileInfo.h"

@implementation DataManager

static DataManager *shareDataManager = nil;

+ (instancetype)shareDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataManager = [[self alloc] init];
        shareDataManager.selectPath = nil;
        
    });
    return shareDataManager;
}

- (void)saveCurrentMode:(NSString *)modeId
{
    self.currentMode = modeId;
}

- (void)deleteCurrentMode:(NSString *)modeId
{
    self.currentMode = @"";
}

- (void)saveConnectedDeviceUUID:(NSString *)uuid
{
    if (!dx_isNullOrNilWithObject(uuid)) {
        NSMutableArray *uuidAry = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuids"];
        NSMutableArray *mutableCopyArr = [uuidAry mutableCopy];
        if (!mutableCopyArr) {
            mutableCopyArr = [NSMutableArray new];
        }
        if (mutableCopyArr&&![mutableCopyArr containsObject:uuid]) {
            [mutableCopyArr addObject:uuid];
        }
        [[NSUserDefaults standardUserDefaults] setObject:mutableCopyArr forKey:@"uuids"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)deleteConnectedDeviceUUID:(NSString *)uuid
{
    if (!dx_isNullOrNilWithObject(uuid)) {
        NSMutableArray *uuidAry = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuids"];
        NSMutableArray *mutableCopyArr = [uuidAry mutableCopy];
        if (mutableCopyArr&&[mutableCopyArr containsObject:uuid]) {
            [mutableCopyArr removeObject:uuid];
        }
        [[NSUserDefaults standardUserDefaults] setObject:mutableCopyArr forKey:@"uuids"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSMutableArray*)getConnectedDeviceUUIDs
{
    NSMutableArray *uuidAry = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuids"];
    if (uuidAry) {
        return uuidAry;
    }
    else
    {
        return [NSMutableArray new];
    }
}

- (NSString*)getCurrentMode
{
    if(dx_isNullOrNilWithObject(self.currentMode))
    {
        return @"";
    }
    else
    {
        return self.currentMode;
    }
}

-(void)playTheMusicWithUrl:(NSString*)url
{
    [VTDownloader downloadByUrl:url success:^(NSString * _Nonnull filePath) {
        [SVProgressHUD dismiss];
        WeakSelf(self);
        [[GetAudioFileInfo sharedGetInfo] cutAudioDataWithUrl:[[NSURL alloc] initFileURLWithPath:filePath] success:^(NSMutableArray* wavesamples,NSTimeInterval ms) {
            // 创建要播放的资源
            AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:[[NSURL alloc]initFileURLWithPath:filePath]];
            if (self.timeObserve) {
                [self.player removeTimeObserver:self.timeObserve];
            }
            
            // 播放当前资源
            if (self.player) {
                [self.player replaceCurrentItemWithPlayerItem:nil];
            }
            else
            {
                self.player = [[AVPlayer alloc]initWithPlayerItem:nil];
            }
            
            [self.player replaceCurrentItemWithPlayerItem:playerItem];
            [self.player setVolume:1.0];
            [self.player play];
            
            
            weakself.count = 0;
            self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                //                int current = CMTimeGetSeconds(time);
                NSLog(@"%f||||||||||||||||||",CMTimeGetSeconds(time));
                CGFloat progress = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
                if (progress == 1) {
                    [[BluetoothManager shareBluetoothManager] sendOrderWithOrder:0xA1 WithDataStr:@"00"];
                }
                if (weakself.count<=wavesamples.count-1) {
                    Byte b=( Byte) 0xff&[wavesamples[weakself.count] intValue];
                    [[BluetoothManager shareBluetoothManager] sendOrderWithDataStr:b];
                    weakself.count++;
                }
            }];
        }];
    } fail:^{
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"网络请求失败"];
    }];
}

-(void)stopPlaying
{
//    if (self.timeObserve) {
//        [self.player removeTimeObserver:self.timeObserve];
//        
//    }
     [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
}



    

@end
