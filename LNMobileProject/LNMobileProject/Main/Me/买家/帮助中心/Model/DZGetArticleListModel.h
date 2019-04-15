//
//  DZGetArticleListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/1.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZArticleListModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *addtime;
@property (strong, nonatomic) NSString *article_id;
@property (strong, nonatomic) NSString *introduce;

@end

@interface DZGetArticleListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
