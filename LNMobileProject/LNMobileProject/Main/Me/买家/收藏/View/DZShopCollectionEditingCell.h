//
//  DZShopCollectionEditingCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/14.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZShopCollectionEditingCell : UITableViewCell

- (void)fillData:(NSDictionary *)dict;

- (void)setEditingState:(NSInteger)state;

@end
