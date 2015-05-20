//
//  loadInfoViewController.h
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
// 行车轨迹

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface loadInfoViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    // the map view
    MKMapView* _mapView;
    
    // routes points
    NSMutableArray* _points;
    
    // the data representing the route points.
    MKPolyline* _routeLine;
    
    // the view we create for the line on the map
    MKPolylineView* _routeLineView;
    
    // the rect that bounds the loaded points
    MKMapRect _routeRect;
    
    // location manager
    CLLocationManager* _locationManager;
    
    // current location
    CLLocation* _currentLocation;
    
}

@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) NSMutableArray* points;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, strong) NSMutableArray *gpsArray;

@end
