//
//  safeViewController.m
//  WeiChe
//
//  Created by icePhoenix on 15/5/15.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "safeViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CommonUtility.h"

@interface safeViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}
@end

@implementation safeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    [navigationItem setTitle:@"电子栏珊"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    //把导航栏添加到视图中
    [self.view addSubview:navigationBar];
    [self drawGaodeMap];
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawGaodeMap
{
    [MAMapServices sharedServices].apiKey = @"93f19ee3f3184d7d1180ecb87be8c134";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"93f19ee3f3184d7d1180ecb87be8c134" Delegate:self];
    
    //构造AMapDistrictSearchRequest对象，keywords为必选项
    AMapDistrictSearchRequest *districtRequest = [[AMapDistrictSearchRequest alloc] init];
    districtRequest.keywords = @"广州市";
    districtRequest.requireExtension = YES;
    
    //发起行政区划查询
    [_search AMapDistrictSearch:districtRequest];
}
#pragma mark - Helpers

- (void)handleDistrictResponse:(AMapDistrictSearchResponse *)response
{
    if (response == nil)
    {
        return;
    }
    
    for (AMapDistrict *dist in response.districts)
    {
        MAPointAnnotation *poiAnnotation = [[MAPointAnnotation alloc] init];
        
        poiAnnotation.coordinate = CLLocationCoordinate2DMake(dist.center.latitude, dist.center.longitude);
        poiAnnotation.title      = dist.name;
        poiAnnotation.subtitle   = dist.adcode;
        
        // [_mapView addAnnotation:poiAnnotation];
        
        if (dist.polylines.count > 0)
        {
            MAMapRect bounds = MAMapRectZero;
            
            for (NSString *polylineStr in dist.polylines)
            {
                MAPolyline *polyline = [CommonUtility polylineForCoordinateString:polylineStr];
                [_mapView addOverlay:polyline];
                
                bounds = MAMapRectUnion(bounds, polyline.boundingMapRect);
            }
            
            [_mapView setVisibleMapRect:bounds animated:YES];
        }
        
        // sub
        for (AMapDistrict *subdist in dist.districts)
        {
            MAPointAnnotation *subAnnotation = [[MAPointAnnotation alloc] init];
            
            subAnnotation.coordinate = CLLocationCoordinate2DMake(subdist.center.latitude, subdist.center.longitude);
            subAnnotation.title      = subdist.name;
            subAnnotation.subtitle   = subdist.adcode;
            
            //[_mapView addAnnotation:subAnnotation];
        }
    }
}

- (void)searchDistrictWithName:(NSString *)name
{
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = name;
    dist.requireExtension = YES;
    
    [_search AMapDistrictSearch:dist];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *busStopIdentifier = @"districtIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:busStopIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        return poiAnnotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4.f;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    NSLog(@"response: %@", response);
    [self handleDistrictResponse:response];
}

@end
