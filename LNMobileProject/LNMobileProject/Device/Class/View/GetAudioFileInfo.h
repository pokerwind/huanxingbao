//
//  GetAudioFileInfo.h
//  Vting
//
//  Created by 寇凤伟 on 2019/1/4.
//  Copyright © 2019 LodeStreams. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetAudioFileInfo : NSObject<EZAudioFileDelegate>
+ (instancetype)sharedGetInfo;

@property(nonatomic,retain)NSMutableData *audioData;

-(float)calculateTimeWithUrl:(NSURL*)fileUrl;
- (void)cutAudioDataWithUrl:(NSURL*)fileUrl  success:(void (^)(NSMutableArray*,NSTimeInterval))success;
- (void)cutAudioDataWithUrl:(NSURL*)fileUrl withCount:(UInt32)count success:(void (^)(id,NSTimeInterval))success;
@end

NS_ASSUME_NONNULL_END
