//
//Created by ESJsonFormatForMac on 19/01/28.
//

#import <Foundation/Foundation.h>

@class JSFreeData,JSFreeList;
@interface JSFreeModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) JSFreeData *data;

@end
@interface JSFreeData : NSObject

@property (nonatomic,copy)NSString *desc;

@property (nonatomic, strong) NSArray *list;

@end

@interface JSFreeList : NSObject

@property (nonatomic, copy) NSString *act_id;

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *free_test_day;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *cash_pledge;

/*
 * goods_img
 */
@property (nonatomic,copy)NSString *goods_img;

@end

