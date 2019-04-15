//
//  DataManager.h
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/11.
//  Copyright © 2019 rx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject
@property (nonatomic, strong) NSDictionary   *modeData;
+ (instancetype)shareDataManager;
@property (nonatomic, copy) NSString  *currentMode;
- (void)saveCurrentMode:(NSString *)modeId;
- (void)deleteCurrentMode:(NSString *)modeId;
- (void)saveConnectedDeviceUUID:(NSString *)uuid;
- (NSMutableArray*)getConnectedDeviceUUIDs;
- (void)deleteConnectedDeviceUUID:(NSString *)uuid;
- (NSString*)getCurrentMode;

//播放器相关
@property (nonatomic,strong,nullable) AVPlayer *player;
@property (nonatomic,retain) id timeObserve;
@property (nonatomic,assign) int count;
@property(nonatomic,strong,nullable) NSIndexPath *selectPath;
-(void)playTheMusicWithUrl:(NSString*)url;
-(void)stopPlaying;


@end

NS_ASSUME_NONNULL_END
