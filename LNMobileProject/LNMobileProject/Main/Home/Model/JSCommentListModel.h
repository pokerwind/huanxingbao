//
//Created by ESJsonFormatForMac on 19/01/29.
//

#import <Foundation/Foundation.h>

@class JSCommentListData;
@interface JSCommentListModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) NSArray *data;

@end
@interface JSCommentListData : NSObject

@property (nonatomic, copy) NSString *article_id;

@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *head_pic;

@end

