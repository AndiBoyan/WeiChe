//
//  mapViewController.m
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "mapViewController.h"
#import "CustomAnnotation.h"
#import <math.h>

@interface mapViewController ()
{
    MAPointAnnotation *pointAnnotation;
}
@end

@implementation mapViewController

@synthesize annotations = _annotations;

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        if (annotationView == nil)
        {
            
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        //double angle = [self LoctionAngle:0 startLon:0 endLat:1 endLon:1];
       // NSLog(@"%f",angle);
        //annotationView.transform = CGAffineTransformMakeRotation(angle);
        annotationView.canShowCallout = YES;
        annotationView.transform = CGAffineTransformRotate(annotationView.transform, M_PI/8.0);
        annotationView.image = [UIImage imageNamed:@"mucar.png"];
        annotationView.draggable = YES;
        //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    [navigationItem setTitle:@"爱车位置"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];

    /*map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 568)];
    map.showsUserLocation = YES;
    map.mapType = MKMapTypeStandard;
    [self.view addSubview:map];
    if([CLLocationManager locationServicesEnabled]){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
        // // 提示用户是否允许当前应用使用地理位置，已过时，在Info.plist中使用NSLocationUsageDescription键值替换
        // self.myLocationManager.purpose = @"提示用户是否允许当前应用使用位置，已过时";
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的位置服务当前不可用，请打开位置服务后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }*/
    [MAMapServices sharedServices].apiKey = @"93f19ee3f3184d7d1180ecb87be8c134";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 65, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-65)];
    _mapView.delegate = self;
   // _mapView.showsUserLocation = YES;
    //_mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:16.1 animated:YES];
   
    [self.view addSubview:_mapView];
    slon = 0.0f;
    slat = 0.0f;
    lastAngle = 0.0f;
    //[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(locationPoint) userInfo:nil repeats:YES];
    pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(23.098155, 113.347285);
     [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(23.098155, 113.347285) animated:YES];
    pointAnnotation.title = @"我的爱车";
    
    [_mapView addAnnotation:pointAnnotation];
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        //[mapView removeAnnotation:pointAnnotation];
       
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        pointAnnotation.title = @"我的爱车";
        //pointAnnotation.subtitle = @"阜通东大街6号";
        
        
        [_mapView addAnnotation:pointAnnotation];
    }
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*-(void)locationPoint
{
    //获取从服务器得到的汽车经纬度数据

    elat = 23.100578;
    elon = 113.341761;
    if ((elon != 0.0f)&&(elat != 0.0f)) {
        [map removeOverlays:map.overlays];
        [map removeAnnotations:map.annotations];//移除地图上的大头针
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(elat,elon);
        float zoomLevel = 0.02;
        MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
        [map setRegion:[map regionThatFits:region] animated:YES];
        map.delegate = self;
        [self createAnnotationWithCoords:coords];//将新的位置添加到地图上
    }
}*/
/*-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Latitude=%f",newLocation.coordinate.latitude);
    //NSLog(@"Longitude=%f",newLocation.coordinate.longitude);
    elat = newLocation.coordinate.latitude;
    elon = newLocation.coordinate.longitude;
    [map removeOverlays:map.overlays];
    [map removeAnnotations:map.annotations];//移除地图上的大头针
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(elat,elon);
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [map setRegion:[map regionThatFits:region] animated:YES];
    map.delegate = self;
    [self createAnnotationWithCoords:coords];//将新的位置添加到地图上
}

-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    if ([[annotation title] isEqualToString:@"爱车位置"]) {
        newAnnotation.image = [UIImage imageNamed:@"mucar.png"];
        double angle = [self LoctionAngle:slat startLon:slon endLat:elat endLon:elon];
        newAnnotation.transform = CGAffineTransformMakeRotation(angle);
        slon = elon;
        slat = elat;
    }
    newAnnotation.canShowCallout=YES;
    return newAnnotation;
}

//添加地图大头针
-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords {
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:coords];
    annotation.title = @"爱车位置";
    [map addAnnotation:annotation];
}
*/
//计算大头针偏移角度
-(double)LoctionAngle:(float)startlat startLon:(float)startlon endLat:(float)endlat endLon:(float)endlon
{
    float lat = endlat - startlat;
    float lon = endlon - startlon;
    
    double cosAngle;
    //如果位置没有发生改变，就保持原来的角度不变
    if (sqrt(lat*lat+lon*lon) == 0) {
        cosAngle = lastAngle;
    }
    else
    {
        float angle = lon/sqrt(lat*lat+lon*lon);
        cosAngle = acos(angle);
        if (lat < 0) {
            cosAngle = cosAngle + M_PI/2;
        }
        //记录上一次的角度
        lastAngle = cosAngle;
    }
    return cosAngle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
