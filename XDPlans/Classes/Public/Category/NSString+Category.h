//
//  NSString+Category.h
//  XDUI
//
//  Created by xieyajie on 13-10-25.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

- (NSString *)formattedURLPath;             //添加http前缀

//- (XDAccountGender)genderInfo;            //解析头像路径，获取性别信息

//- (NSString *)formattedHeadPath;            //解析头像图片缩略图路径
- (NSString *)headPathFormatThumbnailSize;  //头像缩略图路径
- (NSString *)headPathFormatNormalSize;     //头像中图路径
- (NSString *)headPathFormatBigSize;        //头像大图路径
- (NSString *)headPathFormatOriginalSize;   //头像原图路径

//- (NSString *)formattedImagePath;                               //解析图片路径
//- (NSString *)formattedImagePathWithAppType:(NSInteger)appType; //解析图片路径，区分图片服务器
//- (NSString *)imagePathWithWidth:(CGFloat)width;                //定宽图片路径
//- (NSString *)imagePathFormatThumbnailSize;                     //图片缩略图路径
//- (NSString *)imagePathFormatNormalSize;                        //图片中图路径
//- (NSString *)imagePathFormatBigSize;                           //图片大图路径
- (NSString *)imagePathFormatOriginalSize;                      //图片原图路径
//- (NSString *)imagePathFormatCustomSize:(CGFloat)width;         //自定义大小图片路径

- (NSString *)documentFilePath;             //转换为沙箱Documents文件夹下的路径
- (BOOL)isDocumentFilePath;                 //是否为沙箱Documents文件夹下的路径

- (NSString *)substringWithMaxLength:(NSUInteger)maxLength;

- (NSString *)trimmedString;                //去除空格、换行和\r\n
- (NSString *)UTF8EncodedString;            //编码UTF8字符串
- (NSString *)GBKEncodedString;             //编码GBK字符串，并处理常见URL特殊字符
- (NSString *)MD5EncodedString;             //编码MD5字符串
- (NSString *)numberString;                 //转换为T9数字键盘对应的数字串

- (NSString *)formattedPhone;               //格式化手机号码
- (BOOL)isValidPhone;                       //是否为合法手机号
- (BOOL)isValidEmail;                       //是否为合法邮箱地址
- (BOOL)isValidImageURL;                    //是否为合法图片路径
- (BOOL)isValidVideoURL;                    //是否为合法视频路径
- (BOOL)isValidAudioURL;                    //是否为合法音频路径

- (NSString *)distanceDescription;          //距离描述(米)

@end
