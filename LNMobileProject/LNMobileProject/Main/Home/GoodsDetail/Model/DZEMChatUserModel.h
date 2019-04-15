//
//  DZEMChatUserModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/25.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZEMChatUserModel : NSObject
@property (nonatomic, copy) NSString *head_pic;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *emchat_username;
@end

@interface DZEMChatUserNetModel : LNNetBaseModel
@property (nonatomic, strong) DZEMChatUserModel *data;
@end
