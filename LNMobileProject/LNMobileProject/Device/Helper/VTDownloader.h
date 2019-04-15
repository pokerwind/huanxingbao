//
//  VTDownloader.h
//  Vting
//
//  Created by pppsy on 2018/11/17.
//  Copyright © 2018 LodeStreams. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VTDownloadSuccessBlock)(NSString *filePath);
typedef void(^VTDownloadFailureBlock)(void);

@interface VTDownloader : NSObject

+ (void)downloadByUrl:(NSString*)sourceUrl
              success:(VTDownloadSuccessBlock)successBlk
                 fail:(VTDownloadFailureBlock)failBlk;

@end

NSString *filePathByUrl(NSString *url);
BOOL isUrlFileExist(NSString *url);

NS_ASSUME_NONNULL_END
