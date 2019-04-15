//
//  DZColorPickerView.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DZColorPickerViewDelegate <NSObject>

- (void)didSelectedColors:(NSArray *)colors;

@end

@interface DZColorPickerView : UIView

@property (nonatomic) id <DZColorPickerViewDelegate>delegate;

@end
