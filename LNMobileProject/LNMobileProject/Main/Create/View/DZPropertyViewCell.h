//
//  DZPropertyViewCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetAttrListModel.h"

@interface DZPropertyViewCell : UITableViewCell

@property (strong, nonatomic) NSArray *dataArray;

- (void)fillData:(DZAttrListModel *)model;

@end
