//
//  DZHomeMidMView.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/18.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZBannerModel.h"
typedef void (^DZImageClickBlock)(DZBannerModel *JsonModel);
NS_ASSUME_NONNULL_BEGIN

@interface DZHomeMidMView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *adImageV;
- (IBAction)btnClick:(UIButton *)sender;

/*
 * DZBannerModel
 */
@property (nonatomic,strong)DZBannerModel *bannerModel;



/*
 * DZImageClickBlock
 */
@property (nonatomic,copy)DZImageClickBlock block;

@end

NS_ASSUME_NONNULL_END
