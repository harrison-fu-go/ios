//
//  YYSHA256.h
//  YYOCLearning
//
//  Created by HarrisonFu on 2024/4/18.
//
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYSHA256 : NSObject

+ (NSData*)sha256:(NSData *)keyData;

@end

NS_ASSUME_NONNULL_END
