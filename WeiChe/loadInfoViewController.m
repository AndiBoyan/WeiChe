//
//  loadInfoViewController.m
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "loadInfoViewController.h"
#import "CustomAnnotation.h"

@interface loadInfoViewController ()

@end

@implementation loadInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    [navigationItem setTitle:@"我的足迹"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 510)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
    
    [self drawTestLine];
    
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)drawTestLine
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.gpsArray.count/2; i++) {
        NSString *latStr = [self.gpsArray objectAtIndex:2*i];
        NSString *logStr = [self.gpsArray objectAtIndex:2*i+1];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latStr.floatValue longitude:logStr.floatValue];
        [array addObject:location];
    }
    [self drawLineWithLocationArray:array];
    int gpsCount = (int)self.gpsArray.count;
    NSString *latStr1 = [self.gpsArray objectAtIndex:0];
    NSString *logStr1 = [self.gpsArray objectAtIndex:1];
    NSString *latStr2 = [self.gpsArray objectAtIndex:gpsCount-2];
    NSString *logStr2 = [self.gpsArray objectAtIndex:gpsCount-1];
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(latStr1.floatValue,logStr1.floatValue);
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(latStr2.floatValue,logStr2.floatValue);
    
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:
                                    coords1];
    annotation.title = @"起点";
    [self.mapView addAnnotation:annotation];
    CustomAnnotation *annotation1 = [[CustomAnnotation alloc] initWithCoordinate:
                                     coords2];
    annotation1.title = @"终点";
    [self.mapView addAnnotation:annotation1];
}

-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    if ([[annotation title] isEqualToString:@"起点"]) {
        newAnnotation.image = [UIImage imageNamed:@"location_icon_start.png"];
    }
    if ([[annotation title] isEqualToString:@"终点"]) {
        newAnnotation.image = [UIImage imageNamed:@"location_icon_end.png"];
        
    }
    
    newAnnotation.canShowCallout=YES;
    return newAnnotation;
}

#pragma mark -

- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = (int)[locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    [self.mapView addOverlay:self.routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine) {
        if(nil == self.routeLineView) {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
        }
        return self.routeLineView;
    }
    return nil;
}


@end
