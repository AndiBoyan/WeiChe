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

@end

@implementation mapViewController

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

    map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 568)];
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
    }
   slon = 0.0f;
    slat = 0.0f;
    lastAngle = 0.0f;
    //[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(locationPoint) userInfo:nil repeats:YES];
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)locationPoint
{
    //获取从服务器得到的汽车经纬度数据

    elat = 23.397933;
    elon = 113.255178;
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
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Latitude=%f",newLocation.coordinate.latitude);
    //NSLog(@"Longitude=%f",newLocation.coordinate.longitude);
    elat = newLocation.coordinate.latitude;
    elon = newLocation.coordinate.longitude;
    [map removeOverlays:map.overlays];
    [map removeAnnotations:map.annotations];//移除地图上的大头针
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(elat,elon);
    float zoomLevel = 0.02;
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
