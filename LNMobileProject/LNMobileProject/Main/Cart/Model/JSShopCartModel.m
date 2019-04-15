//
//Created by ESJsonFormatForMac on 19/02/12.
//

#import "JSShopCartModel.h"
@implementation JSShopCartModel

@end

@implementation JSShopCartData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [JSShopCartList class]};
}

@end


@implementation JSShopCartList

+ (NSDictionary *)objectClassInArray{
    return @{@"goods" : [JSShopCartGoods class]};
}

@end


@implementation JSShopCartGoods

@end


