//
//  DZGetClientEvaluateModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZReviewModel : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *add_time;

@end

@interface DZClientEvaluateModel : NSObject

@property (strong, nonatomic) NSString *comment_id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *rank;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *head_pic;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSArray *comment_img;
@property (strong, nonatomic) DZReviewModel *review;
@property(nonatomic,strong) NSArray *img_comment_array;
@property(nonatomic,strong) NSString *reply_content;
@property(nonatomic,strong) NSString *parent_id;
@end

@interface DZGetClientEvaluateModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
