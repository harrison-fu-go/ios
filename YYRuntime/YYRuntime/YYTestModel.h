//
//  YYTestModel.h
//  YYRuntime
//
//  Created by HarrisonFu on 2023/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYTestModel : NSObject

@property(nonatomic, strong)NSString *name;

- (int)sayHello:(NSString *)message;

+ (void)sayHi:(NSString *)hi;

- (int)instanceSayHello:(NSString *)message;
+ (void)classSayHi:(NSString *)hi;

@end

NS_ASSUME_NONNULL_END
