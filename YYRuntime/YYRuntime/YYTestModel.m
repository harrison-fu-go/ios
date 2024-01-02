//
//  YYTestModel.m
//  YYRuntime
//
//  Created by HarrisonFu on 2023/10/8.
//

#import "YYTestModel.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation YYTestModel


/**
 消息动态解析。
 1. 如果 类/实例无法找到指定的函数，则走 resolveClassMethod / resolveInstanceMethod，动态添加函数。
 2. 如果 消息动态解析 return YES. 则证明消息动态解决执行了，动态添加函数成功。
 3. 如果 消息动态解析 return NO. 则走： forwardingTargetForSelector， 该函数分为类或者实例
 */
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(sayHi:)) {
        class_addMethod(object_getClass(self),
                        sel,
                        class_getMethodImplementation(object_getClass(self), @selector(re_sayHI:)), "v@");
        return YES;
    }
    return [class_getSuperclass(object_getClass(self)) resolveClassMethod:sel];
}

/**
 重定向实例的函数。
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(sayHello:)) {
        class_addMethod([self class],
                        sel,
                        class_getMethodImplementation([self class], @selector(re_sayHello:)), "v@");
        return YES;
    }
    return [class_getSuperclass([self class]) resolveInstanceMethod:sel];
}


+ (void)re_sayHI:(NSString *)hi {
    NSLog(@"==========re_sayHI: %@", hi);
}


- (int)re_sayHello:(NSString *)hello {
    NSLog(@"==========re_SayHello: %@", hello);
    return 5;
}

- (int)instanceSayHello:(NSString *)message {
    NSLog(@"==========instanceSayHello: %@", message);
    return 4;
}

+ (void)classSayHi:(NSString *)hi {
    NSLog(@"==========classSayHi: %@", hi);
}

@end
