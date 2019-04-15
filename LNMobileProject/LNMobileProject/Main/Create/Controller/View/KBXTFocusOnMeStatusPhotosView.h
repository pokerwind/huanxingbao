//
//  KBXTFocusOnMeStatusPhotosView.h
//  LNMobileProject
//
//  Created by liuniukeji on 2017/8/18.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KBXTFocusOnMeStatusPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) RACSubject *delegateSignal;
/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGFloat)sizeWithCount:(NSUInteger)count;
@end
