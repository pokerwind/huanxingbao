//
//  DZCircleDetailViewController.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/28.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface DZCircleDetailViewController : LNBaseVC
/*
 * article_id
 */
@property (nonatomic,copy)NSString *article_id;

/*
 * title
 */
@property (nonatomic,copy)NSString *name;

/*
 * image
 */
@property (nonatomic,copy)NSString *image;

@end

NS_ASSUME_NONNULL_END
