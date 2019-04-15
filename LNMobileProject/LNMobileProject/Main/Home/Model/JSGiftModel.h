//
//Created by ESJsonFormatForMac on 19/01/28.
//

#import <Foundation/Foundation.h>

@class JSGiftData,JSGiftList;
@interface JSGiftModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) JSGiftData *data;

@end
@interface JSGiftData : NSObject

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSArray *list;

@end

@interface JSGiftList : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *add_time;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *price;

@end

