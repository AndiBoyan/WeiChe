//
//  mapViewController.h
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface mapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    MKMapView *map;
    CLLocationManager *locationManager;
    float slon;
    float slat;
    float elat;
    float elon;
    float lastAngle;
}
@end
