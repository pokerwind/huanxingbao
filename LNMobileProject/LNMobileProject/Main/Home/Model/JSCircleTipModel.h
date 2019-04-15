//
//Created by ESJsonFormatForMac on 19/01/28.
//

#import <Foundation/Foundation.h>

@class JSCircleTipData;
@interface JSCircleTipModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) NSArray *data;

@end
@interface JSCircleTipData : NSObject

@property (nonatomic, copy) NSString *article_category_id;

@property (nonatomic, copy) NSString *display;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sort;

@end

