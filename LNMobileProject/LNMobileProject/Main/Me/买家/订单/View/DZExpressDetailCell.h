//
//  DZExpressDetailCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZGetExpressTracesModel.h"

@interface DZExpressDetailCell : UITableViewCell

- (void)fillData:(DZTracesModel *)model type:(NSInteger)type;

@end
