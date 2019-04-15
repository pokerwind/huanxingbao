//
//  SingleLocationViewController.h
//  officialDemoLoc
//
//  Created by 刘博 on 15/9/21.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
typedef void (^SingleLocationBlock)(NSString *city);
@interface SingleLocationViewController : LNBaseVC

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

/*
 * SingleLocationBlock
 */
@property (nonatomic,copy)SingleLocationBlock block;

@end
