//
//  ConversationListControllerViewController.h
//  HBuilder-Integrate
//
//  Created by 云网通 on 2017/3/20.
//  Copyright © 2017年 DCloud. All rights reserved.
//



@interface ConversationListControllerViewController : EaseConversationListViewController
@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
@end
