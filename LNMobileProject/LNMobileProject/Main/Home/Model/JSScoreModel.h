//
//Created by ESJsonFormatForMac on 19/01/28.
//

#import <Foundation/Foundation.h>

@class JSScoreData,JSScoreList;
@interface JSScoreModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) JSScoreData *data;

@end
@interface JSScoreData : NSObject

@property (nonatomic, copy) NSString *user_score;

@property (nonatomic, strong) NSArray *list;

@end

@interface JSScoreList : NSObject

@property (nonatomic, copy) NSString *act_id;

@property (nonatomic, copy) NSString *goods_score;

@property (nonatomic, copy) NSString *shop_price;

@property (nonatomic, copy) NSString *goods_price;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, assign) NSInteger btn;
@property(nonatomic,strong) NSString *goods_img;
@property (nonatomic, copy) NSString *goods_id;

@end

