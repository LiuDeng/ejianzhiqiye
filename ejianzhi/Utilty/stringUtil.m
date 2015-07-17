//
//  stringUtil.m
//  myPassWordWallet
//
//  Created by 田原 on 14-2-27.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "stringUtil.h"

@implementation stringUtil
+(NSString*)formatMyString:(NSString*)getString{
    NSString *strUrl = [getString stringByReplacingOccurrencesOfString:@" " withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"/" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@">" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@":" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"-" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"." withString:@""];
    return strUrl;
}

+(BOOL)isEmpty:(NSString *)string{
    @try {
        if ([string isEqual:[NSNull null]]) {
            return TRUE;
        }
        if ([string isEqualToString:@"null"] || [string isEqualToString:@"<null>"]) {
            return TRUE;
        }
        if (string == Nil) {
            return TRUE;
        }
        if (string.length == 0) {
            return TRUE;
        }
    }
    @catch (NSException *exception) {
            return TRUE;
    }
    return FALSE;
}
//文字长度
+(NSUInteger) lenghtWithString:(NSString *)string{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return len + numMatch;
}

//格式话小数 四舍五入类型
+(NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    //  NSLog(@"----%@---",[self decimalwithFormat:@"0.0000" floatV:0.334569]);
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}
@end
