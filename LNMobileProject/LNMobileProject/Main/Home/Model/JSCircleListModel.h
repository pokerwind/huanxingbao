//
//Created by ESJsonFormatForMac on 19/01/28.
//

#import <Foundation/Foundation.h>

@class JSCircleListData;
@interface JSCircleListModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) NSArray *data;

@end
@interface JSCircleListData : NSObject

@property (nonatomic, copy) NSString *article_category_id;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) NSString *display;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *thumb_img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *like_count;

@property (nonatomic, copy) NSString *comment_count;

@property (nonatomic, copy) NSString *article_id;

@end

