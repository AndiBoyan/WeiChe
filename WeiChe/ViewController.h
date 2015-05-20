//
//  ViewController.h
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;// 位置管理器
    CLGeocoder *geoCoder ;// 地理位置和真实地址转换
}
@property(strong, nonatomic) NSString *address;

@end

