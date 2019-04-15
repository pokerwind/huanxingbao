//
//  DZCartSpecCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/6.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZEditCartGoodsSpecModel.h"

@protocol DZCartSpecCellDelegate <NSObject>

- (void)refreshCartData;

@end

@interface DZCartSpecCell : UITableViewCell

- (void)fillData:(DZCartSpecModel *)model;

@property (weak, nonatomic) id <DZCartSpecCellDelegate>delegate;

@end
