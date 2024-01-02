//
//  ViewController.m
//  YYRuntime
//
//  Created by 符华友 on 2021/12/9.
//
#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "YYTestModel.h"
#import<objc/objc.h>
@interface ViewController ()
@property(nonatomic, strong)NSString *name;
@property(nonatomic, assign)int age;
@end

/**
 OC 消息传递步骤：
 pc的方法调用都是类似[receiver selector]的形式，其实每次都是一个运行时消息发送过程。
 第一步：编译阶段
 receiver selectorl方法被编译器转化，分为两种情況：
 11.不带参数的方法被编译为：objc_msgSend(receiver, selector)
 2.带参数的方法被编译为：objc_msgSend (recevier, selector, org1, org2, .)
 
 第二步：运行时阶段
 消息接收者recever寻找对应的selector， 也分为两种情况：
 
 1.接收者能找到对应的selector，直接执行接收receiver对象的selector方法。
 
 2,接收者找不到对应的selector，消息被转发或者临时向接收者添加这个selector对应的实现内容，否则崩溃。
    a. 消息动态解析
    b. 消息接受者重定向
    c. 消息重定向
    d. 消息异常处理
 */

/**
扩展： OC 实现多继承的使用情况。
比如： SubClass, SuperClass
 1. SubClass 利用消息转发的功能。forwardInvocation， 把收到的消息转发到SuperClass，实现类似继承的效果。
 2. 转发给不同的SuperClass1，则就像多继承的实现结果。
 */

@implementation ViewController {
    NSString *country;
    NSString *address;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name = @"fhy";
    YYTestModel *model = [[YYTestModel alloc] init];
    model.name = @"model...";
    
    //properties.
    NSLog(@"-----------------getProperties-----------------");
    [ViewController getProperties:[ViewController class]];
    
    //ivrs
    NSLog(@"-----------------getIvars-----------------");
    [ViewController getIvars:[ViewController class]];
    
    NSLog(@"-----------------getMethodList-----------------");
    [ViewController getMethodList];
    
    //class method list.
    NSLog(@"-----------------getClassMehtod-----------------");
    [ViewController getClassMehtod];
    NSLog(@"-----------------end-----------------");
    Ivar var = class_getInstanceVariable([ViewController class], "_name");
    id value = object_getIvar(self, var);
    NSLog(@"value name====== %@",value);
    
    NSLog(@"-----------------动态解析，动态添加方法-----------------");
    [YYTestModel sayHi:@"??? BIBIII....."];
    int count = [[[YYTestModel alloc] init] sayHello:@"dfsds"];
    NSLog(@"count value====== %d", count);
    
    NSLog(@"-----------------消息接受者重定向-----------------");
    [ViewController performSelector:@selector(classSayHi:) withObject:@"消息接受者重定向"];
    [self performSelector:@selector(instanceSayHello:) withObject:@"消息接受者重定向"];
    
    NSLog(@"-----------------消息重定向-----------------");
    [self performSelector:@selector(sayHello:) withObject:@"消息重定向"];
    
    
    NSLog(@"-----------------探究ISA指针-----------------");
    YYTestModel *p = [[YYTestModel alloc] init];
    Class c1 = [p class];
    Class c2 = [YYTestModel class];
    NSLog(@"探究ISA指针： %d", c1 == c2); //true
    
    //输出1
    NSLog(@"类对象是否相等：%d", [p class] == object_getClass(p));
    //输出0
    NSLog(@"类对象是否是否是元类：%d", class_isMetaClass(object_getClass(p)));
    //输出1
    NSLog(@"类对象的ISA指向 类的元类：%d", class_isMetaClass(object_getClass([YYTestModel class])));
    //输出0
    NSLog(@"类对象，类对象的元类，肯定不相等的：%d", object_getClass(p) == object_getClass([YYTestModel class]));
    NSLog(@"-----------------end-----------------");
}

+ (void)getMethodList
{
    unsigned int count;// 记录属性个数
    Method *methods = class_copyMethodList([ViewController class], &count);
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        Method method = methods[i];
        // 获取属性的名称 C语言字符串
        
        const char *cName = sel_getName(method_getName(method));
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSLog(@"method_getName name====== %@",name);
    }
}

+ (void)getIvars:(Class)cls{
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    Ivar *ivars = class_copyIvarList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        Ivar property = ivars[i];
        // 获取属性的名称 C语言字符串
        const char *cName = ivar_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
        
        NSLog(@"ivars name====== %@",name);
    }
    free(ivars);
}


+ (void)getProperties:(Class)cls{
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
        
        NSLog(@"property name====== %@",name);
    }
}

+ (void)getClassMehtod {
    
    Class metaClass = object_getClass([self class]);
    unsigned int count;// 记录属性个数
    Method *methods = class_copyMethodList(metaClass, &count);
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        Method method = methods[i];
        // 获取属性的名称 C语言字符串
        
        const char *cName =sel_getName(method_getName(method));
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        NSLog(@"getClassMehtod name====== %@",name);
    }
}

#pragma mark- ------------消息接受者重定向 ------------
//- (int)instanceSayHello:(NSString *)message {
//    NSLog(@"==========view controller  instanceSayHello: %@", message);
//    return 4;
//}
//
//+ (void)classSayHi:(NSString *)hi {
//    NSLog(@"==========view controller classSayHi: %@", hi);
//}
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(classSayHi:)) {
        return [YYTestModel class];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(instanceSayHello:)) {
        return [[YYTestModel alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark- -------------消息重定向（消息转发）------------
/**
 消息重定向可以实现广播的效果。
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = anInvocation.selector;
    YYTestModel *model = [[YYTestModel alloc] init];
    if ([model respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:model];
        [anInvocation invokeWithTarget:[[YYTestModel alloc] init]];
    } else {
        [self doesNotRecognizeSelector:selector];
    }
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector: aSelector];
    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:"i@:*"];
    }
    return signature;
}



@end
