//
//  DZCartCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/31.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DZGetCartListModel.h"
#import "JSShopCartModel.h"
@protocol DZCartCellSelectionDelegate <NSObject>

- (void)selectionChanged;
- (void)modifyFrameWithGroup:(NSInteger)group goodIndex:(NSInteger)goodIndex;
- (void)didClickGood:(NSString *)goodId;

@end

@interface DZCartCell : UITableViewCell

- (void)fillData:(JSShopCartList *)model;

@property (nonatomic) id <DZCartCellSelectionDelegate>delegate;

@end
