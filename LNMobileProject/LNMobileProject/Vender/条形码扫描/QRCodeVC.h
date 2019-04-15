//
//  QRCodeVC.h
//  shikeApp
//
//  Created by 淘发现4 on 16/1/7.
//  Copyright © 2016年 淘发现1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeVCDelegate <NSObject>

- (void)didScanText:(NSString *)text;

@end

@interface QRCodeVC : UIViewController

@property (nonatomic, weak) id <QRCodeVCDelegate>delegate;

@end
