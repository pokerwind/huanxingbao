//
//  DZCartInnerCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/31.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetCartListModel.h"
#import "JSShopCartModel.h"

@interface DZCartInnerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectionButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;

- (void)fillData:(JSShopCartGoods *)model;

@end
