//
//  XDWeatherManager.m
//  XDPlans
//
//  Created by xie yajie on 13-9-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "XDWeatherManager.h"

#import "XDPlanLocalDefault.h"

static XDWeatherManager *weatherManager = nil;

typedef void (^XDFinish)(BOOL finish);
#define kQQWebServiceURLStr @"http://fw.qq.com/ipaddress"
#define kWeatherServiceURLStr @"http://webservice.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName?theCityName="

@interface XDWeatherManager()
{
    NSString *_fullCityName;
    NSString *_simpleCityName;
    XDFinish _completion;
}

@end

@implementation XDWeatherManager

//public
@synthesize weatherInfo = _weatherInfo;

+ (id)shareWeather
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weatherManager = [[XDWeatherManager alloc] init];
    });
    
    return weatherManager;
}

#pragma mark - get

- (NSMutableDictionary *)weatherInfo
{
    if (_weatherInfo == nil) {
        _weatherInfo = [NSMutableDictionary dictionary];
    }
    
    return _weatherInfo;
}

- (void)updateWeatherInfoWithCompletion:(void (^)(BOOL finish))completion
{
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        completion(NO);
        NSLog(@"您关闭了的定位功能，将无法收到位置信息，建议您到系统设置打开定位功能!");
        return;
    }
    
    NSStringEncoding chineseEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	NSString *ipAddressInfo = [NSString stringWithContentsOfURL:[NSURL URLWithString:kQQWebServiceURLStr] encoding:chineseEncoding error:nil];
    // 解析出省份、城市
	// 注意：如果市上海直辖市，只有5里面有值
	if (ipAddressInfo != nil) {
		NSArray *infoArray = [ipAddressInfo componentsSeparatedByString:@"\""];
		if ([infoArray count] > 7) {
			// 无数据
			if (0 == [[infoArray objectAtIndex:5] length]
				&& 0 == [[infoArray objectAtIndex:7] length]) {
				// 设置默认的城市名
				_fullCityName = @"北京市";
				_simpleCityName = @"北京";
			}
			// 直辖市
			else if (0 != [[infoArray objectAtIndex:5] length]
					 && 0 == [[infoArray objectAtIndex:7] length]) {
				// 设置默认的城市名
				_fullCityName = [infoArray objectAtIndex:5];
				_simpleCityName = _fullCityName;
                
				// 剔除后缀“市” 如：上海市
				if ([_simpleCityName hasSuffix:@"市"]) {
					_simpleCityName = [_simpleCityName substringToIndex:_simpleCityName.length-1];
					NSLog(@"str = %@", _simpleCityName);
				}
			}
			else if (0 == [[infoArray objectAtIndex:5] length]
					 && 0 != [[infoArray objectAtIndex:7] length]) {
				// 设置默认的城市名
				_fullCityName = [infoArray objectAtIndex:7];
				_simpleCityName = _fullCityName;
				
				// 剔除后缀“市” 如：上海市
				if ([_simpleCityName hasSuffix:@"市"]) {
					_simpleCityName = [_simpleCityName substringToIndex:_simpleCityName.length-1];
					NSLog(@"str = %@", _simpleCityName);
				}
			}
			// 省市
			else {
				_fullCityName = [NSString stringWithFormat:@"%@%@", [infoArray objectAtIndex:5], [infoArray objectAtIndex:7]];
				_simpleCityName = [infoArray objectAtIndex:7];
				
				// 剔除后缀“市”
				if ([_simpleCityName hasSuffix:@"市"]) {
					_simpleCityName = [_simpleCityName substringToIndex:_simpleCityName.length-1];
					NSLog(@"str = %@", _simpleCityName);
				}
			}
		}
	}
    
    NSString *weatherRequestUrlStr = [NSString stringWithFormat:@"%@%@",kWeatherServiceURLStr,[_simpleCityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *weatherReponseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:weatherRequestUrlStr]];
}

@end
