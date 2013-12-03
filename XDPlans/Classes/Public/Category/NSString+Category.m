
#import "NSString+Category.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Category)

/*添加http前缀*/
- (NSString *)formattedURLPath
{
    NSURL *url = [NSURL URLWithString:self];
    if (!url.scheme.length) {
        return [NSString stringWithFormat:@"http://%@", self];
    }
    return self;
}

///*解析头像路径，获取性别信息*/
//- (TIXAContactGender)genderInfo
//{
//    if ([self hasSuffix:@"default2.png"]) {
//        return TIXAContactGenderFemale;
//    }
//    return TIXAContactGenderMale;
//}
//
///*解析头像图片缩略图路径*/
//- (NSString *)formattedHeadPath
//{
//    if (!self.length || [self hasSuffix:@"default.jpg"] || [self hasSuffix:@"default1.png"] || [self hasSuffix:@"default2.png"]) {
//        return nil;
//    }
//    
//    NSString *headPath = self;
//    if ([headPath hasPrefix:@"/opt"]) {
//        headPath = [headPath substringFromIndex:3];
//    }
//    if (![headPath hasPrefix:@"http"]) {
//        headPath = [NSString stringWithFormat:@"http://%@%@", [[DataManager defaultManager] picDomain], headPath];
//    }
//    return [headPath stringByReplacingOccurrencesOfString:@"_1" withString:@"_2"];
//}

/*头像缩略图路径*/
- (NSString *)headPathFormatThumbnailSize
{
//    return self;
    return self.headPathFormatNormalSize;//提高画质，用中图取代缩略图
}

/*头像中图路径*/
- (NSString *)headPathFormatNormalSize
{
    return [self stringByReplacingOccurrencesOfString:@"_2" withString:@"_3"];
}

/*头像大图路径*/
- (NSString *)headPathFormatBigSize
{
    return [self stringByReplacingOccurrencesOfString:@"_2" withString:@"_1"];
}

/*头像原图路径*/
- (NSString *)headPathFormatOriginalSize
{
    return [self stringByReplacingOccurrencesOfString:@"_2" withString:@"_0"];
}

/*解析图片路径*/
//- (NSString *)formattedImagePath
//{
//    return [self formattedImagePathWithAppType:0];
//}
//
///*解析图片路径，区分图片服务器*/
//- (NSString *)formattedImagePathWithAppType:(NSInteger)appType
//{
//    if (!self.length) {
//        return nil;
//    }
//    
//    NSString *imagePath = self;
//    if ([imagePath hasPrefix:@"/opt"]) {
//        imagePath = [imagePath substringFromIndex:4];
//    }
//    if (![imagePath hasPrefix:@"http"]) {
//        if (appType == 16 || appType == 1601) {
//            imagePath = [NSString stringWithFormat:@"http://%@%@", [[DataManager defaultManager] picDomain], imagePath];
//        } else {
//            imagePath = [NSString stringWithFormat:@"http://%@%@", WEB_DOMAIN, imagePath];
//        }
//    }
//    return imagePath;
//}
//
///*指定宽图片路径*/
//- (NSString *)imagePathWithWidth:(CGFloat)width
//{
//    return [NSString stringWithFormat:@"http://%@/api/image/showImageBySize.jsp?url=%@&width=%f", WEB_DOMAIN, self, width];
//}
//
///*图片缩略图路径*/
//- (NSString *)imagePathFormatThumbnailSize
//{
//    return [NSString stringWithFormat:@"http://%@/api/image/showImageBySize.jsp?url=%@&width=240", WEB_DOMAIN, self];
//}
//
///*图片中图路径*/
//- (NSString *)imagePathFormatNormalSize
//{
//    return [NSString stringWithFormat:@"http://%@/api/image/showImageBySize.jsp?url=%@&width=640", WEB_DOMAIN, self];
//}
//
///*图片大图路径*/
//- (NSString *)imagePathFormatBigSize
//{
//    return [NSString stringWithFormat:@"http://%@/api/image/showImageBySize.jsp?url=%@&width=1280", WEB_DOMAIN, self];
//}
//
///*自定义大小图片路径*/
//- (NSString *)imagePathFormatCustomSize:(CGFloat)width
//{
//    return [NSString stringWithFormat:@"http://%@/api/image/showImageBySize.jsp?url=%@&width=%f", WEB_DOMAIN, self, width];
//}

/*图片原图路径*/
- (NSString *)imagePathFormatOriginalSize
{
    return self;
}

/*转换为沙箱Documents文件夹下的路径*/
- (NSString *)documentFilePath
{
    NSString *tempPath = [self hasPrefix:@"Documents/"] ? self : [NSString stringWithFormat:@"Documents/%@", self];
    return [self hasPrefix:NSHomeDirectory()] ? self : [NSHomeDirectory() stringByAppendingPathComponent:tempPath];
}

/*是否为沙箱Documents文件夹下的路径*/
- (BOOL)isDocumentFilePath
{
    return [self hasPrefix:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]];
}

/*去除空格、换行和\r\n*/
- (NSString *)trimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/*截取小于指定长度的子串，结尾处拼接"..."*/
- (NSString *)substringWithMaxLength:(NSUInteger)maxLength
{
    if (self.length > maxLength) {//内容多于阈值
        return [NSString stringWithFormat:@"%@...", [self substringToIndex:maxLength]];
    }
    return self;
}

/*编码GBK字符串，并处理常见URL特殊字符*/
- (NSString *)GBKEncodedString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingGB_18030_2000));
}

/*编码UTF8字符串*/
- (NSString *)UTF8EncodedString
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/*编码MD5字符串*/
- (NSString *)MD5EncodedString
{
    if (self.length == 0) return nil;
    
    const char *value = self.UTF8String;
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *encodedString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [encodedString appendFormat:@"%02X", outputBuffer[count]];
    }
    return encodedString;
}

/*转换为T9数字键盘对应的数字串*/
- (NSString *)numberString
{
	NSMutableString *numberString = [NSMutableString stringWithString:@""];
	for (NSInteger i = 0; i < self.length; i++) {
		switch ([self characterAtIndex:i]) {
			case '0':
				[numberString appendString:@"0"];
				break;
                
			case '1':
				[numberString appendString:@"1"];
				break;
                
			case 'a':case 'b':case 'c':case 'A':case 'B':case 'C':case '2':
				[numberString appendString:@"2"];
				break;
                
			case 'd':case 'e':case 'f':case 'D':case 'E':case 'F':case '3':
				[numberString appendString:@"3"];
				break;
                
			case 'g':case 'h':case 'i':case 'G':case 'H':case 'I':case '4':
				[numberString appendString:@"4"];
				break;
                
			case 'j':case 'k':case 'l':case 'J':case 'K':case 'L':case '5':
				[numberString appendString:@"5"];
				break;
                
			case 'm':case 'n':case 'o':case 'M':case 'N':case 'O':case '6':
				[numberString appendString:@"6"];
				break;
                
			case 'p':case 'q':case 'r':case 's':case 'P':case 'Q':case 'R':case 'S':case '7':
				[numberString appendString:@"7"];
				break;
                
			case 't':case 'u':case 'v':case 'T':case 'U':case 'V':case '8':
				[numberString appendString:@"8"];
				break;
                
			case 'w':case 'x':case 'y':case 'z':case 'W':case 'X':case 'Y':case 'Z':case '9':
				[numberString appendString:@"9"];
				break;
                
			default:
				break;
		}
	}
	return numberString;
}

/* 格式化手机号码
 对于非中国大陆的地区，号码中有可能出现一些符号，搜索时可做特殊处理
 1、排除号码中'-'、'('、')'和空格的干扰。 
 2、字符'+'、'*'和'#'由用户输入决定，不用处理。
 3、字符','及';'不考虑。
 */
- (NSString *)formattedPhone
{
    NSString *formattedPhone = self.numberString;
    if ([formattedPhone hasPrefix:@"86"]) {
        formattedPhone = [formattedPhone substringFromIndex:2];
    } else if ([formattedPhone hasPrefix:@"086"]) {
        formattedPhone = [formattedPhone substringFromIndex:3];
    } else if ([formattedPhone hasPrefix:@"010"]) {
        formattedPhone = [formattedPhone substringFromIndex:3];
    }
    return formattedPhone;
}

/*是否为合法手机号(规则待完善)*/
- (BOOL)isValidPhone
{
    NSString *formattedPhone = self.formattedPhone;
    if (formattedPhone.length == 11) {
        if ([formattedPhone hasPrefix:@"13"] || [formattedPhone hasPrefix:@"15"] || [formattedPhone hasPrefix:@"18"]) {
            return YES;
        }
    }
    return NO;
}

/*是否为合法邮箱地址(规则待完善)*/
- (BOOL)isValidEmail
{
    NSRange matchRange = [self rangeOfString:@"@"];
    if (matchRange.length) {
        return YES;
    }
    return NO;
}

/*是否为一个图片路径*/
- (BOOL)isValidImageURL
{
    NSString *extension = [[self componentsSeparatedByString:@"."] lastObject];
    NSArray *imageExtensions = @[@"BMP", @"JPG", @"JPEG", @"PNG", @"GIF", @"PCX", @"TIFF", @"TGA", @"EXIF", @"FPX", @"SVG", @"CDR", @"PCD", @"DXF", @"UFO", @"EPS", @"HDRI", @"AI", @"RAW"];
    if ([imageExtensions containsObject:extension.uppercaseString]) {
        return YES;
    }
    return NO;
}

//是否为合法视频路径
- (BOOL)isValidVideoURL
{
    NSString *extension = [[self componentsSeparatedByString:@"."] lastObject];
    NSArray *imageExtensions = @[@"MOV", @"MP4", @"AVI", @"MKV", @"M4V", @"FLV", @"3G2", @"3GP", @"DV", @"VOB", @"DAT", @"MPE", @"MPEG", @"MPG", @"RMVB", @"RM", @"ASX", @"ASF", @"WMV"];
    if ([imageExtensions containsObject:extension.uppercaseString]) {
        return YES;
    }
    return NO;
}

//是否为合法音频路径
- (BOOL)isValidAudioURL
{
    NSString *extension = [[self componentsSeparatedByString:@"."] lastObject];
    NSArray *imageExtensions = @[@"AMR", @"MP3", @"WAV", @"WMA", @"CAF", @"MIDI"];
    if ([imageExtensions containsObject:extension.uppercaseString]) {
        return YES;
    }
    return NO;
}

/*距离描述(米)*/
- (NSString *)distanceDescription
{
    CGFloat distance = self.floatValue;
    if (distance < 1000) {
        return [NSString stringWithFormat:@"%.f00米内", distance / 100 + 1];
    } else {
        return [NSString stringWithFormat:@"%.f千米", round(distance / 1000.0)];
    }
}

@end
