//
//  XDManagerHelper.m
//  XDPlans
//
//  Created by xieyajie on 13-9-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDManagerHelper.h"
#import "WantPlan.h"

static XDManagerHelper *helper = nil;

@interface XDManagerHelper()

@property (nonatomic, strong) NSArray *weeksArray;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *y_mFormatter;
@property (nonatomic, strong) NSDateFormatter *ymdFormatter;

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation XDManagerHelper

@synthesize weeksArray = _weeksArray;
@synthesize calendar = _calendar;
@synthesize y_mFormatter = _y_mFormatter;
@synthesize ymdFormatter = _ymdFormatter;

@synthesize datePicker = _datePicker;

+ (id)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[XDManagerHelper alloc] init];
    });
    
    return helper;
}

#pragma mark - get

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
    }
    
    return _datePicker;
}

- (WantPlan *)actionPlan
{
    if (_actionPlan == nil) {
        NSArray *actionPlans = [WantPlan MR_findByAttribute:@"action" withValue:[NSNumber numberWithBool:YES]];
        if (actionPlans && [actionPlans count] > 0) {
            _actionPlan = [actionPlans objectAtIndex:0];
        }
        else{
            _actionPlan = nil;
        }
    }
    
    return _actionPlan;
}

#pragma mark - set


#pragma mark - 正则表达式 验证格式

//电话号码匹配
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//邮箱匹配
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRg = @"^[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\\w\\.-]*[a-zA-Z0-9]\\.[a-zA-Z][a-zA-Z\\.]*[a-zA-Z]$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRg];
    
    if ([regextestcm evaluateWithObject:email]) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark - 转换tag值

static int tagBase = 100;

+ (NSInteger)tagCompileWithInteger:(NSInteger)integer
{
    return (100 + integer);
}

+ (NSInteger)tagDecompileWithInteger:(NSInteger)integer
{
    return (integer - tagBase);
}

#pragma mark - 图片混合

+ (UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor
{
    UIGraphicsBeginImageContext(baseImage.size);//创建一个基于位图的图形上下文并使其成为当前上下文。
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//返回  当前图形上下文
    //这里取到的不是UIImageView类型的,况且也没有UIImageView那个东西..这里取到的是UIImage对应的赋值给它的那个图片的大小...
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);//改变用户的规模坐标系统....(X.Y)..
    CGContextTranslateCTM(ctx, 0, -area.size.height);//更改用户的上下文中的坐标原点系统。
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeColorBurn);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 时间转换

- (NSArray *)weeksArray
{
    if (_weeksArray == nil) {
        _weeksArray = [[NSArray alloc] initWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    }
    
    return _weeksArray;
}

- (NSCalendar *)calendar
{
    if (_calendar == nil) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        /*
         设定每周的第一天从星期几开始，比如:
         .  如需设定从星期日开始，则value传入1
         .  如需设定从星期一开始，则value传入2
         */
        [_calendar setFirstWeekday:2];
    }
    
    return _calendar;
}

- (NSDateFormatter *)y_mFormatter
{
    if (_y_mFormatter == nil) {
        _y_mFormatter = [[NSDateFormatter alloc] init];
        _y_mFormatter.dateFormat = @"yyyy-MM";
    }
    
    return _y_mFormatter;
}

- (NSDateFormatter *)ymdFormatter
{
    if (_ymdFormatter == nil) {
        _ymdFormatter = [[NSDateFormatter alloc] init];
        _ymdFormatter.dateFormat = @"yyyyMMDD";
    }
    
    return _ymdFormatter;
}

- (NSInteger)dayForDate:(NSDate *)date
{
    NSDateComponents *component = [self.calendar components:NSDayCalendarUnit fromDate:date];
    return [component day];
}

- (NSString *)weekForDate:(NSDate *)date
{
    NSDateComponents *component = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger week = [component weekday] - 1;
    return [self.weeksArray objectAtIndex:week];
}

- (NSInteger)monthForDate:(NSDate *)date
{
    NSDateComponents *component = [self.calendar components:NSMonthCalendarUnit fromDate:date];
    return [component month];
}

- (NSInteger)yearForDate:(NSDate *)date
{
    NSDateComponents *component = [self.calendar components:NSYearCalendarUnit fromDate:date];
    return [component year];
}

- (NSString *)year_monthForDate:(NSDate *)date
{
    return [self.y_mFormatter stringFromDate:date];
}

- (NSString *)ymdForDate:(NSDate *)date
{
    return [self.ymdFormatter stringFromDate:date];
}

#pragma mark - 显示菜单
- (void)showMenuToViewController:(UIViewController *)viewController completion: (void (^)(NSDate *))completion
{
    
}

#pragma mark - 显示datePicker
- (void)showDatePickerToViewController:(UIViewController *)viewController completion: (void (^)(NSDate *))completion
{
    self.datePicker.datePickerMode = UIDatePickerModeDate;
}

@end
