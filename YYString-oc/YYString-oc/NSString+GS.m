//
//  NSString+GS.m
//  GoSund
//
//  Created by 符华友 on 2021/10/12.
//

#import "NSString+GS.h"

@implementation NSString (GS)

- (BOOL)isNotEmpty
{
    if (self == nil) {
        return NO;
    }
    NSString *tem = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([tem isEqualToString:@""]) {
        return NO;
    }
    return YES;
}


+ (BOOL)isEmpty:(NSString *)value
{
    if (!value || [value isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    return textSize;
}

- (CGSize)sizeWithLH:(float)lineHeight font:(UIFont *)font  maxSize:(CGSize)maxSize
{
    return [self sizeWithLH:lineHeight font:font maxSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize)sizeWithLH:(float)lineHeight font:(UIFont *)font  maxSize:(CGSize)maxSize lineBreakMode:(NSInteger)breakModel
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.lineSpacing = 0;
    paragraphStyle.lineBreakMode = breakModel;
    NSDictionary *attDic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:attDic
                              context:nil].size;
}

- (BOOL)isAllNumber:(int)count
{
    if (count == 0) {
        return NO;
    }
    NSString *tem = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *numRegex = [NSString stringWithFormat:@"^\\d{%d}$",count];
    NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    return [numPredicate evaluateWithObject:tem];
}

- (BOOL)isWholeNumber
{
    if ([NSString isEmpty:self]) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)isGsEmail:(NSString *)email
{
    if ([self isEmpty:email]) {
        return NO;
    }
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isGsPhone:(NSString *)phone
{
    if ([self isEmpty:phone]) {
        return NO;
    }
    
    if (![phone containsString:@"-"]) {
        return [phone isAllNumber:11];
    } else {
        NSArray *values = [phone componentsSeparatedByString:@"-"];
        if (values.count > 1) {
            return [values[1] isAllNumber:11];
        } else {
            return NO;
        }
    }
}

/**
 登录的时候，纯数字即： 手机
 */
+ (BOOL)isGsLoginPhone:(NSString *)phone
{
    if ([self isEmpty:phone]) {
        return NO;
    }
    
    if (![phone containsString:@"-"]) {
        return [phone isWholeNumber];
    } else {
        NSArray *values = [phone componentsSeparatedByString:@"-"];
        if (values.count > 1) {
            return [values[1] isWholeNumber];
        } else {
            return NO;
        }
    }
}


- (NSString *)phonePart
{
    if (![self containsString:@"-"]) {
        return self;
    } else {
        NSArray *values = [self componentsSeparatedByString:@"-"];
        if (values.count > 1) {
            return values[1];
        } else {
            return nil;
        }
    }
}


- (BOOL)isGsPassword
{
    //去掉收尾的字符串
    NSString *pwd = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * regex = @"^[A-Za-z0-9]{6,20}$";//正则表达式
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:pwd]) { //长度
        return NO;
    }
    //数字
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:pwd
                                                                           options:NSMatchingReportProgress
                                                                             range:NSMakeRange(0, pwd.length)];
   //英文字条件
   NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:pwd options:NSMatchingReportProgress range:NSMakeRange(0, pwd.length)];
    if (tNumMatchCount == pwd.length || tLetterMatchCount == pwd.length) {
        return NO;
    }
    return YES;
}

- (NSAttributedString *)attributedLh:(float)lineHeight font:(UIFont *)font color:(UIColor *)color
{
    return [self attributedLh:lineHeight font:font color:color textAlign:NSTextAlignmentCenter];
}

- (NSAttributedString *)attributedLh:(float)lineHeight
                                font:(UIFont *)font
                               color:(UIColor *)color
                         textAlign:(NSTextAlignment)align
{
    return [self attributedLh:lineHeight font:font color:color textAlign:align lineBreakMode:-1];
}

- (NSAttributedString *)attributedLh:(float)lineHeight
                                font:(UIFont *)font
                               color:(UIColor *)color
                           textAlign:(NSTextAlignment)align
                       lineBreakMode:(NSInteger)breakMode
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.lineSpacing = 0;
    if (breakMode != -1) {
        paragraphStyle.lineBreakMode = breakMode;
    }
    paragraphStyle.alignment = align;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (lineHeight - font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    if(color){
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    [attributes setObject:font forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:self attributes:attributes];
}

          
- (NSAttributedString *)attributedLh:(float)lineHeight
                                  fs:(float)fontSize
                                  fw:(UIFontWeight)fontWeight
                               color:(UIColor *)color
{
    UIFont *font = [UIFont systemFontOfSize:fontSize weight:fontWeight];
    return [self attributedLh:lineHeight font:font color:color];
}


@end
