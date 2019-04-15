//
//  DZAddressSelectionVC.m
//  LNMobileProject
//
//  Created by 童浩 on 2019/2/26.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "DZAddressSelectionAVC.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationManager.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface DZAddressSelectionAVC ()<AMapSearchDelegate,MAMapViewDelegate>

//定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
//地图
@property (nonatomic, strong) MAMapView *mapView;
//大头针
@property (nonatomic, strong) MAPointAnnotation *annotation;
//逆地理编码
@property (nonatomic, strong) AMapReGeocodeSearchRequest *regeo;
//逆地理编码使用的
@property (nonatomic, strong) AMapSearchAPI *search;


@property(nonatomic,strong) UILabel *addLabel;
@property(nonatomic,strong) UIBarButtonItem *rightItem;
@property(nonatomic,strong) NSString *lat; //纬度
@property(nonatomic,strong) NSString *lng; //经度
@property(nonatomic,strong) NSString *adds;
@end

@implementation DZAddressSelectionAVC
#pragma mark - --- getters 和 setters ----
- (UIBarButtonItem *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
        _rightItem.tintColor = HEXCOLOR(0x333333);
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [_rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateSelected];
    }
    return _rightItem;
}
- (void)rightItemAction {
    if (self.block) {
        self.block(self.lat, self.lng, self.adds);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地图定位";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    self.addLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, 40)];
    self.addLabel.numberOfLines = 0;
    self.addLabel.textColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:217/255.0 alpha:1];
    self.addLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.addLabel];
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight - 40)];
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
//    _mapView.showsScale = NO;
    //定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            return ;
        }
        //添加大头针
        _annotation = [[MAPointAnnotation alloc]init];
        
        _annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [_mapView addAnnotation:_annotation];
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) animated:YES];
        //让地图在缩放过程中移到当前位置试图
        [_mapView setZoomLevel:16.1 animated:YES];
        
    }];
}
#pragma mark - 让大头针不跟着地图滑动，时时显示在地图最中间
- (void)mapViewRegionChanged:(MAMapView *)mapView {
    _annotation.coordinate = mapView.centerCoordinate;
}
#pragma mark - 滑动地图结束修改当前位置
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.regeo.location = [AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    self.lat = [NSString stringWithFormat:@"%lf",mapView.centerCoordinate.latitude];
    self.lng = [NSString stringWithFormat:@"%lf",mapView.centerCoordinate.longitude];

    [self.search AMapReGoecodeSearch:self.regeo];
}
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        AMapReGeocode *reocode = response.regeocode;
        //地图标注的点的位置信息全在reoceode里面了
        self.addLabel.text = reocode.formattedAddress;
        self.adds = self.addLabel.text;
    }
}


//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
//
//    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
//        static NSString *reuseIdetifier = @"annotationReuseIndetifier";
//        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdetifier];
//        if (annotationView == nil) {
//            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdetifier];
//        }
//        //放一张大头针图片即可
//        annotationView.image = [UIImage imageNamed:@"icon_location"];
//        annotationView.centerOffset = CGPointMake(0, -18);
//        return annotationView;
//    }
//
//    return nil;
//}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc]init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locationManager.locationTimeout = 2;
        _locationManager.reGeocodeTimeout = 2;
    }
    return _locationManager;
}

- (AMapReGeocodeSearchRequest *)regeo {
    if (!_regeo) {
        _regeo = [[AMapReGeocodeSearchRequest alloc]init];
        _regeo.requireExtension = YES;
    }
    return _regeo;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate = self;
    }
    return _search;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
