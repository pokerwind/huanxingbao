//
//  DZCartModifyVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZCartModifyVCDelegate <NSObject>

- (void)cartDidModified;

@end

@interface DZCartModifyVC : LNBaseVC

@property (strong, nonatomic) NSString *goods_id;

@property (nonatomic) id <DZCartModifyVCDelegate>delegate;

@end
