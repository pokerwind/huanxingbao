//
//  GetAudioFileInfo.m
//  Vting
//
//  Created by 寇凤伟 on 2019/1/4.
//  Copyright © 2019 LodeStreams. All rights reserved.
//

#import "GetAudioFileInfo.h"
#import <AVFoundation/AVFoundation.h>

@implementation GetAudioFileInfo
+ (instancetype)sharedGetInfo {
    static GetAudioFileInfo* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


#pragma mark - Private Method
-(float)calculateTimeWithUrl:(NSURL*)fileUrl
{
    AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds*1000;
}

- (void)cutAudioDataWithUrl:(NSURL*)songAsset success:(void (^)(NSMutableArray *,NSTimeInterval))success{
    
//    self.audioData = [NSMutableData new];
    
    NSMutableArray *filteredSamplesMA = [[NSMutableArray alloc]init];
    
    EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:songAsset];
    
    if (audioFile.duration*2 == 0) {
        return;
    }
    
    [audioFile getWaveformDataWithNumberOfPoints:audioFile.duration*2 completion:^(float **waveformData, int length) {
        if (!waveformData) {
            success(filteredSamplesMA,audioFile.duration*1000);
        }
        float *data = waveformData[0];
        float maxValue = 0;
        for (int intSample = 0 ; intSample < length ; intSample ++ ) {
            float y = data[intSample];
            if (maxValue<y) {
                maxValue = y;
            }
        }
        float scale = maxValue/100;
        for (int intSample = 0 ; intSample < length ; intSample ++ ) {
            int y = data[intSample]/scale;
            [filteredSamplesMA addObject:@(y)];
        }
        success(filteredSamplesMA,audioFile.duration*1000);
    }];
}

- (void)cutAudioDataWithUrl:(NSURL*)songAsset withCount:(UInt32)count success:(void (^)(id,NSTimeInterval))success{
    
    //    self.audioData = [NSMutableData new];
    
    NSMutableArray *filteredSamplesMA = [[NSMutableArray alloc]init];
    
    EZAudioFile *audioFile = [EZAudioFile audioFileWithURL:songAsset];
    
    if (audioFile.duration*10 == 0) {
        return;
    }
    
    [audioFile getWaveformDataWithNumberOfPoints:count completion:^(float **waveformData, int length) {
        if (!waveformData) {
            success(filteredSamplesMA,audioFile.duration*1000);
        }
        float *data = waveformData[0];
        float maxValue = 0;
        for (int intSample = 0 ; intSample < length ; intSample ++ ) {
            float y = data[intSample];
            if (maxValue<y) {
                maxValue = y;
            }
        }
        float scale = maxValue/128;
        for (int intSample = 0 ; intSample < length ; intSample ++ ) {
            int y = data[intSample]/scale;
            [filteredSamplesMA addObject:@(y)];
        }
        success(filteredSamplesMA,audioFile.duration*1000);
    }];
}

@end
