//
//  DZHomeMidBottomView.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/18.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^jfdhBlock)(void);
typedef void (^hyqyBlock)(void);
typedef void (^dkfBlock)(void);
@interface DZHomeMidBottomView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *jfdhImagev;
@property (weak, nonatomic) IBOutlet UIImageView *hyqyImagev;
@property (weak, nonatomic) IBOutlet UIImageView *dkfImageV;
/*
 * lxzBlock
 */
@property (nonatomic,copy)jfdhBlock jBlock;

/*
 *mfsyBlock
 */
@property (nonatomic,copy)hyqyBlock hBlock;

/*
 * pxg
 */
@property (nonatomic,copy)dkfBlock dBlock;
@end

NS_ASSUME_NONNULL_END
