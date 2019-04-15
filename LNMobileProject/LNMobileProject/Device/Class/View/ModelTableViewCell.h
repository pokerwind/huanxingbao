//
//  ModelTableViewCell.h
//  IntelligentBra
//
//  Created by 寇凤伟 on 2019/3/10.
//  Copyright © 2019 rx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
//切换按钮block
@property (nonatomic, copy) void(^switchBlock)(UISwitch *sender);
- (void)setButtonImageAndTitleWithSpace:(CGFloat)spacing WithButton:(UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
