//
//  ViewController.m
//  YYRuntime
//
//  Created by 符华友 on 2021/12/9.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface ViewController ()
@property(nonatomic, strong)NSString *name;
@property(nonatomic, assign)int age;
@end

@implementation ViewController {
    NSString *country;
    NSString *address;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name = @"fhy";
    //properties.
    [ViewController getProperties:[ViewController class]];
    //ivrs
    [ViewController getIvars:[ViewController class]];
    
    [ViewController getMethodList];
    //class method list.
    [ViewController getClassMehtod];
    //
    Ivar var = class_getInstanceVariable([ViewController class], "_name");
    id value = object_getIvar(self, var);
    NSLog(@"value name====== %@",value);
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
        
        const char *cName =sel_getName(method_getName(method));
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



+ (void)getClassMehtod
{
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

@end
