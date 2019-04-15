//
//  DZOpenShopSelectionView.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/22.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DZOpenShopSelectionViewDelegate <NSObject>

- (void)didSelectShopType:(NSInteger)type;

@end

@interface DZOpenShopSelectionView : UIView

@property (nonatomic) id <DZOpenShopSelectionViewDelegate>delegate;
@property(nonatomic,strong) NSArray *dataArray;

@end
