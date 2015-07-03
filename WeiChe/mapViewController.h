//
//  mapViewController.h
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MAMapKit/MAMapKit.h>

@interface mapViewController : UIViewController<MAMapViewDelegate>
{
    MAMapView *_mapView;
    float slon;
    float slat;
    float elat;
    float elon;
    float lastAngle;
}
@property (nonatomic, strong) NSMutableArray *annotations;

@end
