//
//  XDWeatherManager.h
//  XDPlans
//
//  Created by xie yajie on 13-9-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDWeatherManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *weatherInfo;

+ (id)shareWeather;

- (void)updateWeatherInfoWithCompletion:(void (^)(BOOL finish))completion;

@end
