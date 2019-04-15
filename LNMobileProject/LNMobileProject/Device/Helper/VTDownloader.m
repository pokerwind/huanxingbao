//
//  VTDownloader.m
//  Vting
//
//  Created by pppsy on 2018/11/17.
//  Copyright © 2018 LodeStreams. All rights reserved.
//

#import "VTDownloader.h"
//#import "UIImage+GIFImage.h"

@implementation VTDownloader

+ (void)downloadByUrl:(NSString*)sourceUrl
              success:(VTDownloadSuccessBlock)successBlk
                 fail:(VTDownloadFailureBlock)failBlk {
    [SVProgressHUD showWithStatus:@"下载中..."];
    if (isUrlFileExist(sourceUrl)) {
        successBlk(filePathByUrl(sourceUrl));
        return;
    }
    
//    NSString *path = filePathByUrl(sourceUrl);
//    [BaseNetworkRequest downloadFileWithURL:sourceUrl savedPath:path downloadSuccess:^(NSURL *filePath) {
//        successBlk(path);
//    } downloadFailure:^(NSError *error) {
//        failBlk();
//    }];
    NSString *path = filePathByUrl(sourceUrl);
    [HttpUtils downloadFileWithURL:sourceUrl savedPath:path downloadSuccess:^(NSURL *filePath) {
        successBlk(path);
    } downloadFailure:^(NSError *error) {
        failBlk();
    }];
}

@end

NSString *filePathByUrl(NSString *url) {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *urlPath = [NSString stringWithFormat:@"%@/%@.mp3", documentPath, [CocoaSecurity md5:url].hex];
    return urlPath;
}


BOOL isUrlFileExist(NSString *url) {
    NSString *path = filePathByUrl(url);
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}
