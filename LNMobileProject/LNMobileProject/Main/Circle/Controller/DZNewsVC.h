//
//  DZNewsVC.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/8.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@interface DZNewsVC : LNBaseVC
@property (nonatomic, strong) RACSubject *releaseSubject;
@property (nonatomic, strong) RACSubject *clickSubject;

- (void)updateFollow:(NSString *)shopId status:(NSString *)isFollow;
- (void)refresh;
- (void)reload;
@end
