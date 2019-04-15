//
//  HomeCell.h
//  FoxPlayer
//
//  Created by hahaha on 2018/10/13.
//  Copyright © 2018年 RX. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    IBCellBorderDirectionTop = 1 << 0,
    IBCellBorderDirectionBottom = 1<<1,
    IBCellBorderDirectionRight = 1 <<2,
    IBCellBorderDirectionLeft = 1<<3,
    
} IBCellBorderDirection;
@interface HomeCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, assign) BOOL needBorder;
/// 播放按钮block
@property (nonatomic, copy  ) void(^playBlock)(UIButton *sender);

//@property (nonatomic, strong) NSDictionary *data;

@end
