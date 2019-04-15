//
//  CustomNaviViewController.h
//  Could
//
//  Created by hahaha on 15/5/15.
//  Copyright (c) 2015年 hahaha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNaviViewController : UINavigationController
{
}

@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UIImage *hairLineBackup;
@property(nonatomic,assign) BOOL scrolls;

+(UIBarButtonItem*)customButtonWithTitle:(NSString*)titles withImage:(UIImage*)image withBlock:(void (^)(UIButton *))block;
+(UIBarButtonItem*)customButtonWithTitle:(NSString*)titles withImage:(UIImage*)image WithTitle:(NSString*)str withBlock:(void (^)(UIButton *btn))block;
+(UIBarButtonItem*)addBackBtn;
-(void)backs;
@end
