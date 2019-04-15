//
//  THTeamVC.h
//  LNMobileProject
//
//  Created by 童浩 on 2019/3/18.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface THTeamVC : LNBaseVC
@property (weak, nonatomic) IBOutlet UILabel *leijixiaofeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuexiaofeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuejiangliLabel;
@property (weak, nonatomic) IBOutlet UILabel *leijiJiangliLabel;
@property (weak, nonatomic) IBOutlet UIButton *xuanzeyuefenButton;
@property(nonatomic,strong) NSString *dateStr;
@end

NS_ASSUME_NONNULL_END
