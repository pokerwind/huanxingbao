//
//  DZHomeAdReusableView.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DZBannerModel.h"

@interface DZHomeAdReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) RACSubject *clickSubject;
@property (nonatomic, strong) DZBannerModel *model;
@end
