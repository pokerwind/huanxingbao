//
//  DZBatchGoodsEditVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZBatchGoodsEditVCDelegate <NSObject>

- (void)updateOriginalData;

@end

@interface DZBatchGoodsEditVC : LNBaseVC

@property (nonatomic) NSString *currentType;//0:已下架1:已上架
@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic) id <DZBatchGoodsEditVCDelegate>delegate;

@end
