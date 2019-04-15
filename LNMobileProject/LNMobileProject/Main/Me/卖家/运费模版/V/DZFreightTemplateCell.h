//
//  DZFreightTemplateCell.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZFreightTemplateCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UITextField *firstPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *addPriceTextField;

+ (NSString *)cellIdentifier;

@end
