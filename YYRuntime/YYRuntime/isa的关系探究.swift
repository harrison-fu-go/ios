//
//  isa的关系探究.swift
//  YYRuntime
//
//  Created by HarrisonFu on 2023/10/8.
//

/**
 可以从： #import<objc/objc.h> 查看 id 类型的定义
 
 1. 实例对象的isa指向类对象。
 2. 类对象的super_class 指向 父类对象
 3. 类对象的isa指向类对象的元类  如： isa(NSString) -> NSString(meta)
 4. 元类对象的isa指向：根元类（meta） isa(NSString(meta)) -> Root(meta)
 5. 根元类的isa指向： 根元类（meta）
 
 可能用到的认证方法：
 [p class] == [YYTestModel class], //表示类对象。
 object_getClass(p) //获取一个对象的isa指向
 class_isMetaClass（p）//判断一个对象是否是元类。
 

 **/
