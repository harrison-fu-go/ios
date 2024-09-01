//
//  YYSHA256.m
//  YYOCLearning
//
//  Created by HarrisonFu on 2024/4/18.
//

#import "YYSHA256.h"

@implementation YYSHA256

//对data的sha256签名处理
+ (NSData*)sha256:(NSData *)keyData{
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *outdata = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return outdata;
}

-(NSData *)strToDataWithString:(NSString *)str {
    if (!str || [str length] == 0){
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange (0, 2);
    } else {
        range = NSMakeRange (0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range. location += range.length;
        range. length = 2;
    }
    return hexData;
}



@end
