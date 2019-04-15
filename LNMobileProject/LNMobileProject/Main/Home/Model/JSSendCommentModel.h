//
//Created by ESJsonFormatForMac on 19/01/29.
//

#import <Foundation/Foundation.h>

@class JSSendCommentData;
@interface JSSendCommentModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) JSSendCommentData *data;

@end
@interface JSSendCommentData : NSObject

@property (nonatomic, assign) NSInteger article_id;

@property (nonatomic, assign) NSInteger add_time;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *user_id;

@end

