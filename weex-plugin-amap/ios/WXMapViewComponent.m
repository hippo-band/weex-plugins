//
//  WXMapViewComponent.m
//  WeexDemo
//
//  Created by guibao on 2016/12/16.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import "WXMapViewComponent.h"

@interface WXMapViewComponent()

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation WXMapViewComponent
{
    CLLocationCoordinate2D _centerCoordinate;
    CGFloat _zoomLevel;
    BOOL _showScale;
    BOOL _showGeolocation;
}


- (instancetype)initWithRef:(NSString *)ref
                       type:(NSString*)type
                     styles:(nullable NSDictionary *)styles
                 attributes:(nullable NSDictionary *)attributes
                     events:(nullable NSArray *)events
               weexInstance:(WXSDKInstance *)weexInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        _centerCoordinate.latitude = [attributes[@"center"][1] doubleValue];
        _centerCoordinate.longitude = [attributes[@"center"][0] doubleValue];
        _zoomLevel = [attributes[@"zoom"] floatValue];
        _showScale = [attributes[@"scale"] boolValue];
        _showGeolocation = [attributes[@"geolocation"] boolValue];
        
    }
    
    return self;
}

- (UIView *) loadView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGSize windowSize = window.rootViewController.view.frame.size;
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height)];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    return self.mapView;
}

- (void)viewDidLoad
{
    self.mapView.showsScale = _showScale;
    [self.mapView setCenterCoordinate:_centerCoordinate];
    [self.mapView setZoomLevel:_zoomLevel];
}

- (void)layoutDidFinish
{
    
}

- (void)viewWillUnload
{
    
}

- (void)dealloc
{
    
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"center"] ) {
        CLLocationCoordinate2D centerCoordinate;
        centerCoordinate.latitude = [attributes[@"center"][1] doubleValue];
        centerCoordinate.longitude = [attributes[@"center"][0] doubleValue];
        [self.mapView setCenterCoordinate:centerCoordinate];
    }
}

- (void)addEvent:(NSString *)eventName
{
    
}

- (void)removeEvent:(NSString *)eventName
{
    
}


@end
