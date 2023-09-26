//
//  NSString+GS.h
//  GoSund
//
//  Created by 符华友 on 2021/10/12.
//

#import <Foundation/Foundation.h>


@interface NSString (GS)

- (BOOL)isNotEmpty;
+ (BOOL)isEmpty:(NSString *)value;
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGSize)sizeWithLH:(float)lineHeight font:(UIFont *)font  maxSize:(CGSize)maxSize;
- (CGSize)sizeWithLH:(float)lineHeight font:(UIFont *)font  maxSize:(CGSize)maxSize lineBreakMode:(NSInteger)breakModel;
- (BOOL)isAllNumber:(int)count;
- (NSString *)trim;
+ (BOOL)isGsEmail:(NSString *)email;
+ (BOOL)isGsPhone:(NSString *)phone;
+ (BOOL)isGsLoginPhone:(NSString *)phone;
- (BOOL)isGsPassword;
- (NSString *)phonePart;
- (BOOL)isWholeNumber;
- (NSAttributedString *)attributedLh:(float)lineHeight font:(UIFont *)font color:(UIColor *)color;

- (NSAttributedString *)attributedLh:(float)lineHeight
                                  fs:(float)fontSize
                                  fw:(UIFontWeight)fontWeight
                               color:(UIColor *)color;

- (NSAttributedString *)attributedLh:(float)lineHeight
                                font:(UIFont *)font
                               color:(UIColor *)color
                           textAlign:(NSTextAlignment)align;

- (NSAttributedString *)attributedLh:(float)lineHeight
                                font:(UIFont *)font
                               color:(UIColor *)color
                           textAlign:(NSTextAlignment)align
                       lineBreakMode:(NSInteger)breakModel;
@end

