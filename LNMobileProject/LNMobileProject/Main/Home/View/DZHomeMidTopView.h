//
//  DZHomeMidTopView.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/18.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^lxzBlock)(void);
typedef void (^mfsyBlock)(void);
typedef void (^pxgBlock)(void);

@interface DZHomeMidTopView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *lxzImageV;
@property (weak, nonatomic) IBOutlet UIImageView *mfsyImagev;
@property (weak, nonatomic) IBOutlet UIImageView *pxgImageV;

/*
 * lxzBlock
 */
@property (nonatomic,copy)lxzBlock lBlock;

/*
 *mfsyBlock
 */
@property (nonatomic,copy)mfsyBlock mBlock;

/*
 * pxg
 */
@property (nonatomic,copy)pxgBlock pBlock;
@end

NS_ASSUME_NONNULL_END
