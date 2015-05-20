//
//  ViewController.m
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//
//155154150
#import "ViewController.h"
#import "OBShapedButton.h"
#import "ControlViewController.h"
#import "mapViewController.h"
#import "loadViewController.h"
#import "safeViewController.h"

@interface ViewController ()
{
    UILabel *lab;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    [super viewDidLoad];
    geoCoder=[[CLGeocoder alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *imageIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageIV.image = [UIImage imageNamed:@"mainbackground.png"];
    [self.view addSubview:imageIV];
    //天气界面
    [self drawObshapedButton:CGRectMake(20, 150, 88.5, 88.5) tag:2000 image:@"wearth.png"];
    //地图界面
    [self drawObshapedButton:CGRectMake(111, 150, 88.5, 88.5) tag:1001 image:@"map.png"];
    //轨迹界面
    [self drawObshapedButton:CGRectMake(20, 241, 88.5, 88.5) tag:1002 image:@"load.png"];
    //控制
    [self drawObshapedButton:CGRectMake(111, 241, 173.5 ,173.5) tag:1003 image:@"control.png"];
    
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
    
    lab = [[UILabel alloc]initWithFrame:CGRectMake(120, 300, 150, 40)];
    lab.font = [UIFont systemFontOfSize:10.0f];
    lab.textColor = [UIColor colorWithRed:0.6078 green:0.6039 blue:0.5882 alpha:1.0f];
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.numberOfLines = 0;
    [self.view addSubview:lab];
    UIImageView *iv1= [[UIImageView alloc]initWithFrame:CGRectMake(13, 460, 54, 68)];
    iv1.image = [UIImage imageNamed:@"1.png"];
    [self.view addSubview:iv1];
    UIImageView *iv2= [[UIImageView alloc]initWithFrame:CGRectMake(93, 460, 54, 68)];
    iv2.image = [UIImage imageNamed:@"2.png"];
    [self.view addSubview:iv2];
    UIImageView *iv3= [[UIImageView alloc]initWithFrame:CGRectMake(173, 460, 54, 68)];
    iv3.image = [UIImage imageNamed:@"3.png"];
    [self.view addSubview:iv3];
    UIImageView *iv4= [[UIImageView alloc]initWithFrame:CGRectMake(253, 460, 54, 68)];
    iv4.image = [UIImage imageNamed:@"4.png"];
    [self.view addSubview:iv4];
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 520, 80, 40)];
    lab1.text = @"人保车险";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:14.0f];
    lab1.textColor = [UIColor whiteColor];
    [self.view addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(80, 520, 80, 40)];
    lab2.text = @"人保车贷";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:14.0f];
    lab2.textColor = [UIColor whiteColor];
    [self.view addSubview:lab2];
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(160, 520, 80, 40)];
    lab3.text = @"估价卖车";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.font = [UIFont systemFontOfSize:14.0f];
    lab3.textColor = [UIColor whiteColor];
    [self.view addSubview:lab3];
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(240, 520, 80, 40)];
    lab4.text = @"今日行驶";
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.font = [UIFont systemFontOfSize:14.0f];
    lab4.textColor = [UIColor whiteColor];
    [self.view addSubview:lab4];
   
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Latitude=%f",newLocation.coordinate.latitude);
    //NSLog(@"Longitude=%f",newLocation.coordinate.longitude);
    [self getAddressByLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
}
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        //NSLog(@"详细信息:%@",placemark.addressDictionary);
        lab.text = [placemark.addressDictionary objectForKey:@"Name"];
        self.address = lab.text;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark OBShapedButton

//绘制不规则按钮

-(void)drawObshapedButton:(CGRect)frame tag:(int)tag image:(NSString*)imageName
{
    OBShapedButton *obshapeButton = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    obshapeButton.frame = frame;
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *imageBtn = [image stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obshapeButton setBackgroundImage:imageBtn forState:UIControlStateNormal];//定义背景图片
    obshapeButton.tag = tag;
    obshapeButton.backgroundColor = [UIColor clearColor];
    [obshapeButton addTarget:self action:@selector(obsapedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:obshapeButton];
}

//不规则按钮响应事件
-(void)obsapedButtonAction:(id)sender
{

    OBShapedButton *button = (OBShapedButton*)sender;
    switch (button.tag) {
        case 1000:
        {
             //控制界面
            ControlViewController *controlVc = [[ControlViewController alloc]init];
            controlVc.address = self.address;
            [self presentViewController:controlVc animated:YES completion:nil];
        }
            break;
        case 1001:
        {
            //地图界面
            mapViewController *mapVc = [[mapViewController alloc]init];
            [self presentViewController:mapVc animated:YES completion:nil];
        }
            break;
        case 1002:
        {
            //轨迹界面
            loadViewController *loadVc = [[loadViewController alloc]init];
            [self presentViewController:loadVc animated:YES completion:nil];
        }
            break;
        case 1003:
        {
            //电子栏栅
            safeViewController *safeVc = [[safeViewController alloc]init];
            [self presentViewController:safeVc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


@end
