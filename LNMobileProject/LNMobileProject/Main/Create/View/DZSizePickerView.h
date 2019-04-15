//
//  DZSizePickerView.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DZSizePickerViewDelegate <NSObject>

- (void)didSelectedSizes:(NSArray *)sizes;

@end

@interface DZSizePickerView : UIView

@property (nonatomic) id <DZSizePickerViewDelegate>delegate;

@end
