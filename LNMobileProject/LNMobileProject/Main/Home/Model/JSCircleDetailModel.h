//
//Created by ESJsonFormatForMac on 19/01/28.
//

#import <Foundation/Foundation.h>

@class JSCircleDetailData;
@interface JSCircleDetailModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) JSCircleDetailData *data;

@end
@interface JSCircleDetailData : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *like_count;

@property (nonatomic, copy) NSString *thumb_img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger has_like;

@property (nonatomic, copy) NSString *comment_count;

@property (nonatomic, copy) NSString *article_id;

@end

